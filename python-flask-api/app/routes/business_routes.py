from flask import Blueprint, g, jsonify, request
from app.auth import require_auth
from app.services.business_service import *

business_blueprint = Blueprint('business', __name__)

@business_blueprint.route('/business', methods=['POST'])
@require_auth
def create_business_route():
    business_data = request.json
    if not isinstance(business_data, dict):
        return jsonify({'error': 'JSON object required'}), 400
    if business_data.get('business_id') != g.user_id:
        return jsonify({'error': 'Business ID must match authenticated user'}), 403
    business_id = create_business(business_data)
    return jsonify({'business_id': business_id}), 201


import traceback

@business_blueprint.route('/business/<business_id>', methods=['GET'])
@require_auth
def get_business_by_id_route(business_id):
    try:
        if business_id != g.user_id:
            return jsonify({'error': 'Forbidden'}), 403
        business = get_business_by_id(business_id)
        if business:
            business_dict = business.to_dict()
            return jsonify(business_dict), 200
        else:
            return jsonify({'error': 'Business not found'}), 404
    except Exception as e:
        traceback.print_exc()
        return jsonify({'error': 'Internal server error'}), 500
