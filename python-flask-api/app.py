import json
from flask import Flask
from flask_cors import CORS
from app.routes.employee_routes import employee_blueprint
from google.cloud import firestore

app = Flask(__name__)

cred = json.loads(open('python-flask-api/rostergenerator-6bee3-firebase-adminsdk-ptvgm-4dfb90a923.json').read())
db = firestore.Client.from_service_account_info(cred)

app.register_blueprint(employee_blueprint, db=db)

if __name__ == '__main__':
    app.run(port=5000)
