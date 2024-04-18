from flask import current_app
from app.scripts.roster_generation import *
from app.services.requests_service import get_approved_requests
from app.models.roster_model import Roster
from app.services.shift_service import get_shifts
from app.models.shift_model import Ind_Shift
from app.models.employee_model import Employee
from app.services.email_service import *
import traceback
import csv
from collections import defaultdict
import json

#getting rosters not generated roster 
def get_roster(roster_id):
    print("Calling Firestore to get roster")
    db = current_app.config['FIRESTORE_CLIENT']
    rosters_ref = db.collection('rosters')
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


#get all rosters 
def get_all_rosters(user_type):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        rosters_ref = db.collection('rosters')
        rosters_docs = rosters_ref.where('is_deleted', '==', False).stream()

        rosters = []
        for doc in rosters_docs:
            roster_data = doc.to_dict()
            if user_type == 'employee':
                if roster_data.get('is_published'):
                    roster_data['roster_id'] = doc.id
                    rosters.append(roster_data)
            else:
                roster_data['roster_id'] = doc.id
                rosters.append(roster_data)

        return rosters
    except Exception as e:
        raise Exception(f"Error fetching rosters: {e}")




def create_roster(rosterData):
    try:
        print("Calling Firestore to create roster")
        db = current_app.config['FIRESTORE_CLIENT']
        rosters_ref = db.collection('rosters')

        new_roster = Roster(**rosterData)
        roster_dict = new_roster.to_dict()

        new_roster_ref = rosters_ref.add(roster_dict)
        roster_id = new_roster_ref[1].id
        print(roster_id)
        return roster_id, 201 
    except Exception as e:
        traceback_str = traceback.format_exc()
        print(traceback_str)
        return {"error": f"Error creating roster: {str(e)}"}, 500


def soft_delete_roster(roster_id):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        roster_ref = db.collection('rosters')
        roster_ref = roster_ref.document(roster_id)
        roster_ref.update({'is_deleted': True})

        return {"status": "Roster marked as deleted successfully"}, 200
    except Exception as e:
        print(f"Error marking roster as deleted: {e}")
        return {"error": "Failed to mark roster as deleted"}, 500



def generate_roster_service(rosterData, shifts_id, employee_ids):
    db = current_app.config['FIRESTORE_CLIENT']
    generated_rosters_ref = db.collection('generated_rosters')

    try:
        employees = get_employees_by_id(employee_ids) 
        shifts = get_shifts_by_id(shifts_id)
        approvedRequests = get_approved_requests()
        print(approvedRequests)

        assigned_shifts, generations, conflicts, fitness = generate_roster(shifts, employees, approvedRequests) 

        print("Generations:", generations)
        for shift in assigned_shifts:
            print(f"Shift: {shift.name}, Day: {shift.day}, Start Time: {shift.start_time}, End Time: {shift.end_time}, Employee:{shift.employee.firstname}")

        new_roster = Roster(**rosterData)

        new_roster.assigned_shifts = assigned_shifts
        new_roster.fitness = fitness
        new_roster.conflicts = conflicts
        new_roster.generations = generations
 
        roster_dict = new_roster.to_dict()

        new_roster_ref = generated_rosters_ref.add(roster_dict)
        roster_id = new_roster_ref[1].id

        export_roster_weekly_view(roster_id)
        return roster_dict, 201
    except Exception as e:
        print(f"Error generating roster: {e}")
        traceback.print_exc()



def export_roster_weekly_view(roster_data):
    try:
        weekly_shifts = defaultdict(list)
        
        shifts = roster_data["assigned_shifts"]
        for shift in shifts:
            day = shift['day']
            entry = f"{shift['employee']['firstname']} {shift['employee']['lastname']}, {shift['start_time']}-{shift['end_time']}"
            weekly_shifts[day].append(entry)

        with open('weekly_roster_export.csv', 'w', newline='') as csvfile:
            fieldnames = ['Day', 'Shift']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

            writer.writeheader()

            for day, shifts in weekly_shifts.items():
                for shift in shifts:
                    row = {'Day': day, 'Shift': shift}
                    writer.writerow(row)

        print("Data has been written to weekly_roster_export.csv")
        return True
            
    except Exception as e:
        print("An error occurred during roster export:")
        traceback.print_exc()



def publish_roster(roster_id):
    print("publishing roster")
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        rosters_ref = db.collection('rosters')
        roster_doc = rosters_ref.document(roster_id).get()  # Retrieve document snapshot

        if roster_doc.exists:
            roster_data = roster_doc.to_dict()
            roster_data['is_published'] = True
            rosters_ref.document(roster_id).set(roster_data)

            employee_emails = ['liamdurkan24@icloud.com']
            attachment_data = '/Users/liamdurkan/Repositories/FYP_EmployeeScheduling/python-flask-api/weekly_roster_export.csv'

            email_roster_to_employees(employee_emails, attachment_data)

            return {"message": "Roster published successfully"}, 200
        else:
            return {"error": "Roster not found"}, 404

    except Exception as e:
        traceback_str = traceback.format_exc()
        print(traceback_str)
        return {"error": f"Error publishing roster: {str(e)}"}, 500
