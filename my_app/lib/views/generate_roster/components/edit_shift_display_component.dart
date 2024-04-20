import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/shift_model.dart';

class EditShiftDisplayComponent extends StatefulWidget {
  final IndividualShift shift;
  final List<Employee> employees;
  final Function(Employee) onEmployeeSelected;

  EditShiftDisplayComponent({
    required this.shift,
    required this.employees,
    required this.onEmployeeSelected,
  });

  @override
  _ShiftDisplayComponentState createState() => _ShiftDisplayComponentState();
}

class _ShiftDisplayComponentState extends State<EditShiftDisplayComponent> {
  late Employee? selectedEmployee;
  late IndividualShift shift;

  @override
  void initState() {
    super.initState();
    shift = widget.shift;
  }

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
          DropdownButton<Employee>(
            value: selectedEmployee,
            onChanged: (Employee? newValue) {
              setState(() {
                selectedEmployee = newValue!;
                widget.onEmployeeSelected(newValue);
              });
            },
            items: widget.employees
                .map<DropdownMenuItem<Employee>>((Employee employee) {
              return DropdownMenuItem<Employee>(
                value: employee,
                child: Text("${employee.firstName} ${employee.lastName}"),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
