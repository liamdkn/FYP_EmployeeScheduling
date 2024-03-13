# /Users/liamdurkan/Repositories/FYP_EmployeeScheduling/python-flask-api/app/models/employee_model.py
class Employee:
    def __init__(self, firstname, lastname, number, email):
        self.id = None  # Private attribute for storing the ID
        self.firstname = firstname
        self.lastname = lastname
        self.number = number
        self.email = email

    def to_dict(self):
        return {
            "id": self.id,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "number": self.number,
            "email": self.email,
        }


class EmployeeAvailability:
    def __init__(self, employee_id, dayTimeMap, days_per_week):
        self.employee_id = employee_id
        self.dayTimeMap = dayTimeMap
        self.days_per_week = days_per_week


    def to_dict(self):
        return {
            "employee_id": self.employee_id,
            "dayTimeMap": self.dayTimeMap,
            "days_per_week" : self.days_per_week
        }


    def __str__(self):
        return f"EmployeeAvailability(employee_id={self.employee_id}, dayTimeMap={self.dayTimeMap})"
