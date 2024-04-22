import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/services/employee_service.dart';
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
  EmployeeService employeeService = EmployeeService();

  List<IndividualShift> shifts = [];
  List<String> employeeIds = [];

  final TextEditingController _rosterNameController = TextEditingController();
  late String selectedWeekNumber = 'Week 1';

  late DateTime startDate = DateTime.now();

  bool _isGenerating = false; //generation in progress gate

  void onStartDateSelected(DateTime date) {
    setState(() {
      startDate = date;
    });
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
                              child: RosterDetailsForm(
                                _rosterNameController,
                                onStartDateSelected: onStartDateSelected,
                              ),
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
                                //flex: 2,
                                child: EmployeeListWidget(
                                  onEmployeesSelected: _handleEmployeesSelected,
                                ),
                              ),
                            ],
                          ),
                        if (!Responsive.isMobile(context))
                          const SizedBox(height: defaultPadding),
                        if (!Responsive.isMobile(context))
                          Stack(
                            children: [
                              CustomElevatedButton(
                                onPressed: () => _createRoster(
                                    _rosterNameController.text, startDate),
                                text: 'Generate Roster',
                              ),
                              if (_isGenerating)
                                const Positioned.fill(
                                  child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
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
              if (Responsive.isMobile(context))
                Stack(
                  children: [
                    CustomElevatedButton(
                      onPressed: () =>
                          _createRoster(_rosterNameController.text, startDate),
                      text: 'Generate Roster',
                    ),
                    if (_isGenerating)
                      const Positioned.fill(
                        child: LinearProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                  ],
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
    setState(() {
      _isGenerating = true;
    });

    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    List<Employee> employees = await employeeService.getEmployees();
    try {
      String shiftsId = await shiftService.createShifts(shifts);
      Roster roster = Roster(
        rosterId: null,
        rosterName: rosterName,
        assignedShifts: shifts,
        conflicts: null,
        fitness: -1,
        generations: null,
        startDate: formattedStartDate,
        isCurrentRoster: false,
        isPublished: false,
        dateCreated: DateTime.now(),
        isDeleted: false,
      );
      final generatedRoster =
          await rosterService.createRoster(roster, shiftsId, employeeIds);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GeneratedRosterScreen(generatedRoster, employees),
        ),
      );
    } catch (error) {
      //roster fail error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Oh Dear :(',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'An error occurred while generating the roster, Please make sure Shifts & Employees are correct and there is enough employees to cover the shifts',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }
}
