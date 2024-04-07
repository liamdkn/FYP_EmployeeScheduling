from flask import current_app
from app.models.shift_model import Shift, Ind_Shift

def get_shifts():
    db = current_app.config['FIRESTORE_CLIENT']
    shifts_ref = db.collection('shifts')
    shifts = [doc.to_dict() for doc in shifts_ref.stream()]
    return shifts


import traceback

def get_shifts_by_id(shifts_id):
    print("Getting shifts for ID:", shifts_id)
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        shifts_ref = db.collection('shifts')
        
        shifts = []
        shifts_doc = shifts_ref.document(shifts_id).get()
        
        if shifts_doc.exists:
            print("Shifts document found")
            shifts_data = shifts_doc.to_dict().get('shifts_data', [])
            for shift_data in shifts_data:
                shift = Ind_Shift(**shift_data)
                shifts.append(shift)
            print("Shifts retrieved:", shifts)
            return shifts
        else:
            print("Shifts document not found")
            return None
    except Exception as e:
        print(f"Error retrieving shifts: {e}")
        traceback.print_exc()
        return None






def create_shifts(shifts_data):
    try:
        print(shifts_data)
        db = current_app.config['FIRESTORE_CLIENT']
        shifts_ref = db.collection('shifts')

        new_shifts_ref = shifts_ref.add({
            'shifts_data': shifts_data
        })

        shifts_id = new_shifts_ref[1].id

        return shifts_id
    except Exception as e:
        error_message = f"Error creating shifts data document: {str(e)}"
        raise Exception(error_message)








'''
def create_shifts(shifts_data):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        shifts_ref = db.collection('shifts')
        
        all_shifts = []

        for shift_data in shifts_data:
            new_shift = Shift(
                name=shift_data['name'],
                startTime=shift_data['startTime'],
                endTime=shift_data['endTime'],
                daysOfWeek=shift_data['daysOfWeek']
            )
            shift_dict = new_shift.to_dict()
            all_shifts.append(shift_dict)

        new_shifts_ref = shifts_ref.add({'all_shifts': all_shifts})
        shifts_id = new_shifts_ref[1].id 

        response_data = {
            "status": "Shifts data created successfully",
            "shifts_id": shifts_id
        }

        return response_data, 201

    except Exception as e:
        error_message = f"Error creating shifts: {str(e)}"
        return {"error": error_message}, 500


'''