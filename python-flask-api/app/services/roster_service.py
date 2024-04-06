from flask import current_app
from app.scripts.roster_generation import *
from app.models.roster_model import Roster
from app.services.shift_service import get_shifts
from app.models.shift_model import Ind_Shift
from app.models.employee_model import Employee
import traceback


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

def get_all_rosters():
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        rosters_ref = db.collection('generated_rosters')
        rosters_docs = rosters_ref.stream()

        rosters = []
        for doc in rosters_docs:
            roster_data = doc.to_dict()
            roster_data['roster_id'] = doc.id
            rosters.append(roster_data)

        return rosters
    except Exception as e:
        raise Exception(f"Error fetching rosters: {e}")



def create_roster(rosterData):
    try:
        print("Calling Firestore to create roster")
        db = current_app.config['FIRESTORE_CLIENT']
        rosters_ref = db.collection('generated_rosters')

        new_roster = Roster(**rosterData)
        roster_dict = new_roster.to_dict()

        new_roster_ref = rosters_ref.add(roster_dict)
        roster_id = new_roster_ref[1].id
        roster_dict['id'] = roster_id

        response_data = { "roster_id": roster_id}
        
        return response_data, 201 
    except Exception as e:
        traceback_str = traceback.format_exc()
        print(traceback_str)
        return {"error": f"Error creating roster: {str(e)}"}, 500



def generate_roster_service(rosterData, shifts_id, employee_ids):
    try:
        print("hereeeeee generating a roster ")
        employees = get_employees_by_id(employee_ids)
        shifts = get_shifts_by_id(shifts_id)

        assigned_shifts, generations, conflicts, fitness = generate_roster(shifts, employees)

        print(assigned_shifts)

        print("Generations:", generations)
        for shift in assigned_shifts:
            print(f"Shift: {shift.name}, Day: {shift.day}, Start Time: {shift.start_time}, End Time: {shift.end_time}, Employee:{shift.employee.firstname}")

        new_roster = Roster(**rosterData)

        new_roster.assigned_shifts = assigned_shifts
        new_roster.fitness = fitness
        new_roster.conflicts = conflicts
        new_roster.generations = generations

        db = current_app.config['FIRESTORE_CLIENT']
        generated_rosters_ref = db.collection('generated_rosters')

        roster_dict = new_roster.to_dict()

        new_roster_ref = generated_rosters_ref.add(roster_dict)
        roster_id = new_roster_ref[1].id
        
        
        return roster_id, 201
    except Exception as e:
        print(f"Error generating roster: {e}")
