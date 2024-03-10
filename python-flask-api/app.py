import json
from flask import Flask
from flask_cors import CORS
from google.cloud import firestore
from app.routes.employee_routes import employee_blueprint
from app.routes.shift_routes import shift_blueprint

app = Flask(__name__)
CORS(app)

json_key_path = '/Users/liamdurkan/Repositories/FYP_EmployeeScheduling/python-flask-api/rostergenerator-6bee3-firebase-adminsdk-ptvgm-4dfb90a923.json'
cred = json.loads(open(json_key_path).read())

# single firestore instance
db = firestore.Client.from_service_account_info(cred)
app.config['FIRESTORE_CLIENT'] = db

app.register_blueprint(employee_blueprint)
app.register_blueprint(shift_blueprint)

if __name__ == '__main__':
    app.run(port=5000)
