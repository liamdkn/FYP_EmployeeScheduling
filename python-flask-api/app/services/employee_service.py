from flask import current_app
from app.models.employee_model import Employee
from datetime import time

def create_employee(employee_data):
    try:
        print("calling db 1")
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')  

        new_employee = Employee(document_id=None, **employee_data)
        employee_dict = new_employee.to_dict()
        employee_dict.pop('id', None)

        new_employee_ref = employees_ref.add(employee_dict) 

        employee_id = new_employee_ref[1].id
        employee_dict['id'] = employee_id

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
            employee = Employee(document_id=None, **employee_data)
            employee.id = doc_id 
            return employee
        else:
            raise Exception("Employee not found")
    except Exception as e:
        print(f"Error retrieving employee: {e}")
        



def get_employees():
    print("calling db 3")
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')
        employees = []

        for employee_doc in employees_ref.stream():
            employee_data = employee_doc.to_dict()
            employee_id = employee_doc.id
            employee = Employee(employee_id,**employee_data)
            employees.append(employee)

        return employees

    except Exception as e:
        print(f"Error retrieving employees: {str(e)}")
        return []


# Returns a list of employees, provided with a lsit of employees 
def get_employees_by_id(employee_ids):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')
        
        employees = []
        for employee_id in employee_ids:
            employee_doc = employees_ref.document(employee_id).get()

            if employee_doc.exists and not employee_doc.to_dict().get('is_deleted', False): 
                employee_data = employee_doc.to_dict()
                employee = Employee(employee_id, **employee_data)
                employees.append(employee)
            else:
                raise Exception("Employee not found")
        return employees
    except Exception as e:
        print(f"Error retrieving employees: {e}")



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



def is_employee_available(employee, shift):
    availability = employee.availability

    shift_start_time = shift.start_time
    shift_end_time = shift.end_time
    day = shift.day

    if day in availability:
        employee_availability = availability[day]
        employee_start_time = employee_availability['start_time']
        employee_end_time = employee_availability['end_time']

        if (
            employee_start_time <= shift_start_time <= employee_end_time
            and employee_start_time <= shift_end_time <= employee_end_time
        ):
            return True
    else:
        return False


