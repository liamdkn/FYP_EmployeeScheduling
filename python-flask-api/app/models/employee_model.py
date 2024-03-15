from datetime import time

class Employee:
    def __init__(self, document_id, firstname, lastname, number, email, days_per_week, availability):
        self.id = document_id
        self.firstname = firstname
        self.lastname = lastname
        self.number = number
        self.email = email
        self.days_per_week = days_per_week
        self.availability = availability

    def to_dict(self):
        return {
            "id": self.id,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "number": self.number,
            "email": self.email,
            "days_per_week": self.days_per_week,
            "availability": self.availability
            
        }

    def __str__(self):
        return f"Employee(id={self.id}, firstname={self.firstname}, lastname={self.lastname})"

