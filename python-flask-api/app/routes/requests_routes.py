from flask import Blueprint, jsonify, request
from flask_cors import CORS
from app.services.requests_service import create_request, get_all_requests
import traceback 

request_blueprint = Blueprint('requests', __name__)
CORS(request_blueprint)

@request_blueprint.route('/requests', methods=['POST'])
def create_request_route():
    try:
        request_data = request.json
        print(request_data)

        response_data = create_request(request_data)
        return jsonify(response_data), 201
    except Exception as e:
        print("Error in requesst route")
        traceback.print_exc()
        return jsonify({'error': 'Internal Server Error'}), 500


@request_blueprint.route('/requests', methods=['GET'])
def get_requests_route():
    try:
        requests_data = get_all_requests()
        requests_dict = [request.to_dict() for request in requests_data]
        return jsonify(requests_dict), 200
    except Exception as e:
        print(f"An error occurred: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500



