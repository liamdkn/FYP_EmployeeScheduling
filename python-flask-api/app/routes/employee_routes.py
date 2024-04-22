from flask import Blueprint, jsonify, request
from flask_cors import CORS
from app.services.employee_service import *
from app.services.requests_service import get_approved_requests
from app.models.employee_model import Employee
from app.models.shift_model import Ind_Shift



employee_blueprint = Blueprint('employee', __name__)
CORS(employee_blueprint)

@employee_blueprint.route('/employees', methods=['POST'])
def create_employee_route():
    employee_data = request.json
    response_data, status_code = create_employee(employee_data)
    return jsonify(response_data), status_code

@employee_blueprint.route('/employees/<string:employee_id>', methods=['GET'])
def get_employee_route(employee_id):
    try:
        employee = get_employee(employee_id)
        return jsonify(employee.to_dict()), 200
    except Exception as e:
        return jsonify({'error': 'Employee not found'}), 500
    

@employee_blueprint.route('/employees', methods=['GET'])
def get_employees_route():
    try:
        employees = get_employees()
        employees_data = [employee.to_dict() for employee in employees]
        return jsonify(employees_data), 200
    except Exception as e:
        return jsonify({'error': 'Employee not found'}), 500


@employee_blueprint.route('/employees/<string:employee_id>', methods=['PUT'])
def delete_employee_route(employee_id):
    response_data, status_code = soft_delete_employee(employee_id)
    if status_code == 200:
        return jsonify({'message': response_data['status']}), 200
    elif status_code == 404:
        return jsonify({'error': 'Employee not found'}), 404
    else:
        return jsonify({'error': response_data['error']}), 500


@employee_blueprint.route('/employees/edit/<string:employee_id>', methods=['PUT'])
def edit_employee_route(employee_id):
    try:
        employee_data = request.json
        response_data, status_code = edit_employee(employee_id, employee_data)
        return jsonify(response_data), status_code
    except Exception as e:
        return jsonify({'error': f'Error editing employee: {str(e)}'}), 500



@employee_blueprint.route('/employees/avacheck', methods=['POST'])
def employee_availability_check():
    try:
        request_data = request.json
        employee = request_data.get('employee')
        shift = request_data.get('shift')
        approved_requests = get_approved_requests()

        if employee and shift:
            shift = Ind_Shift(**shift)
            employee = Employee(**employee)
            is_available = is_employee_available(employee, shift, approved_requests)
            return jsonify({'is_available': is_available}), 200
        else:
            return jsonify({'error': 'Employee or shift data missing in the request'}), 400

    except Exception as e:
        traceback.print_exc()
        return jsonify({'error': f'Error checking employee availability: {str(e)}'}), 500



