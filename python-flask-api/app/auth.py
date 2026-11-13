from functools import wraps

from firebase_admin import auth
from flask import current_app, g, jsonify, request


def is_business_user(user_id):
    db = current_app.config['FIRESTORE_CLIENT']
    business = db.collection('businesses').document(user_id).get()
    return business.exists and not business.to_dict().get('is_deleted', False)


def require_auth(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        authorization = request.headers.get('Authorization', '')
        scheme, _, token = authorization.partition(' ')
        if scheme.lower() != 'bearer' or not token:
            return jsonify({'error': 'Authentication required'}), 401

        try:
            decoded_token = auth.verify_id_token(token)
        except (auth.InvalidIdTokenError, auth.ExpiredIdTokenError,
                auth.RevokedIdTokenError, ValueError):
            return jsonify({'error': 'Invalid or expired authentication token'}), 401

        g.user_id = decoded_token['uid']
        return view(*args, **kwargs)

    return wrapped


def require_business(view):
    @wraps(view)
    @require_auth
    def wrapped(*args, **kwargs):
        if not is_business_user(g.user_id):
            return jsonify({'error': 'Business account required'}), 403
        return view(*args, **kwargs)

    return wrapped


def require_self_or_business(resource_user_id):
    return g.user_id == resource_user_id or is_business_user(g.user_id)
