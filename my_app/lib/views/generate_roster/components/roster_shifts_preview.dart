import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/views/rosters/components/shift_display_component.dart';

class RosterShiftsPreview extends StatelessWidget {
  final List<IndividualShift> shifts;

  RosterShiftsPreview({required this.shifts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
            border: TableBorder.all(color: secondaryColor),
            children: [
              TableRow(
                decoration: const BoxDecoration(color: listHeaderColor),
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
                        children: _buildShiftsForDay(day),
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

  List<Widget> _buildShiftsForDay(String day) {
    List<IndividualShift> shiftsForDay =
        shifts.where((shift) => shift.day == day).toList();
    return shiftsForDay
        .map(
          (shift) => Container(
            padding: const EdgeInsets.all(8.0),
            child: ShiftDisplayComponent(shift),
          ),
        )
        .toList();
  }
}
