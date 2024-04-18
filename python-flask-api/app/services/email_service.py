import traceback
from flask import Flask
from flask_mail import Mail, Message
import io
import csv

def email_roster_to_employees(employee_emails, csv_file_path):
    app = Flask(__name__)

    # Configuration for Flask-Mail
    app.config['MAIL_SERVER'] = 'bulk.smtp.mailtrap.io'
    app.config['MAIL_PORT'] = 587
    app.config['MAIL_USERNAME'] = 'api'
    app.config['MAIL_PASSWORD'] = '6175cc57efe5b7175456ee9442b3bb40'
    app.config['MAIL_USE_TLS'] = True
    app.config['MAIL_USE_SSL'] = False
    app.config['MAIL_DEFAULT_SENDER'] = 'mailtrap@demomailtrap.com'

    mail = Mail(app)

    subject = 'Published Roster'
    body = 'Attached is the published roster CSV file.'

    try:
        for email in employee_emails:
            msg = Message(subject, sender=app.config['MAIL_DEFAULT_SENDER'], recipients=[email])
            msg.body = body

            with open(csv_file_path, 'r') as file:
                csv_data = file.read()

            msg.attach('roster.csv', 'text/csv', csv_data)

            mail.send(msg)
        print("Rosters emailed successfully to all employees!")
    except Exception as e:
        print("An error occurred while sending the rosters:")
        traceback.print_exc()
        print(f"Error message: {str(e)}")

