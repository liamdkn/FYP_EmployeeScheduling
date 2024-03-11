from flask import current_app
from app.scripts.roster_generation import *
from app.models.roster_model import Roster
from app.services.employee_service import get_emp_availability_by_id

def get_roster_by_id():
    pass

def create_new_roster(shifts_id, employee_ids):
    employee_availability = get_emp_availability_by_id(employee_ids)
    roster = RosterGeneration(shifts_id, employee_availability)

    return roster