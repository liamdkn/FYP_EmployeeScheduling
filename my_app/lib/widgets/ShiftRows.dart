/*
* Author: Liam Durkan 
* Date:
* Licence: 
* Brief: This class consists of a form for a shift. The shift object is passed from the generateRoster class. 
*/

import 'package:flutter/material.dart';
import 'package:my_app/views/GenerateRosterScreen.dart';
import 'package:my_app/widgets/weekView.dart';
import 'package:flutter/src/widgets/framework.dart';

class ShiftRowWidget extends StatelessWidget {
  final Shift shift;
  final int count;
  final ValueChanged<bool> onChanged;

  const ShiftRowWidget(
      {Key? key,
      required this.shift,
      required this.count,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShiftRow(
      shift: shift,
      count: count,
      onChanged: onChanged,
    );
  }
}

class ShiftRowsWidget extends StatefulWidget {
  final List<Shift> shifts;
  final VoidCallback addNewShift;

  const ShiftRowsWidget(
      {Key? key, required this.shifts, required this.addNewShift})
      : super(key: key);

  @override
  _ShiftRowsWidgetState createState() => _ShiftRowsWidgetState();
}

class _ShiftRowsWidgetState extends State<ShiftRowsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Start Time'),
            SizedBox(width: 30),
            Text('End Time'),
            SizedBox(width: 50), // Empty space for alignment
            Text('Mon'),
            SizedBox(width: 20),
            Text('Tue'),
            SizedBox(width: 20),
            Text('Wed'),
            SizedBox(width: 20),
            Text('Thu'),
            SizedBox(width: 20),
            Text('Fri'),
            SizedBox(width: 20),
            Text('Sat'),
            SizedBox(width: 20),
            Text('Sun'),
          ],
        ),
        for (var i = 0; i < widget.shifts.length; i++)
          ShiftRowWidget(
            key: UniqueKey(),
            shift: widget.shifts[i],
            count: i + 1,
            onChanged: (value) {
              setState(() {
                widget.shifts[i].monday = value;
                widget.shifts[i].tuesday = value;
                widget.shifts[i].wednesday = value;
                widget.shifts[i].thursday = value;
                widget.shifts[i].friday = value;
                widget.shifts[i].saturday = value;
                widget.shifts[i].sunday = value;
              });
            },
          ),
      ],
    );
  }
}

class ShiftRows extends StatefulWidget {
  final List<Shift> shifts;

  const ShiftRows({Key? key, required this.shifts}) : super(key: key);

  @override
  _ShiftRowsState createState() => _ShiftRowsState();
}

class _ShiftRowsState extends State<ShiftRows> {
  @override
  void initState() {
    super.initState();

    widget.shifts.add(Shift()); // begin with one shift
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ShiftRowsWidget(shifts: widget.shifts, addNewShift: addNewShift),
            ElevatedButton(
              onPressed: () {
                addNewShift();
              },
              child: const Text('+ Shift'),
            ),
            ElevatedButton(
              onPressed: () {
                // Access the form data and do something with it
                List<Map<String, dynamic>> formData = getFormData();
                print(formData); // Print the form data to the console
                // Move to the week view screen passing form data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeekViewScreen(formData: formData),
                  ),
                );
              },
              child: const Text('Next Step ->'),
            ),
          ],
        ),
      ),
    );
  }

  void addNewShift() {
    setState(() {
      widget.shifts.add(Shift());
    });
  }

  List<Map<String, dynamic>> getFormData() {
    return widget.shifts.map((shift) => shift.toMap()).toList();
  }
}

class ShiftRow extends StatelessWidget {
  final Shift shift;
  final int count;
  final ValueChanged<bool> onChanged;

  const ShiftRow(
      {Key? key,
      required this.shift,
      required this.count,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Shift $count'),
            onChanged: (value) {
              shift.shiftName = value;
            },
          ),
        ),
        const SizedBox(width: 16.0),
        DropdownButton<String>(
          value: shift.selectedStartTime,
          onChanged: (value) {
            setState(() {
              shift.selectedStartTime = value!;
            });
          },
          items: <String>[
            '08:00 AM',
            '09:00 AM',
            '10:00 AM',
            '11:00 AM',
            '12:00 PM',
            '01:00 PM',
            '02:00 PM',
            '03:00 PM',
            '04:00 PM',
            '05:00 PM',
            '06:00 PM',
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(width: 16.0),
        DropdownButton<String>(
          value: shift.selectedEndTime,
          onChanged: (value) {
            shift.selectedEndTime = value!;
          },
          items: <String>[
            '08:00 AM',
            '09:00 AM',
            '10:00 AM',
            '11:00 AM',
            '12:00 PM',
            '01:00 PM',
            '02:00 PM',
            '03:00 PM',
            '04:00 PM',
            '05:00 PM',
            '06:00 PM',
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(width: 16.0),
        // Day of the Week Radio Buttons
        Row(
          children: [
            buildDayCheckbox(shift.monday, onChanged),
            SizedBox(width: 10),
            buildDayCheckbox(shift.tuesday, onChanged),
            SizedBox(width: 10),
            buildDayCheckbox(shift.wednesday, onChanged),
            SizedBox(width: 10),
            buildDayCheckbox(shift.thursday, onChanged),
            SizedBox(width: 10),
            buildDayCheckbox(shift.friday, onChanged),
            SizedBox(width: 10),
            buildDayCheckbox(shift.saturday, onChanged),
            SizedBox(width: 10),
            buildDayCheckbox(shift.sunday, onChanged),
          ],
        ),
      ],
    );
  }

  // Checkboxes
  Widget buildDayCheckbox(bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (newValue) {
            onChanged(newValue!);
          },
        ),
      ],
    );
  }

  void setState(Null Function() param0) {}
}

void main() {
  runApp(
    MaterialApp(
      home: ShiftRows(
        shifts: [],
      ),
    ),
  );
}
