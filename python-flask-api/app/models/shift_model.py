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
