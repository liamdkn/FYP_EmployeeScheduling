import json

class Employee:
    def __init__(self, id, firstname, lastname, number, email, days_per_week, availability, business_id, is_admin=False, is_deleted=False):
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.number = number
        self.email = email
        self.days_per_week = days_per_week
        self.availability = availability
        self.business_id = business_id
        self.is_admin = is_admin
        self.is_deleted = is_deleted

    def to_dict(self):
        return {
            "id": self.id,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "number": self.number,
            "email": self.email,
            "days_per_week": self.days_per_week,
            "availability": self.availability,
            "business_id": self.business_id,
            "is_admin": self.is_admin,
            "is_deleted": self.is_deleted
        }

    def to_json(self):
        return json.dumps(self.to_dict())

    def from_json(self, json_data):
        data = json.loads(json_data)
        availability = data.get('availability', {})
        availability = {day: {'start_time': times['start_time'], 'end_time': times['end_time']} for day, times in availability.items()}
        self.id = data['id']
        self.firstname = data['firstname']
        self.lastname = data['lastname']
        self.number = data['number']
        self.email = data['email']
        self.days_per_week = data['days_per_week']
        self.availability = availability
        self.business_id = data['business_id'] 
        self.is_admin = data.get('is_admin')
        self.is_deleted = data.get('is_deleted')
        return self

    def __str__(self):
        return f"Employee(id={self.id}, firstname={self.firstname}, lastname={self.lastname})"
