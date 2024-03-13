from flask import current_app
from app.models.employee_model import Employee, EmployeeAvailability


def get_all_employees():
    db = current_app.config['FIRESTORE_CLIENT']
    employees_ref = db.collection('employees')
    employees = [employee.to_dict() for employee in employees_ref.stream()]
    return employees

def get_employee_by_id(employee_id):
    db = current_app.config['FIRESTORE_CLIENT']
    employees_ref = db.collection('employees')
    employee_doc = employees_ref.document(employee_id).get()

    if employee_doc.exists:
        employee_data = employee_doc.to_dict()
        doc_id = employee_doc.id
        employee = Employee(**employee_data)
        employee.id = doc_id  # Set the id attribute separately
        return employee
    else:
        raise Exception("Employee not found")




def get_employees_by_id(employee_ids):
    db = current_app.config['FIRESTORE_CLIENT']
    employees_ref = db.collection('employees')
    
    employees = []
    for employee_id in employee_ids:
        employee_doc = employees_ref.document(employee_id).get()
        if employee_doc.exists:
            employee_data = employee_doc.to_dict()
            employee_id = employee_doc.id
            employee = Employee(**employee_data)
            employees.append(employee)
    return employees


def create_new_employee(employee_data):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        employees_ref = db.collection('employees')  

        dayTimeMap = employee_data.get('dayTimeMap', {})
        days_per_week = employee_data.get('days_per_week', {})
        del employee_data['dayTimeMap']
        del employee_data['days_per_week']

        new_employee = Employee(**employee_data)
        new_employee_ref = employees_ref.add(new_employee.to_dict())

        # Use the generated ID from the add operation
        employee_id = new_employee_ref[1].id

        # Set the ID in the Employee object
        new_employee.set_id(employee_id)

        availability_ref = db.collection('employee_availability')
        availability = EmployeeAvailability(employee_id=employee_id, dayTimeMap=dayTimeMap, days_per_week=days_per_week)
        availability_ref.add(availability.to_dict())

        response_data = {
            "status": "Employee created successfully",
            "employee_data": {**employee_data, "id": employee_id},
            "availability_data": availability.to_dict(),
        }

        return response_data, 201

    except Exception as e:
        print(f"Error creating employee: {str(e)}")
        return {"error": f"Error creating employee: {str(e)}"}, 500




def get_emp_availability_by_id(employee_ids):
    db = current_app.config['FIRESTORE_CLIENT']
    availability_ref = db.collection('employee_availability')

    availability_objects = {}
    
    for employee_id in employee_ids:
        employee_availability = availability_ref.where('employee_id', '==', employee_id).stream()

        availability_list = [
            EmployeeAvailability(
                employee_id=doc.get('employee_id'),
                dayTimeMap=doc.get('dayTimeMap'),
                days_per_week=doc.get('days_per_week')
            )
            for doc in employee_availability
        ]
        availability_objects[employee_id] = availability_list

    return availability_objects


def is_employee_available(employee, shift, employee_availability):
    employee_id = employee.id  # Assuming you have the 'id' attribute in your Employee class

    if employee_id in employee_availability:
        availability_object = employee_availability[employee_id][0]

        shift_start_time = shift.start_time
        shift_end_time = shift.end_time

        day = shift.day
        if day in availability_object.dayTimeMap:
            employee_start_time = availability_object.dayTimeMap[day]['startTime']
            employee_end_time = availability_object.dayTimeMap[day]['endTime']

            if (
                employee_start_time <= shift_start_time <= employee_end_time
                and employee_start_time <= shift_end_time <= employee_end_time
            ):
                return True
    
    return False

