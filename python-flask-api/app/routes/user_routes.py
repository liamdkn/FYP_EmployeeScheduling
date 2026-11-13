from flask import Blueprint, g, jsonify
from app.auth import require_auth
from app.services.employee_service import is_user_employee
from app.services.business_service import is_user_business

user_blueprint = Blueprint('user', __name__)

@user_blueprint.route('/user/<string:user_id>', methods=['GET'])
@require_auth
def get_user_type(user_id):
    try:
        if user_id != g.user_id:
            return jsonify({'error': 'Forbidden'}), 403
        user_type = None
        if is_user_employee(user_id):
            user_type = 'employee'
        elif is_user_business(user_id):
            user_type = 'business'
        
        if user_type:
            return jsonify({'user_id': user_id, 'user_type': user_type}), 200
        else:
            return jsonify({'error': 'User not found or has no type'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500
