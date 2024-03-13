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
    def __init__(self, id, name, day, start_time, end_time, employee):
        self.id = id
        self.name = name
        self.day = day
        self.start_time = start_time
        self.end_time = end_time
        self.employee = employee

    def __str__(self):
        employee_firstname = self.employee.firstname if self.employee else "None"
        return f"Ind_Shift(id={self.id}, name={self.name}, day={self.day}, start_time={self.start_time}, end_time={self.end_time}, employee={employee_firstname})"




