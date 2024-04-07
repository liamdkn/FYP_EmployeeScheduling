import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/services/roster_service.dart';
import 'package:my_app/services/shift_service.dart';
import 'package:my_app/views/generate_roster/components/employee_select_widget.dart';
import 'package:my_app/views/generate_roster/components/roster_details_form.dart';
import 'package:my_app/views/generate_roster/components/roster_shifts_preview.dart';
import 'package:my_app/views/generate_roster/generated_roster_screen.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/generate_roster/components/shift_input_form.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import '../../../constants.dart';

class GenerateRosterScreen extends StatefulWidget {
  const GenerateRosterScreen({Key? key}) : super(key: key);

  @override
  _GenerateRosterState createState() => _GenerateRosterState();
}

class _GenerateRosterState extends State<GenerateRosterScreen> {
  ShiftService shiftService = ShiftService();
  RosterService rosterService = RosterService();

  List<IndividualShift> shifts = [];
  List<String> employeeIds = [];

  final TextEditingController _rosterNameController = TextEditingController();
  late String selectedWeekNumber = 'Week 1';
  late DateTime startDate;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Header(
                title: 'Generate Roster',
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: RosterShiftsPreview(shifts: shifts),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        const SizedBox(height: defaultPadding),
                        Row(
                          children: [
                            Expanded(
                              child: RosterDetailsForm(_rosterNameController),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ShiftInputWidget(
                                onAddIndividualShift: onAddIndividualShift,
                                startDate: startDate,
                              ),
                            ),
                          ],
                        ),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: EmployeeListWidget(
                                  onEmployeesSelected: _handleEmployeesSelected,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    const SizedBox(width: defaultPadding),
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 2,
                      child: EmployeeListWidget(
                        onEmployeesSelected: _handleEmployeesSelected,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              CustomElevatedButton(
                onPressed: () =>
                    _createRoster(_rosterNameController.text, startDate),
                text: 'Generate Roster',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onAddIndividualShift(IndividualShift shift) {
    setState(() {
      shifts.add(shift);
    });
  }

  void _handleEmployeesSelected(List<String> selectedEmployees) {
    setState(() {
      employeeIds = selectedEmployees;
    });
  }

  void _createRoster(String rosterName, DateTime startDate) async {
    try {
      String shiftsId = await shiftService.createShifts(shifts);
      Roster roster = Roster(
        rosterId: null,
        rosterName: rosterName,
        assignedShifts: shifts,
        conflicts: null,
        fitness: -1,
        generations: null,
        startDate: startDate,
        isCurrentRoster: false,
        isPublished: false,
        dateCreated: DateTime.now(),
        weekNumber: null,
        isDeleted: false,
      );
      final response =
          await rosterService.createRoster(roster, shiftsId, employeeIds);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GeneratedRosterScreen(response),
        ),
      );
    } catch (error) {
      print('Error generating roster: $error');
    }
  }

  DateTime _getNextMonday(DateTime date) {
    int daysUntilNextMonday = DateTime.monday - date.weekday;
    if (daysUntilNextMonday <= 0) {
      daysUntilNextMonday += 7;
    }
    return date.add(Duration(days: daysUntilNextMonday));
  }
}
