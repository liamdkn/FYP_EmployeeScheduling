import traceback
from flask import current_app
from flask_mail import Message


def _send(message):
    current_app.extensions['mail'].send(message)


def email_roster_to_employees(employee_emails, export_data):
    try:
        subject = 'New Roster'
        body = 'Your employer has published a new roster'

        msg = Message(subject, recipients=[employee_emails])
        msg.body = body
        msg.attach('roster.csv', 'text/csv', export_data)

        _send(msg)

        print("Roster published and sent to employees")
        return True

    except Exception as e:
        print("An error occurred while emailing employees")
        traceback.print_exc()
        return False
 



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
        msg = Message(subject, recipients=[business_email])
        msg.body = body

        _send(msg)
        print("Emergency Request Notice Sent To Employer")
    except Exception as e:
        print("An error occurred while sending the emergency request notice:")
        traceback.print_exc()
        print(f"Error message: {str(e)}")


def email_exported_roster(export_data, business_email):
    try:
        subject = 'Exported Roster'
        body = 'Attached is the exported roster CSV file.'

        msg = Message(subject, recipients=[business_email])
        msg.body = body
        msg.attach('roster.csv', 'text/csv', export_data)

        _send(msg)

        print("Exported roster emailed to the business email.")
        return True

    except Exception as e:
        print("An error occurred during roster export and email sending:")
        traceback.print_exc()
        return False
 
