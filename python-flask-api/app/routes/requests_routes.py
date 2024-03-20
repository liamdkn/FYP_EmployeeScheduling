from flask import Blueprint, jsonify, request
from flask_cors import CORS
from app.services.requests_service import create_request

request_blueprint = Blueprint('request', __name__)
CORS(request_blueprint)

@request_blueprint.route('/request', methods=['POST'])
def create_request_route():
    request_data = request.json
    response_data, status_code = create_request(request_data)
    return jsonify(response_data), status_code

#@shift_blueprint.route('/requests', methods=['GET'])
###def get_requests_route():
#    requests = get_requests()
 #   return jsonify(requests)



