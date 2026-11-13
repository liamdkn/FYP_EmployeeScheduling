import unittest

from app.models.employee_model import Employee
from app.models.shift_model import Ind_Shift
from app.scripts.roster_generation import calculate_fitness


def employee(employee_id, days_per_week):
    availability = {
        day: {'start_time': '09:00', 'end_time': '17:00'}
        for day in ('Monday', 'Tuesday', 'Wednesday')
    }
    return Employee(
        id=employee_id,
        firstname='Test',
        lastname=employee_id,
        number='0000000000',
        email=f'{employee_id}@example.com',
        days_per_week=days_per_week,
        availability=availability,
        business_id='business-1',
    )


def shift(day, date):
    return Ind_Shift(
        id=None,
        name='Day shift',
        day=day,
        date=date,
        start_time='10:00',
        end_time='12:00',
    )


class RosterFitnessTests(unittest.TestCase):
    def test_each_employee_uses_their_own_weekly_shift_limit(self):
        employees = [employee('limited', 1), employee('flexible', 5)]
        shifts = [
            shift('Monday', '16-11-2026'),
            shift('Tuesday', '17-11-2026'),
            shift('Wednesday', '18-11-2026'),
        ]

        fitness, conflicts = calculate_fitness(
            ['limited', 'limited', 'flexible'], shifts, employees, []
        )

        self.assertEqual(conflicts, 1)
        self.assertAlmostEqual(fitness, 1 / 7)


if __name__ == '__main__':
    unittest.main()
