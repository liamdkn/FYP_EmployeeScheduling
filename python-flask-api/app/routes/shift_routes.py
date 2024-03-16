from flask import Blueprint, jsonify, request
from flask_cors import CORS
from app.services.shift_service import get_shifts, create_shifts

shift_blueprint = Blueprint('shift', __name__)
CORS(shift_blueprint)

@shift_blueprint.route('/shifts', methods=['GET'])
def get_shifts_route():
    shifts = get_shifts()
    return jsonify(shifts)

@shift_blueprint.route('/shifts', methods=['POST'])
def add_shifts_route():
    shifts_data = request.json
    response_data, status_code = create_shifts(shifts_data)
    return jsonify(response_data), status_code

