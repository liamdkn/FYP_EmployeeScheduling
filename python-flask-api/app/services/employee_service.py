from flask import current_app
from app.models.employee_model import Employee, EmployeeAvailability


def get_all_employees():
    db = current_app.config['FIRESTORE_CLIENT']
    employees_ref = db.collection('employees')
    employees = [employee.to_dict() for employee in employees_ref.stream()]
    return employees

def create_new_employee(employee_data):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')  

        dayTimeMap = employee_data.get('dayTimeMap', {})
        del employee_data['dayTimeMap']

        new_employee = Employee(**employee_data)
        new_employee_ref = employees_ref.add(new_employee.to_dict())

        availability_ref = db.collection('employee_availability')
        availability = EmployeeAvailability(employee_id=new_employee_ref[1].id, dayTimeMap=dayTimeMap)
        availability_ref.add(availability.to_dict())

        response_data = {
            "status": "Employee created successfully",
            "employee_data": {**employee_data, "id": new_employee_ref[1].id},
            "availability_data": availability.to_dict(),
        }

        return response_data, 201

    except Exception as e:
        print(f"Error creating employee: {str(e)}")
        return {"error": f"Error creating employee: {str(e)}"}, 500


def get_emp_availability_by_id(employee_ids):
    db = current_app.config['FIRESTORE_CLIENT']
    availability_ref = db.collection('employee_availability')

    availability_data = {}

    for employee_id in employee_ids:
        employee_availability = availability_ref.where('employee_id', '==', employee_id).stream()

        availability_list = [doc.to_dict() for doc in employee_availability]

        availability_data[employee_id] = availability_list
        print(availability_list)

    return availability_data