from flask import current_app
from app.scripts.roster_generation import *
from app.models.roster_model import Roster
from app.services.shift_service import get_shifts
from app.models.shift_model import Ind_Shift
from app.models.employee_model import Employee

def get_roster():
    pass

def create_roster(shifts_id, employee_ids):
    employees = get_employees_by_id(employee_ids)
    shifts = get_shifts_by_id(shifts_id)
    assigned_shifts, generations, conflicts, fitness = generate_roster(shifts, employees)
    
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
    roster_id = roster.roster_id
    response_data = {
            "status": "Roster created successfully",
            "roster_id": roster_id
        }
    return response_data, 201





