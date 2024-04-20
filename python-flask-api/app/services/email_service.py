import traceback
from flask import Flask
from flask_mail import Mail, Message
import io
import csv

#
app = Flask(__name__)
app.config['MAIL_SERVER'] = 'bulk.smtp.mailtrap.io'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USERNAME'] = 'api'
app.config['MAIL_PASSWORD'] = '6175cc57efe5b7175456ee9442b3bb40'
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False
app.config['MAIL_DEFAULT_SENDER'] = 'mailtrap@demomailtrap.com'
mail = Mail(app)


def email_roster_to_employees(employee_emails, csv_file_path):
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


def email_emergency_request(business_email, request):
    start_date = request.start_date
    end_date = request.end_date
    reason = request.reason

    subject = 'URGENT: Emergency Request'
    body = f"An employee has submitted an Emergency Request.\n"
    body += f"Start Date: {start_date}\n"
    body += f"End Date: {end_date}\n"
    body += f"Reason: {reason}"

    try:
        msg = Message(subject, sender=app.config['MAIL_DEFAULT_SENDER'], recipients=[business_email])
        msg.body = body

        mail.send(msg)
        print("Emergency Request Notice Sent To Employer")
    except Exception as e:
        print("An error occurred while sending the emergency request notice:")
        traceback.print_exc()
        print(f"Error message: {str(e)}")
