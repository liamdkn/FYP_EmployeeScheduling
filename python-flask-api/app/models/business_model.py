class Business:
    def __init__(self, business_id, name, opening_time, closing_time, number, email, is_deleted=False):
        self.business_id = business_id
        self.name = name
        self.opening_time = opening_time
        self.closing_time = closing_time
        self.number = number
        self.email = email
        self.is_deleted = is_deleted

    def to_dict(self):
        return {
            "business_id": self.business_id,
            "name": self.name,
            "opening_time": self.opening_time,
            "closing_time": self.closing_time,
            "number": self.number,
            "email": self.email,
            "is_deleted": self.is_deleted
        }

    @staticmethod
    def from_dict(data):
        return Business(
            business_id=data.get('business_id'),
            name=data.get('name'),
            opening_time=data.get('opening_time'),
            closing_time=data.get('closing_time'),
            number=data.get('number'),
            email=data.get('email'),
            is_deleted=data.get('is_deleted', False)
        )
