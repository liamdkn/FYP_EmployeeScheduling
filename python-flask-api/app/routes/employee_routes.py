from flask import Blueprint, jsonify, request
from flask_cors import CORS
from app.services.employee_service import get_all_employees, create_new_employee

employee_blueprint = Blueprint('employee', __name__)
CORS(employee_blueprint)

@employee_blueprint.route('/employees', methods=['GET'])
def get_employees():
    employees = get_all_employees()
    return jsonify(employees)

@employee_blueprint.route('/employees', methods=['POST'])
def add_employee():
    employee_data = request.json
    response_data, status_code = create_new_employee(employee_data)
    return jsonify(response_data), status_code
