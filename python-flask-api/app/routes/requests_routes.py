from flask import Blueprint, jsonify, request
from app.services.requests_service import *
import traceback 

request_blueprint = Blueprint('requests', __name__)

@request_blueprint.route('/requests', methods=['POST'])
def create_request_route():
    try:
        request_data = request.json
        user_id = request.headers.get('User-id')

        response_data = create_request(request_data, user_id)
        return jsonify(response_data), 201
    except Exception as e:
        print("Error in requesst route")
        traceback.print_exc()
        return jsonify({'error': 'Internal Server Error'}), 500


@request_blueprint.route('/requests', methods=['GET'])
def get_requests_route():
    try:
        user_id = request.headers.get('User-id')
        requests_data = get_all_requests(user_id)
        requests_dict = [request.to_dict() for request in requests_data]
        return jsonify(requests_dict), 200
    except Exception as e:
        print(f"An error occurred: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500


@request_blueprint.route('/requests/approve/<string:request_id>', methods=['PUT'])
def approve_request_route(request_id):
    try:
        response_data = approve_request(request_id)
        return jsonify(response_data), 200
    except Exception as e:
        print("Error in approve request route")
        traceback.print_exc()
        return jsonify({'error': 'Internal Server Error'}), 500

@request_blueprint.route('/requests/deny/<string:request_id>', methods=['PUT'])
def deny_request_route(request_id):
    try:
        response_data = deny_request(request_id)
        return jsonify(response_data), 200
    except Exception as e:
        print("Error in deny request route")
        traceback.print_exc()
        return jsonify({'error': 'Internal Server Error'}), 500

