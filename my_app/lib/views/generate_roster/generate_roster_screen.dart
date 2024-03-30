import 'package:flutter/material.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/services/shift_service.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/generate_roster/components/shift_input_form.dart';
import 'package:my_app/widgets/shift_week_tabs.dart';
import 'package:my_app/widgets/week_view_widget.dart';
import '../../../constants.dart';

class GenerateRosterScreen extends StatefulWidget {
  const GenerateRosterScreen({Key? key}) : super(key: key);

  @override
  _GenerateRosterState createState() => _GenerateRosterState();
}

class _GenerateRosterState extends State<GenerateRosterScreen> {
  List<Shift> shifts = [];
  ShiftService shiftService = ShiftService();
  List<Employee> selectedEmployees = []; // Store selected employees here

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          const Header(
            title: 'Generate Roster',
          ),
          const SizedBox(height: defaultPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: secondaryColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ShiftInputWidget(
                              onAddShift: _addShift,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                              border: Border.all(color: secondaryColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: WeekViewWidget(
                                shifts: shifts, onDeleteShift: _onDeleteShift),
                          ),
                        ),
                      ],
                    ),
                    if (Responsive.isMobile(context))
                      const SizedBox(height: defaultPadding),
                    if (Responsive.isMobile(context)) const Text("Storage 3"),
                  ],
                ),
              ),
              if (!Responsive.isMobile(context))
                const SizedBox(width: defaultPadding),
              if (!Responsive.isMobile(context))
                const Expanded(
                  flex: 2,
                  child: Text("ghfjdkfhdj"), //EmployeeListWidget(),
                ),
            ],
          )
        ],
      ),
    ));
  }

  void _addShift(Shift newShift) {
    setState(() {
      shifts.add(newShift);
      print(newShift.toJson());
    });
  }

  void _onDeleteShift(Shift newShift) {
    setState(() {
      shifts.remove(newShift);
    });
  }

  void _saveShifts() {
    shiftService.createShiftsList(shifts);
  }
}
