from flask import current_app
from app.models.requests_model import TimeOffRequest
from datetime import time

def create_request(request_data):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        request_ref = db.collection('requests')  

        # Drop the request_id field from the request_data
        request_data.pop('request_id', None)

        new_request = TimeOffRequest(request_id=None, **request_data)
        request_dict = new_request.to_dict()

        new_request_ref = request_ref.add(request_dict)

        request_id = new_request_ref[1].id
        request_dict['id'] = request_id

        response_data = {
            "status": "Request submitted successfully",
            "request_id": request_id
        }
        return response_data

    except Exception as e:
        return {"error": f"Error submitting request: {str(e)}"}



def get_all_requests():
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        request_ref = db.collection('requests')

        requests = []

        for doc in request_ref.stream():
            request_data = doc.to_dict()
            request_data['request_id'] = doc.id
            request_object = TimeOffRequest(**request_data)
            requests.append(request_object)

        # Return the list of TimeOffRequest objects
        return requests

    except Exception as e:
        return {"error": f"Error retrieving requests: {str(e)}"}

