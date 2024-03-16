class Roster:
    def __init__(self, roster_id, assigned_shifts, fitness, conflicts, generations):
        self.roster_id = roster_id
        self.assigned_shifts = assigned_shifts
        self.fitness = fitness
        self.conflicts = conflicts
        self.generations = generations

    def __str__(self):
        return f"Roster ID: {self.roster_id}, Assigned Shifts: {len(self.assigned_shifts)}, Fitness: {self.fitness}, Conflicts: {self.conflicts}, Generations: {self.generations}"


