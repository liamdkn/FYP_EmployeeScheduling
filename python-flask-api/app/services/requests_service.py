from flask import current_app
from app.models.requests_model import TimeOffRequest
from app.services.employee_service import is_user_employee
from app.services.business_service import is_user_business
from app.services.employee_service import get_employees
from app.services.email_service import email_emergency_request
from datetime import time
from constants import *
import traceback

def create_request(request_data, user_id):
    print("creating request")
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        request_ref = db.collection('requests')  

        # Drop the request_id field from the request_data
        request_data.pop('request_id', None)
        request_data.pop('employee_id', None)

        new_request = TimeOffRequest(request_id= None,employee_id=user_id, **request_data)
        request_dict = new_request.to_dict()
        
        new_request_ref = request_ref.add(request_dict)

        request_doc_id = new_request_ref[1].id
        new_request.request_id = request_doc_id

        is_emergency = request_data.get('is_emergency', False)  # Check if is_emergency is True
        if is_emergency:
            emergencyRequest(new_request)

        response_data = {
            "status": "Request submitted successfully",
            "request_id": request_doc_id
        }
        return response_data

    except Exception as e:
        traceback.print_exc()  # Print the stack trace
        return {"error": f"Error submitting request: {str(e)}"}, 


def emergencyRequest(request):
    print("Emergency request recieved with ID:", request.request_id)

    email_emergency_request(BUSINESS_EMAIL, request)


def get_all_requests(user_id):
    if is_user_employee(user_id):
        user_type = 'employee'
        employee_id = user_id
    elif is_user_business(user_id):
        user_type = 'business'
    else:
        return jsonify({'error': 'User not found or has no type'}), 404

    try:
        db = current_app.config['FIRESTORE_CLIENT']
        request_ref = db.collection('requests')
        requests = []

        for doc in request_ref.stream():
            request_data = doc.to_dict()
            if not request_data.get('is_deleted', False):
                request_object = TimeOffRequest(**request_data)
                request_object.request_id = doc.id
                if user_type == 'business' or (user_type == 'employee' and request_object.employee_id == employee_id):
                    requests.append(request_object)

        return requests

    except Exception as e:
        traceback.print_exc()
        return {"error": f"Error retrieving requests: {str(e)}"}



def get_approved_requests():
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        request_ref = db.collection('requests')
        approved_requests = []

        for doc in request_ref.where('status', '==', 'Approved').stream():
            request_data = doc.to_dict()
            if not request_data.get('is_deleted', False):
                request_object = TimeOffRequest(**request_data)
                approved_requests.append(request_object)

        return approved_requests

    except Exception as e:
        stack_trace = traceback.format_exc()
        return {"error": f"Error retrieving approved requests: {str(e)}", "stack_trace": stack_trace}




def approve_request(request_id):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        request_ref = db.collection('requests').document(request_id)

        request_ref.update({'status': 'Approved'})

        return {"status": "Request approved successfully"}

    except Exception as e:
        return {"error": f"Error approving request: {str(e)}"}


def deny_request(request_id):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        request_ref = db.collection('requests').document(request_id)

        request_ref.update({'status': 'Denied'})

        return {"status": "Request denied successfully"}

    except Exception as e:
        return {"error": f"Error denying request: {str(e)}"}



