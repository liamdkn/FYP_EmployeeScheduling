import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/views/generate_roster/components/edit_shift_display_component.dart';

class RosterDisplayWidget extends StatelessWidget {
  final Roster roster;
  final List<Employee> employees; // List of employees

  final void Function(IndividualShift)? onShiftChanged; // Callback function

  RosterDisplayWidget(this.roster, this.employees, {this.onShiftChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.all(Responsive.isMobile(context) ? 0.0 : defaultPadding),
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: secondaryColor),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Table(
            border: TableBorder.all(color: rosterOutline),
            children: [
              TableRow(
                decoration: const BoxDecoration(color: rosterHeader),
                children: [
                  for (var day in daysOfWeek)
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        child: Text(
                          day,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              TableRow(
                children: [
                  for (var day in daysOfWeek)
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ..._buildShiftsForDay(roster, day),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildShiftsForDay(Roster roster, String day) {
    List<IndividualShift> shiftsForDay =
        roster.assignedShifts.where((shift) => shift.day == day).toList();
    return shiftsForDay
        .map(
          (indShift) => Container(
            padding: const EdgeInsets.all(8.0),
            child: EditShiftDisplayComponent(
              indShift,
              employees,
              onShiftChanged: onShiftChanged,
            ),
          ),
        )
        .toList();
  }
}
