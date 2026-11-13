import unittest
from unittest.mock import patch

from flask import Flask, g, jsonify

from app.auth import require_auth, require_business


class FakeDocument:
    def __init__(self, exists=False, data=None):
        self.exists = exists
        self._data = data or {}

    def to_dict(self):
        return self._data


class FakeCollection:
    def __init__(self, document):
        self._document = document

    def document(self, _document_id):
        return self

    def get(self):
        return self._document


class FakeFirestore:
    def __init__(self, business=None):
        self.business = business or FakeDocument()

    def collection(self, _name):
        return FakeCollection(self.business)


class AuthenticationTests(unittest.TestCase):
    def setUp(self):
        self.app = Flask(__name__)
        self.app.config['FIRESTORE_CLIENT'] = FakeFirestore()

        @self.app.get('/authenticated')
        @require_auth
        def authenticated():
            return jsonify({'user_id': g.user_id})

        @self.app.get('/business')
        @require_business
        def business():
            return jsonify({'user_id': g.user_id})

        self.client = self.app.test_client()

    def test_missing_token_is_rejected(self):
        response = self.client.get('/authenticated')
        self.assertEqual(response.status_code, 401)

    @patch('app.auth.auth.verify_id_token', return_value={'uid': 'user-1'})
    def test_valid_token_sets_authenticated_user(self, _verify):
        response = self.client.get(
            '/authenticated', headers={'Authorization': 'Bearer token'}
        )
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.get_json()['user_id'], 'user-1')

    @patch('app.auth.auth.verify_id_token', return_value={'uid': 'employee-1'})
    def test_employee_cannot_use_business_route(self, _verify):
        response = self.client.get(
            '/business', headers={'Authorization': 'Bearer token'}
        )
        self.assertEqual(response.status_code, 403)

    @patch('app.auth.auth.verify_id_token', return_value={'uid': 'business-1'})
    def test_business_can_use_business_route(self, _verify):
        self.app.config['FIRESTORE_CLIENT'] = FakeFirestore(
            FakeDocument(exists=True, data={'is_deleted': False})
        )
        response = self.client.get(
            '/business', headers={'Authorization': 'Bearer token'}
        )
        self.assertEqual(response.status_code, 200)


if __name__ == '__main__':
    unittest.main()
