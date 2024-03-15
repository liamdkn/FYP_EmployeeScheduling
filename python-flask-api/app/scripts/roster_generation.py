from constants import *
import random
from app.services.shift_service import *
from app.services.employee_service import *
from app.models.shift_model import Ind_Shift


def create_individual_shifts(shifts):
    individual_shifts = []

    for shift_data in shifts.get('all_shifts', []):
        #print(f"Processing Shift Data: {shift_data}")

        name = shift_data.get('name')
        start_time = shift_data.get('startTime')
        end_time = shift_data.get('endTime')
        days_of_week = shift_data.get('daysOfWeek', {})

        #print(f"Shift Name: {name}")
        #print(f"Days of Week: {days_of_week}")

        for day, is_shift_day in days_of_week.items():
            if is_shift_day:
                individual_shift = Ind_Shift(
                    id=None,
                    name=name,
                    day=day,
                    start_time=start_time,
                    end_time=end_time,
                    employee=None
                )
                individual_shifts.append(individual_shift)

    print("DEBUG: Individual Shifts Created")
    num_shifts = len(individual_shifts)
    return individual_shifts, num_shifts


def initialise_population(population_size, employees, num_shifts):
    available_employee_ids = [employee.id for employee in employees]

    def generate_random_chromosome():
        return [random.choice(available_employee_ids) for _ in range(num_shifts)]

    initial_population = [generate_random_chromosome() for _ in range(population_size)]
    return initial_population



def calculate_fitness(chromosome, individual_shifts, employees):
    total_shifts = len(chromosome)
    shifts_per_day = {}
    shifts_per_employee = MAX_SHIFTS_PER_WEEK
    numberOfConflicts = 0


    # Assuming each employee object in the employees list has an 'id' attribute
    shifts_per_employee = {employee.id: 0 for employee in employees}

    for i, employee_id in enumerate(chromosome):
        if i < total_shifts:
            shift = individual_shifts[i]
            day = shift.day
            
            employee = next((emp for emp in employees if emp.id == employee_id), None)
            max_shifts_per_week = employee.days_per_week
            
            # Check if shift is within employees' availability 
            if not is_employee_available(employee, shift):
                numberOfConflicts += 1

            # Check if an employee is assigned to more than one shift per day
            if day in shifts_per_day:
                if employee.id in shifts_per_day[day]:
                    numberOfConflicts += 1
                else:
                    shifts_per_day[day].add(employee_id)
            else:
                shifts_per_day[day] = {employee_id}
        
        # Count the number of shifts assigned to each employee
        shifts_per_employee[employee.id] += 1

    # Check if an employee is working more than max_shifts_per_week days
    shifts_penalty = sum(max(0, count - max_shifts_per_week) for count in shifts_per_employee.values())
    numberOfConflicts += shifts_penalty

    fitness = 1 / ((1.0 * numberOfConflicts + 1))   

    return fitness, numberOfConflicts


def roulette_wheel_selection(population, num_selection):
    total_fitness = sum(individual['fitness'] for individual in population)
    selection_probabilities = [individual['fitness'] / total_fitness for individual in population]
    selected_indices = random.choices(range(len(population)), weights=selection_probabilities, k=num_selection)
    selected_individuals = [population[i] for i in selected_indices]
    return selected_individuals

def crossover(parent1, parent2):
    crossover_point = random.randint(1, len(parent1) - 1)
    child1 = parent1[:crossover_point] + parent2[crossover_point:]
    child2 = parent2[:crossover_point] + parent1[crossover_point:]
    return child1, child2


def create_offspring(selected_for_crossover, individual_shifts, employees):
    offspring = []
    for i in range(0, len(selected_for_crossover), 2):
        parent1 = selected_for_crossover[i]['chromosome']
        parent2 = selected_for_crossover[i + 1]['chromosome']
        
        child1, child2 = crossover(parent1, parent2)

        child1_fitness, child1_conflicts = calculate_fitness(child1, individual_shifts, employees)
        child2_fitness, child2_conflicts = calculate_fitness(child2, individual_shifts, employees)
        
        offspring.append({'chromosome': child1, 'fitness': child1_fitness, 'conflicts': child1_conflicts})
        offspring.append({'chromosome': child2, 'fitness': child2_fitness, 'conflicts': child2_conflicts})
    return offspring


def algorithm(next_generation, individual_shifts, employees, num_selection, population_size):
    repeat = 0

    while next_generation[0]['conflicts'] > 0:
        repeat += 1
        for individual in next_generation:
            individual['fitness'], individual['conflicts'] = calculate_fitness(individual['chromosome'], individual_shifts, employees)
        
        selected_for_crossover = roulette_wheel_selection(next_generation, num_selection)
        
        # Crossover: Apply crossover to create offspring
        offspring = create_offspring(selected_for_crossover, individual_shifts, employees)
        
        next_generation = next_generation + offspring

        next_generation = [individual for individual in next_generation if individual['fitness'] is not None]
        
        # Sort the next generation based on fitness
        next_generation = sorted(next_generation, key=lambda x: x['fitness'], reverse=True)
        
        # Truncate to the population size
        next_generation = next_generation[:population_size]

    winner = next_generation[0]
    return winner, repeat


def print_roster(chromosome, individual_shifts, employees):
# Calculate fitness and conflicts for the chromosome
    fitness, conflicts = calculate_fitness(chromosome, individual_shifts, employees)

    # Map employee IDs to first names
    employee_names = [next((employee.firstname for employee in employees if employee.id == employee_id), None) for employee_id in chromosome]
    employee_names = [name for name in employee_names if name is not None]

     # Get the shift days
    shift_days = [shift.day for shift in individual_shifts]

    # Print the roster with employee names and shift days
    print(f"Employee Names: {employee_names}, Shift Days: {shift_days}, Fitness: {fitness}, Conflicts: {conflicts}")



def generate_roster(shifts, employees):
    days = DAYS_OF_WEEK
    num_selection = NUM_SELECTED
    population_size = POPULATION_SIZE
    initial_population_with_fitness = []

    individual_shifts, num_shifts = create_individual_shifts(shifts) #Split shifts into individual shift objects 
    initial_population = initialise_population(INITIAL_POPUL_COUNT, employees, num_shifts) #Create random population for these shifts X times, where X = INITIAL_POPUL_COUNT
    
    for chromosome in initial_population:
        fitness, conflicts = calculate_fitness(chromosome, individual_shifts, employees)

        # Map employee IDs to first names
        employee_names = [next((employee.firstname for employee in employees if employee.id == employee_id), None) for employee_id in chromosome]
        employee_names = [name for name in employee_names if name is not None]
        print(f"Employee Names: {employee_names}, Fitness: {fitness}, Conflicts: {conflicts}")

        individual_dict = {'chromosome': chromosome, 'fitness': fitness, 'conflicts': conflicts}
        initial_population_with_fitness.append(individual_dict)

    roster, repeat = algorithm(initial_population_with_fitness, individual_shifts, employees, num_selection, population_size)
    print("Times repeated", repeat)
    print_roster(roster['chromosome'], individual_shifts, employees)  # Pass the chromosome from the roster
    return roster