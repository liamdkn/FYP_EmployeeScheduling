import random
from app.services.shift_service import get_shifts_by_id, get_individual_shifts
from app.services.employee_service import is_employee_available, get_employees_by_id, get_employee_by_id
from app.models.shift_model import Ind_Shift

def sort_shifts_by_day(individual_shifts, days):
    sorted_shifts = sorted(individual_shifts, key=lambda x: (days.index(x.day), x.id))
    for new_id, shift in enumerate(sorted_shifts, start=1):
        shift.id = new_id  
    print("DEBUG: Shifts sorted and re-id'd")  
    return sorted_shifts


def initalise_population(population_size, available_employee_ids, num_shifts):
    # Generate a random chromosome (assignment of shifts to employees)
    def generate_random_chromosome():
        return [random.choice(available_employee_ids) for _ in range(num_shifts)]

    # Generate an initial population
    initial_population = [generate_random_chromosome() for _ in range(population_size)]
    return initial_population


def calculate_fitness(chromosome, employee_availability, individual_shifts, employee_ids):
    total_shifts = len(chromosome)
    shifts_per_day = {}
    numberOfConflicts = 0
    max_shifts_per_week = 5
    shifts_per_employee = 5

    # Count the number of shifts assigned to each employee

    for i, employee_id in enumerate(chromosome):
        if i < len(individual_shifts):
            shift = individual_shifts[i]
            day = shift.day
            employee = get_employee_by_id(employee_id)
            # Check if shift is within employees' availability 
            if not is_employee_available(employee, shift, employee_availability):
                numberOfConflicts += 1

            # Check if an employee is assigned to more than one shift per day
            if day in shifts_per_day:
                if employee_id in shifts_per_day[day]:
                    #print(f"Conflict: Employee {employee.id} is assigned to more than one shift on {day}.")
                    numberOfConflicts += 1
                else:
                    shifts_per_day[day].add(employee_id)
            else:
                shifts_per_day[day] = {employee_id}

            # Count the number of shifts assigned to each employee
            #shifts_per_employee[employee.id] += 1

    # Check if an employee is working more than max_shifts_per_week days
    #shifts_penalty = sum(max(0, count - max_shifts_per_week) for count in shifts_per_employee.values())
    #numberOfConflicts += shifts_penalty
    #print(f"Conflict: < 5 days ",shifts_penalty)
    
    fitness = 1 / ((1.0 * numberOfConflicts + 1))
    
    return fitness, numberOfConflicts


def roulette_wheel_selection(population, num_selection):
    total_fitness = sum(individual['fitness'] for individual in population)
    selection_probabilities = [individual['fitness'] / total_fitness for individual in population]
    selected_indices = random.choices(range(len(population)), weights=selection_probabilities, k=num_selection)
    selected_individuals = [population[i] for i in selected_indices]
    return selected_individuals



def generate_roster(shifts_id, employee_availability):
    days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    
    weekly_shifts = get_shifts_by_id(shifts_id)
    individual_shifts = get_individual_shifts(weekly_shifts)
    sorted_shifts = sort_shifts_by_day(individual_shifts, days)
    num_shifts = len(individual_shifts)

    employee_ids = list(employee_availability.keys())
    initial_population = initalise_population(10, employee_ids, num_shifts) #########!!!!!!MAGIC NUMBER 

    employees = get_employees_by_id(employee_ids)
    
    for chromosome in initial_population:
        fitness, conflicts = calculate_fitness(chromosome, employee_availability, individual_shifts, employee_ids)
        # Convert employee IDs in the chromosome to employee names
        employee_names = [get_employee_by_id(employee_id).firstname if employee_id != 0 else "Unassigned" for employee_id in chromosome]
        
        print(f"Chromosome: {employee_names}, Fitness: {fitness}, Conflicts: {conflicts}")


    initial_population_with_fitness = []

    for chromosome in initial_population:
        fitness, conflicts = calculate_fitness(chromosome, employee_availability, individual_shifts, employee_ids)
        individual_dict = {'chromosome': chromosome, 'fitness': fitness, 'conflicts': conflicts}
        initial_population_with_fitness.append(individual_dict)

# Now initial_population_with_fitness is a list of dictionaries, each containing 'chromosome', 'fitness', and 'conflicts'.

    num_selection = 2  # Adjust as needed
    selected_for_crossover = roulette_wheel_selection(initial_population_with_fitness, num_selection)

    for selected_individual in selected_for_crossover:
        print(f"Selected: Chromosome: {selected_individual['chromosome']}, Fitness: {selected_individual['fitness']}, Conflicts: {selected_individual['conflicts']}")


