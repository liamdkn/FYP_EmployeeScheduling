from flask import Blueprint, jsonify, request
from flask_cors import CORS
from app.services.business_service import create_business

business_blueprint = Blueprint('business', __name__)
CORS(business_blueprint)

@business_blueprint.route('/business', methods=['POST'])
def create_business_route():
    business_data = request.json
    business_id = create_business(business_data)
    return jsonify({'business_id': business_id}), 201


@business_blueprint.route('/business/<business_id>', methods=['GET'])
def get_business_by_id_route(business_id):
    business = get_business_by_id(business_id)
    if business:
        return jsonify(business), 200
    else:
        return jsonify({'error': 'Business not found'}), 404