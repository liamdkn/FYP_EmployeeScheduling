import 'package:flutter/material.dart';
import 'package:my_app/models/shift.dart';
import 'package:my_app/services/shift_service.dart';
import 'package:my_app/widgets/shift_week_tabs.dart';
import 'package:my_app/widgets/shift_input_form.dart';
import 'package:my_app/widgets/styled_scaffold.dart';

class CreateRoster extends StatefulWidget {
  const CreateRoster({Key? key}) : super(key: key);

  @override
  _CreateRosterState createState() => _CreateRosterState();
}

class _CreateRosterState extends State<CreateRoster> {
  List<Shift> shifts = [];
  ShiftService shiftService = ShiftService();

  @override
  Widget build(BuildContext context) {
    return StyledScaffold(
      title: 'Create Roster',
      child: Column(
        children: [
          Center(
            child: ShiftInputWidget(
              onAddShift: _addShift,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: WeekViewWidget(
                    shifts: shifts, onDeleteShift: _onDeleteShift),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _saveShifts,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addShift(Shift newShift) {
    setState(() {
      shifts.add(newShift);
      print(newShift);
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

void main() {
  runApp(MaterialApp(
    home: CreateRoster(),
  ));
}
