from flask import current_app
from app.models.requests_model import TimeOffRequest
from datetime import time

def create_request(request_data):
    try:
        print("calling db 1")
        db = current_app.config['FIRESTORE_CLIENT']
        request_ref = db.collection('requests')  

        new_request = TimeOffRequest(request_id=None, **request_data)
        request_dict = new_request.to_dict()

        new_request_ref = request_ref.add(request_dict)

        request_id = new_request_ref[1].id
        request_dict['id'] = request_id

        response_data = {
            "status": "Request submitted sucessfully",
            "request id": request_id
        }
        return request_data, 201

    except Exception as e:
        return {"error": f"Error submitting request: {str(e)}"}, 500