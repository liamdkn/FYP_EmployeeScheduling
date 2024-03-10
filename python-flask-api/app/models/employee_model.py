# /Users/liamdurkan/Repositories/FYP_EmployeeScheduling/python-flask-api/app/models/employee_model.py
class Employee:
    def __init__(self, firstname, lastname, number, email, dayTimeMap=None):
        self.firstname = firstname
        self.lastname = lastname
        self.number = number
        self.email = email
        self.dayTimeMap = dayTimeMap or {}  # Set a default value if dayTimeMap is None

    def to_dict(self):
        return {
            "firstname": self.firstname,
            "lastname": self.lastname,
            "number": self.number,
            "email": self.email,
            "dayTimeMap": self.dayTimeMap,
        }

class EmployeeAvailability:
    def __init__(self, employee_id, dayTimeMap):
        self.employee_id = employee_id
        self.dayTimeMap = dayTimeMap

    def to_dict(self):
        return {
            "employee_id": self.employee_id,
            "dayTimeMap": self.dayTimeMap,
        }

