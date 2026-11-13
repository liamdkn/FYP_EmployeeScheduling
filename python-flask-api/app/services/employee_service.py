import traceback
from flask import current_app
from app.models.employee_model import Employee
from datetime import time
from datetime import datetime
import traceback

def create_employee(employee_data):
    try:
        print('DEBUG: Create employee service')
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')  

        employee_id = employee_data.get('id', None)
        new_employee = Employee(**employee_data)
        employee_dict = new_employee.to_dict()
        employees_ref.document(employee_id).set(employee_dict)

        response_data = {
            "status": "Employee created successfully",
            "employee_id": employee_id
        }
        return response_data, 201 

    except Exception as e:
        return {"error": f"Error creating employee: {str(e)}"}, 500


def get_employee(employee_id):
    try:
        print("calling db 2")
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')
        employee_doc = employees_ref.document(employee_id).get()

        if employee_doc.exists and not employee_doc.to_dict().get('is_deleted', False):
            employee_data = employee_doc.to_dict()
            doc_id = employee_doc.id
            employee = Employee(**employee_data)
            employee.id = doc_id 
            print(employee.id)
            return employee
        else:
            raise Exception("Employee not found")
    except Exception as e:
        print(f"Error retrieving employee: {e}")
        traceback.print_exc()
        

def get_employees():
    print("calling db 3")
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')
        employees = []

        for employee_doc in employees_ref.stream():
            employee_data = employee_doc.to_dict()
            if not employee_data.get('is_deleted', False):
                employee = Employee(**employee_data)
                employees.append(employee)

        return employees

    except Exception as e:
        print(f"Error retrieving employees: {str(e)}")
        return []
import traceback

def get_employees_by_id(employee_ids):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')
        
        employees = []
        for employee_id in employee_ids:
            employee_doc = employees_ref.document(employee_id).get()

            if employee_doc.exists and not employee_doc.to_dict().get('is_deleted', False): 
                employee_data = employee_doc.to_dict()
                print(employee_data)
                employee = Employee(**employee_data)
                employees.append(employee)

        return employees
    except Exception as e:
        print(f"Error retrieving employees: {e}")
        traceback.print_exc()



def soft_delete_employee(employee_id):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')
        employee_ref = employees_ref.document(employee_id)
        employee_ref.update({'is_deleted': True})

        return {"status": "Employee marked as deleted successfully"}, 200
    except Exception as e:
        print(f"Error marking employee as deleted: {e}")
        return {"error": "Failed to mark employee as deleted"}, 500




def is_employee_available(employee, shift, approved_requests):
    try:
        availability = employee.availability
        shift_start_time = datetime.strptime(shift.start_time, "%H:%M").time()
        shift_end_time = datetime.strptime(shift.end_time, "%H:%M").time()
        shift_date = datetime.strptime(shift.date, "%d-%m-%Y").date()
        shift_day = shift.day

        # Check if shift overlaps with approved requests
        for request in approved_requests:
            if request.employee_id == employee.id:  # Only consider requests for the current employee
                request_start_date = datetime.strptime(request.start_date, "%d-%m-%Y").date()
                request_end_date = datetime.strptime(request.end_date, "%d-%m-%Y").date()
                request_start_time = datetime.strptime(request.start_time, "%H:%M").time()
                request_end_time = datetime.strptime(request.end_time, "%H:%M").time()

                request_start_datetime = datetime.combine(request_start_date, request_start_time)
                request_end_datetime = datetime.combine(request_end_date, request_end_time)
                shift_start_datetime = datetime.combine(shift_date, shift_start_time)
                shift_end_datetime = datetime.combine(shift_date, shift_end_time)

                if shift_overlap(shift_start_datetime, shift_end_datetime, request_start_datetime, request_end_datetime):
                    return False 

        if shift_day in availability:
            employee_availability = availability[shift_day]
            employee_start_time = datetime.strptime(employee_availability['start_time'], "%H:%M").time()
            employee_end_time = datetime.strptime(employee_availability['end_time'], "%H:%M").time()


            if (
                employee_start_time <= shift_start_time <= employee_end_time
                and employee_start_time <= shift_end_time <= employee_end_time
            ):
                print("true")
                return True 
        print("false")
        return False 
    except Exception as e:
        traceback.print_exc()
        return False

def shift_overlap(shift_start, shift_end, request_start, request_end):
    return shift_start <= request_end and shift_end >= request_start



def edit_employee(employee_id, employee_data):
    try:
        print("editing employee")
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')  

        employee_doc = employees_ref.document(employee_id).get()
        if not employee_doc.exists:
            return {"error": "Employee not found"}, 404

        employee_data.pop('id', None)
        employees_ref.document(employee_id).update(employee_data)

        response_data = {
            "status": "Employee updated successfully",
            "employee_id": employee_id
        }
        return response_data, 200 

    except Exception as e:
        print(f"Error editing employee: {e}")
        return {"error": "Failed to edit employee"}, 500


def is_user_employee(user_id):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')
        employee_doc = employees_ref.document(user_id).get()
        if employee_doc.exists and not employee_doc.to_dict().get('is_deleted', False):
            return True
        else: False
    except Exception as e:
        print(f"Error checking employee: {e}")
        traceback.print_exc()
        return False

