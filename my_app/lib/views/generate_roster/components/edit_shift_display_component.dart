import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/responsive.dart';

class EditShiftDisplayComponent extends StatelessWidget {
  final IndividualShift shift;
  final List<Employee> employees;
  final void Function(Employee)? onEmployeeChanged;

  const EditShiftDisplayComponent(
    this.shift,
    this.employees, {
    Key? key,
    this.onEmployeeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: shiftBgColor,
        border: Border.all(color: shiftBorderColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(shift.name),
          const SizedBox(height: 4.0),
          Text(
              "${shift.startTime.substring(0, 5)} - ${shift.endTime.substring(0, 5)}"),
          if (employees.isNotEmpty)
            DropdownButton<Employee>(
              value: shift.employee, // Set the value to the selected employee
              onChanged: (Employee? newValue) {
                if (onEmployeeChanged != null) {
                  onEmployeeChanged!(newValue!);
                }
              },
              style: const TextStyle(color: Colors.black),
              dropdownColor: Colors.white,
              items: employees
                  .map<DropdownMenuItem<Employee>>((Employee employee) {
                return DropdownMenuItem<Employee>(
                  value: employee,
                  child: Text(
                    '${employee.firstName} ${employee.lastName}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
