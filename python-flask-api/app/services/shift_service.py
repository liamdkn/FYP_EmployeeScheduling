from flask import current_app
from app.models.shift_model import Shift, Ind_Shift

def get_all_shifts():
    db = current_app.config['FIRESTORE_CLIENT']
    shifts_ref = db.collection('shifts')
    shifts = [doc.to_dict() for doc in shifts_ref.stream()]
    return shifts

def get_shifts_by_id(shifts_id):
    db = current_app.config['FIRESTORE_CLIENT']
    shift_ref = db.collection('shifts').document(shifts_id)
    print("Debug: Gettign shifts by id from shift_service")
    shifts = shift_ref.get().to_dict()
    return shifts

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

def get_individual_shifts(shifts):
    individual_shifts = []

    for shift_data in shifts.get('all_shifts', []):
        #print(f"Processing Shift Data: {shift_data}")

        name = shift_data.get('name')
        start_time = shift_data.get('startTime')
        end_time = shift_data.get('endTime')
        days_of_week = shift_data.get('daysOfWeek', {})

        #print(f"Shift Name: {name}")
        #print(f"Days of Week: {days_of_week}")

        for day, is_shift_day in days_of_week.items():
            if is_shift_day:
                individual_shift = Ind_Shift(
                    id=None,
                    name=name,
                    day=day,
                    start_time=start_time,
                    end_time=end_time,
                    employee=None
                )
                individual_shifts.append(individual_shift)

    print("DEBUG: Individual Shifts created")
    #print(individual_shifts)
    return individual_shifts
