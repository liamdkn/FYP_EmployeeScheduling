class Roster:
    def __init__(self, employees):
        self.shifts = []
        self.employees = employees
        self.numOfConflicts = 0
        self.fitness = -1
        self.classNum = 0
        self.isFitnessChanged = True

