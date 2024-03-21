from flask import current_app
from app.models.shift_model import Shift, Ind_Shift

def get_shifts():
    db = current_app.config['FIRESTORE_CLIENT']
    shifts_ref = db.collection('shifts')
    shifts = [doc.to_dict() for doc in shifts_ref.stream()]
    return shifts


def get_shifts_by_id(shifts_id):
    print(shifts_id)
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        shift_doc_ref = db.collection('shifts').document(shifts_id)
        shifts_doc = shift_doc_ref.get()

        if shifts_doc.exists:
            shifts_data = shifts_doc.to_dict()
            return shifts_data
        else:
            return None
            print(f"Shifts document not found")
    except Exception as e:
        print(f"Error retrieving shift: {e}")
        return None



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

        new_shift_ref = shifts_ref.add({'all_shifts': all_shifts})

        response_data = {
            "status": "Shifts data created successfully",
            "shifts_data": all_shifts
        }

        return response_data, 201

    except Exception as e:
        error_message = f"Error creating shifts: {str(e)}"
        return {"error": error_message}, 500


