from flask import Blueprint, jsonify, request
from flask_cors import CORS
from app.services.employee_service import get_employee, get_employees, create_employee

employee_blueprint = Blueprint('employee', __name__)
CORS(employee_blueprint)

@employee_blueprint.route('/employees', methods=['POST'])
def create_employee_route():
    employee_data = request.json
    response_data, status_code = create_employee(employee_data)
    return jsonify(response_data), status_code

@employee_blueprint.route('/employee/<string:employee_id>', methods=['GET'])
def get_employee_route(employee_id):
    employee = get_employee(employee_id)
    return jsonify(employee.to_dict())

@employee_blueprint.route('/employees', methods=['GET'])
def get__employees_route():
    employees = get_employees()
    return jsonify(employees)





