from flask import Blueprint, jsonify, request
from app.services.shift_service import get_shifts, create_shifts
import traceback 

shift_blueprint = Blueprint('shift', __name__)

@shift_blueprint.route('/shifts', methods=['POST'])
def create_shifts_route():
    try:
        shifts_data = request.json
        response_data = create_shifts(shifts_data)
        return jsonify({'shifts_id': response_data}), 201
    except Exception as e:
        traceback.print_exc()
        return jsonify({'error': str(e), 'stack_trace': traceback.format_exc()}), 400


@shift_blueprint.route('/shifts', methods=['GET'])
def get_shifts_route():
    shifts = get_shifts()
    return jsonify(shifts)

'''

@shift_blueprint.route('/shifts/<string:shifts_id>', methods=['GET'])
def get_shifts_by_id_route():
    shifts = get_shifts_by_id()
    return jsonify(shifts)


@shift_blueprint.route('/shifts', methods=['POST'])
def add_shifts_route():
    shifts_data = request.json
    response_data, status_code = create_shifts(shifts_data)
    return jsonify(response_data), status_code

'''
