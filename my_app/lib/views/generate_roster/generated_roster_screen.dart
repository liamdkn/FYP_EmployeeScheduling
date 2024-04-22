import 'package:flutter/material.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/services/roster_service.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/generate_roster/components/generate_roster_display_widget.dart';

class GeneratedRosterScreen extends StatelessWidget {
  final RosterService _rosterService = RosterService();
  final Roster roster;
  final List<Employee> employees;

  late String rosterId;

  GeneratedRosterScreen(this.roster, this.employees, {super.key});

  void onShiftChanged(IndividualShift shift) {
    int index = roster.assignedShifts.indexWhere((s) => s.id == shift.id);
    if (index != -1) {
      roster.assignedShifts[index] = shift;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Roster'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: RosterDisplayWidget(
                roster,
                employees,
                onShiftChanged: onShiftChanged,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  text: "Save Roster",
                  onPressed: () async {
                    rosterId = await _rosterService.saveRoster(roster);
                  },
                  textColor: Colors.white,
                ),
                const SizedBox(width: 20),
                CustomElevatedButton(
                  text: "Export Roster",
                  onPressed: () {
                    _rosterService.exportRoster(roster);
                  },
                  textColor: Colors.white,
                ),
                const SizedBox(width: 20),
                CustomElevatedButton(
                  text: "Publish Roster",
                  onPressed: () {
                    _rosterService.publishRoster(rosterId);
                  },
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
