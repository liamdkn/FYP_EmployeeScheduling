import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/shift_model.dart';

void main() {
  test('shift JSON preserves employee assignment and scheduling fields', () {
    final employee = Employee(
      id: 'employee-1',
      firstName: 'Test',
      lastName: 'Employee',
      daysPerWeek: 3,
      availability: {
        'Monday': {'start_time': '09:00', 'end_time': '17:00'},
      },
      isAdmin: false,
      isDeleted: false,
      email: 'employee@example.com',
      number: '0000000000',
      businessId: 'business-1',
    );
    final shift = IndividualShift(
      name: 'Lunch',
      day: 'Monday',
      startTime: '12:00',
      endTime: '16:00',
      employee: employee,
      date: '16-11-2026',
    );

    final restored = IndividualShift.fromJson(shift.toJson());

    expect(restored.name, shift.name);
    expect(restored.day, shift.day);
    expect(restored.startTime, shift.startTime);
    expect(restored.endTime, shift.endTime);
    expect(restored.date, shift.date);
    expect(restored.employee, employee);
  });
}
