import os

import firebase_admin
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

firebase_project = os.environ.get('GOOGLE_CLOUD_PROJECT')
try:
    firebase_admin.get_app()
except ValueError:
    options = {'projectId': firebase_project} if firebase_project else None
    firebase_admin.initialize_app(options=options)

cors_origins = [
    origin.strip()
    for origin in os.environ.get(
        'CORS_ORIGINS',
        'http://localhost:3000,http://localhost:5000,http://localhost:8080',
    ).split(',')
    if origin.strip()
]
CORS(app, resources={r'/*': {'origins': cors_origins}})

# Configuration for Flask-Mail
app.config['MAIL_SERVER'] = os.environ.get('MAIL_SERVER', 'smtp.example.com')
app.config['MAIL_PORT'] = int(os.environ.get('MAIL_PORT', '587'))
app.config['MAIL_USE_TLS'] = os.environ.get('MAIL_USE_TLS', 'true').lower() == 'true'
app.config['MAIL_USE_SSL'] = os.environ.get('MAIL_USE_SSL', 'false').lower() == 'true'
app.config['MAIL_USERNAME'] = os.environ.get('MAIL_USERNAME')
app.config['MAIL_PASSWORD'] = os.environ.get('MAIL_PASSWORD')
app.config['MAIL_DEFAULT_SENDER'] = os.environ.get(
    'MAIL_DEFAULT_SENDER', 'no-reply@example.com'
)

mail = Mail(app)

@app.route('/')
def index():
    return 'Welcome to My Flask App'

# Uses Application Default Credentials. For local development, set
# GOOGLE_APPLICATION_CREDENTIALS to a service-account file stored outside Git.
db = firestore.Client(project=firebase_project or None)
app.config['FIRESTORE_CLIENT'] = db

app.register_blueprint(employee_blueprint)
app.register_blueprint(shift_blueprint)
app.register_blueprint(roster_blueprint)
app.register_blueprint(request_blueprint)
app.register_blueprint(business_blueprint)
app.register_blueprint(user_blueprint)

#if __name__ == '__main__':
#   app.run(port=5000, debug=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
