class Shift:
    def __init__(self, name, startTime, endTime, daysOfWeek):
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.daysOfWeek = daysOfWeek

    def to_dict(self):
        return {
            "name": self.name,
            "startTime": self.startTime,
            "endTime": self.endTime,
            "daysOfWeek": self.daysOfWeek,
        }

class Ind_Shift:
    def __init__(self, name, day, date, start_time, end_time, id=None, employee=None):
        self.id = id
        self.name = name
        self.day = day
        self.date = date 
        self.start_time = start_time
        self.end_time = end_time
        self.employee = employee

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'day': self.day,
            'date': self.date,
            'start_time': self.start_time,
            'end_time': self.end_time,
            'employee': self.employee.to_dict() if self.employee else None,
        }

    def __str__(self):
        employee_firstname = self.employee.firstname if self.employee else "None"
        availability = "Available" if self.employee and self.employee.is_available(self.start_time, self.end_time, self.day) else "Not Available"
        return f"Ind_Shift(name={self.name}, day={self.day}, date={self.date}, start_time={self.start_time}, end_time={self.end_time}, employee={employee_firstname}, availability={availability})"

