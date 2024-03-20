class TimeOffRequest:
    def __init__(self, employee_id, start_date, end_date, request_type, reason, status, is_emergency, submission_date, request_id=None, is_deleted=False):
        self.request_id = request_id
        self.employee_id = employee_id
        self.start_date = start_date
        self.end_date = end_date
        self.request_type = request_type
        self.reason = reason
        self.status = status
        self.is_emergency = is_emergency
        self.submission_date = submission_date
        self.is_deleted = is_deleted

    def to_dict(self):
        return {
            "employee_id": self.employee_id,
            "start_date": self.start_date,
            "end_date": self.end_date,
            "request_type": self.request_type,
            "reason": self.reason,
            "status": self.status,
            "is_emergency": self.is_emergency,
            "submission_date": self.submission_date,
            "is_deleted": self.is_deleted
        }
