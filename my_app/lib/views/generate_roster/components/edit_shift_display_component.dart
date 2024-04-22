import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/services/employee_service.dart';

class EditShiftDisplayComponent extends StatefulWidget {
  final IndividualShift shift;
  final List<Employee> employees;
  final void Function(IndividualShift)? onShiftChanged;

  const EditShiftDisplayComponent(
    this.shift,
    this.employees, {
    Key? key,
    this.onShiftChanged,
  }) : super(key: key);

  @override
  _EditShiftDisplayComponentState createState() =>
      _EditShiftDisplayComponentState();
}

class _EditShiftDisplayComponentState extends State<EditShiftDisplayComponent> {
  final EmployeeService employeeService = EmployeeService();
  late Employee _selectedEmployee;
  bool isAvailable = true; // true init as came from generation

  @override
  void initState() {
    super.initState();
    _selectedEmployee = widget.shift.employee!;
  }

  void checkEmployeeAvailability(IndividualShift shift) async {
    bool available = await employeeService.checkAvailability(shift);
    print(available);
    setState(() {
      isAvailable = available;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: shiftBgColor,
        border: Border.all(
          color: isAvailable ? Colors.green : Colors.red,
          width: 2.0,
        ), //border reflects if employee is not ava
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.shift.name),
          const SizedBox(height: 4.0),
          Text(widget.shift.id),
          Text(
              "${widget.shift.startTime.substring(0, 5)} - ${widget.shift.endTime.substring(0, 5)}"),
          if (widget.employees.isNotEmpty)
            DropdownButton<Employee>(
              value: _selectedEmployee,
              onChanged: (Employee? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedEmployee = newValue;
                    widget.shift.employee =
                        newValue; // Update the shift's employee
                  });
                  if (widget.onShiftChanged != null) {
                    widget
                        .onShiftChanged!(widget.shift); // Return changed shift
                    checkEmployeeAvailability(
                        widget.shift); // Call availability check
                  }
                }
              },
              style: const TextStyle(color: Colors.black),
              dropdownColor: Colors.white,
              items: widget.employees
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
