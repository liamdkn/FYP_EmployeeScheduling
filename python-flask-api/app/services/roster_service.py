from flask import current_app
from app.scripts.roster_generation import *
from app.models.roster_model import Roster
from app.services.shift_service import get_shifts
from app.models.shift_model import Ind_Shift
from app.models.employee_model import Employee

def get_roster(roster_id):
    print("Calling Firestore to get roster")
    db = current_app.config['FIRESTORE_CLIENT']
    rosters_ref = db.collection('generated_rosters')
    roster_doc = rosters_ref.document(roster_id).get()

    if roster_doc.exists:
        employees = get_employees()
        employee_map = {employee.id: employee for employee in employees}

        roster_data = roster_doc.to_dict()
        roster_data['roster_id'] = roster_id 

        for shift in roster_data.get('assigned_shifts', []):
            employee_id = shift.get('employee_id')
            if employee_id:
                if employee_id in employee_map:
                    employee_dict = employee_map[employee_id].to_dict()
                    del employee_dict['number']
                    del employee_dict['email']
                    shift['employee'] = employee_dict
                else:
                    raise Exception(f"Employee with ID {employee_id} not found")

                del shift['employee_id']#remove id before storing in db
           

        return roster_data
    else:
        raise Exception("Roster not found")



def create_roster(shifts_id, employee_ids):
    try:
        employees = get_employees_by_id(employee_ids)
        shifts = get_shifts_by_id(shifts_id)

        assigned_shifts, generations, conflicts, fitness = generate_roster(shifts, employees)

        if not shifts or not employees:
            raise Exception("No shifts or employees available for roster creation")

        roster = Roster(roster_id=None, assigned_shifts=assigned_shifts, fitness=fitness, conflicts=conflicts, generations=generations)

        print("Generations:", generations)
        for shift in assigned_shifts:
            print(f"Shift: {shift.name}, Day: {shift.day}, Start Time: {shift.start_time}, End Time: {shift.end_time}, Employee:{shift.employee.firstname}")
        
        db = current_app.config['FIRESTORE_CLIENT']
        generated_rosters_ref = db.collection('generated_rosters')
        
        roster_data = {
            'assigned_shifts': [shift.to_dict() for shift in roster.assigned_shifts],
            'fitness': roster.fitness,
            'conflicts': roster.conflicts,
            'generations': roster.generations
        }

        new_roster_ref = generated_rosters_ref.add(roster_data)
        roster_id = new_roster_ref[1].id
        return roster_id
    except Exception as e:
        print(f"Error creating roster: {e}")
    





