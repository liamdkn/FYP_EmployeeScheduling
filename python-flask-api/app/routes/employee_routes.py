import json
from flask import Blueprint, jsonify, request
from flask_cors import CORS
from google.cloud import firestore

cred = json.loads(open('python-flask-api/rostergenerator-6bee3-firebase-adminsdk-ptvgm-4dfb90a923.json').read())
db = firestore.Client.from_service_account_info(cred)

employee_blueprint = Blueprint('employee', __name__)
employees_ref = db.collection('employees')

@employee_blueprint.route('/employees', methods=['GET'])
def get_employees():
    employees = [doc.to_dict() for doc in employees_ref.stream()]
    return jsonify(employees)

@employee_blueprint.route('/employees', methods=['POST'])
def create_employee():
    employee_data = request.json
    new_employee_ref = employees_ref.add(employee_data)

    response_data = {
    "status": "Employee data retrieved successfully",
    "employee_data": employee_data
    }
    return jsonify(response_data), 201
