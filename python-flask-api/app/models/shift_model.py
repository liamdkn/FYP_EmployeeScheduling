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
    def __init__(self, name, day, start_time, end_time, employee=None):
        self.name = name
        self.day = day
        self.start_time = start_time
        self.end_time = end_time
        self.employee = employee
