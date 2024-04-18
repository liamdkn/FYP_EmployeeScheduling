import json
from flask import Flask
from flask_cors import CORS
from google.cloud import firestore
from flask_mail import Mail

from app.routes.employee_routes import employee_blueprint
from app.routes.shift_routes import shift_blueprint
from app.routes.roster_routes import roster_blueprint
from app.routes.requests_routes import request_blueprint
from app.routes.business_routes import business_blueprint
from app.routes.user_routes import user_blueprint


app = Flask(__name__)
CORS(app)

# Configuration for Flask-Mail
app.config['MAIL_SERVER'] = 'smtp.example.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'your_email@example.com'
app.config['MAIL_PASSWORD'] = 'your_email_password'

mail = Mail(app)

json_key_path = '/Users/liamdurkan/Repositories/FYP_EmployeeScheduling/python-flask-api/rostergenerator2-firebase-adminsdk-nu4ix-f5e7b904a7.json'
cred = json.loads(open(json_key_path).read())

# single firestore instance
db = firestore.Client.from_service_account_info(cred)
app.config['FIRESTORE_CLIENT'] = db

app.register_blueprint(employee_blueprint)
app.register_blueprint(shift_blueprint)
app.register_blueprint(roster_blueprint)
app.register_blueprint(request_blueprint)
app.register_blueprint(business_blueprint)
app.register_blueprint(user_blueprint)

if __name__ == '__main__':
    app.run(port=5000, debug=True)
