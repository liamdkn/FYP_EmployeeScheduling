class TimeOffRequest:
    def __init__(self, employee_id, start_date, end_date, start_time, end_time, request_type, reason, status, is_emergency, submission_date, request_id=None, is_deleted=False, is_all_day=False):
        self.request_id = request_id
        self.employee_id = employee_id
        self.start_date = start_date
        self.end_date = end_date
        self.start_time = start_time
        self.end_time = end_time
        self.request_type = request_type
        self.reason = reason
        self.status = status
        self.is_emergency = is_emergency
        self.submission_date = submission_date
        self.is_deleted = is_deleted
        self.is_all_day = is_all_day

    def to_dict(self):
        return {
            "request_id": self.request_id,
            "employee_id": self.employee_id,
            "start_date": self.start_date,
            "end_date": self.end_date,
            "start_time": self.start_time,
            "end_time": self.end_time,
            "request_type": self.request_type,
            "reason": self.reason,
            "status": self.status,
            "is_emergency": self.is_emergency,
            "submission_date": self.submission_date,
            "is_deleted": self.is_deleted,
            "is_all_day": self.is_all_day
        }

    def to_json(self):
        return json.dumps(self.to_dict())
