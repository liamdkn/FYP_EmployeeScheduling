/*import 'package:flutter/material.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/services/roster_service.dart';

class RosterWidget extends StatelessWidget {
  final RosterService rosterService = RosterService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red), // Add a red border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row with day names
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDayColumn('Monday'),
              _buildDayColumn('Tuesday'),
              _buildDayColumn('Wednesday'),
              _buildDayColumn('Thursday'),
              _buildDayColumn('Friday'),
              _buildDayColumn('Saturday'),
              _buildDayColumn('Sunday'),
            ],
          ),
          SizedBox(height: 16.0),
          // Shifts for each day
          Expanded(
            child: FutureBuilder(
              future: rosterService.fetchRoster('ICJOgx8SROrmQmCl1XfC'),
              builder: (BuildContext context, AsyncSnapshot<Roster> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  Roster roster = snapshot.data!;
                  return Row(
                    children: [
                      _buildShiftColumn(roster, 'monday'),
                      _buildShiftColumn(roster, 'tuesday'),
                      _buildShiftColumn(roster, 'wednesday'),
                      _buildShiftColumn(roster, 'thursday'),
                      _buildShiftColumn(roster, 'friday'),
                      _buildShiftColumn(roster, 'saturday'),
                      _buildShiftColumn(roster, 'sunday'),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayColumn(String dayName) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        color: Colors.grey[300],
        child: Text(
          dayName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildShiftColumn(Roster roster, String day) {
    List<IndividualShift> shiftsForDay =
        roster.assignedShifts.where((shift) => shift.day == day).toList();
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: shiftsForDay
              .map((shift) => RosterShiftBox(shift: shift))
              .toList(),
        ),
      ),
    );
  }
}

class RosterShiftBox extends StatelessWidget {
  final IndividualShift shift;

  RosterShiftBox({required this.shift});

  @override
  Widget build(BuildContext context) {
    return DragTarget<Employee>(
      builder: (BuildContext context, List<Employee?> candidateData,
          List<dynamic> rejectedData) {
        return Draggable<Employee>(
          data: shift.employee, // Pass the employee data to be dragged
          child: Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${shift.name}'),
                Text(
                    'Time: ${shift.startTime} - ${shift.endTime}'),
                if (shift.employee != null)
                  Text(
                      'Assigned to: ${shift.employee!.firstname} ${shift.employee!.lastname}'),
              ],
            ),
          ),
          feedback: Container(
            // Create feedback widget when dragging
            width: 100,
            height: 50,
            color: Colors.blue,
            child: Center(
              child: Text(
                  '${shift.employee?.firstname ?? ''} ${shift.employee?.lastname ?? ''}'),
            ),
          ),
          childWhenDragging: Container(
            // Widget shown at the original position while dragging
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${shift.name}'),
                Text(
                    'Time: ${shift.startTime} - ${shift.endTime}'),
              ],
            ),
          ),
        );
      },
      onAcceptWithDetails: (DragTargetDetails<Employee?> details) {
        // Handle the dropped employee here
      },
    );
  }
}
*/