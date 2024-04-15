from app.models.shift_model import Ind_Shift
class Roster:
    def __init__(self, roster_id, assigned_shifts, fitness, conflicts, generations,
                roster_name, start_date=None, end_date=None, is_current_roster=False,
                is_published=False, date_created=None, week_number=None, is_deleted=False):
        self.roster_id = roster_id
        self.roster_name = roster_name
        self.assigned_shifts = [Ind_Shift(**shift_data) for shift_data in assigned_shifts]
        self.fitness = fitness
        self.conflicts = conflicts
        self.generations = generations
        self.start_date = start_date
        self.end_date = end_date
        self.is_current_roster = is_current_roster
        self.is_published = is_published
        self.date_created = date_created
        self.week_number = week_number
        self.is_deleted = is_deleted


    def to_dict(self):
        roster_dict = {
            'roster_id': self.roster_id,
            'roster_name': self.roster_name,
            'assigned_shifts': [shift.to_dict() for shift in self.assigned_shifts],
            'fitness': self.fitness,
            'conflicts': self.conflicts,
            'generations': self.generations,
            'start_date': self.start_date,
            'end_date': self.end_date,
            'is_current_roster': self.is_current_roster,
            'is_published': self.is_published,
            'date_created': self.date_created,
            'week_number': self.week_number,
            'is_deleted': self.is_deleted
        }
        return roster_dict

    def __str__(self):
        return f"Roster ID: {self.roster_id}, Roster Name: {self.roster_name}, Assigned Shifts: {len(self.assigned_shifts)}, Fitness: {self.fitness}, Conflicts: {self.conflicts}, Generations: {self.generations}, Start Date: {self.start_date}, End Date: {self.end_date}, Is Current Roster: {self.is_current_roster}, Is Published: {self.is_published}, Date Created: {self.date_created}, Week Number: {self.week_number}, Is Deleted: {self.is_deleted}"
