import json
from flask import Flask, jsonify, request
from google.cloud import firestore

app = Flask(__name__)

cred = json.loads(open('python-flask-api/rostergenerator-6bee3-firebase-adminsdk-ptvgm-4dfb90a923.json').read())
db = firestore.Client.from_service_account_info(cred)

employees_ref = db.collection('employees')

class Employee:
    @app.route('/employees', methods=['GET'])
    def get_employees():
        employees = [doc.to_dict() for doc in employees_ref.stream()]
        print("employees")
        return jsonify(employees)

    @app.route('/employees', methods=['POST'])
    def create_employee():
        
        employee_data = request.json

        new_employee_ref = employees_ref.add(employee_data)

        return jsonify(), 201

if __name__ == '__main__':
    app.run(port=5000)
