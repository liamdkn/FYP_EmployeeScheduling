import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/services/roster_service.dart';
import 'package:my_app/views/rosters/components/shift_display_component';

class RosterDisplayWidget extends StatelessWidget {
  final Roster roster;

  RosterDisplayWidget(this.roster);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var day in daysOfWeek) _buildDayShiftColumn(roster, day),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayShiftColumn(Roster roster, String day) {
    List<IndividualShift> shiftsForDay =
        roster.assignedShifts.where((shift) => shift.day == day).toList();
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            color: Colors.grey[300],
            child: Text(
              day,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8.0),
          for (var indShift in shiftsForDay)
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: ShiftDisplayComponent(indShift),
            ),
        ],
      ),
    );
  }
}
