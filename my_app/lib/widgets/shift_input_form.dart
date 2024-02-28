import 'package:flutter/material.dart';

import '../models/shift.dart';

class ShiftInputWidget extends StatefulWidget {
  final Function(Shift) onAddShift;
  const ShiftInputWidget({Key? key, required this.onAddShift})
      : super(key: key);

  @override
  _ShiftInputWidgetState createState() => _ShiftInputWidgetState();
}

class _ShiftInputWidgetState extends State<ShiftInputWidget> {
  List<Shift> shifts = [];

  late TextEditingController _nameController;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  late Map<String, bool> _selectedDaysOfWeek;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedStartTime = TimeOfDay(hour: 9, minute: 0);
    _selectedEndTime = TimeOfDay(hour: 17, minute: 0);
    _selectedDaysOfWeek = {
      'Mon': false,
      'Tue': false,
      'Wed': false,
      'Thu': false,
      'Fri': false,
      'Sat': false,
      'Sun': false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Shift Name',
              ),
            ),
          ),
          SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: () => _selectStartTime(context),
            child: Text('Start Time: ${_selectedStartTime.format(context)}'),
          ),
          SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: () => _selectEndTime(context),
            child: Text('End Time: ${_selectedEndTime.format(context)}'),
          ),
          SizedBox(width: 16.0),
          Text('Mon'),
          Checkbox(
            value: _selectedDaysOfWeek["Mon"] ?? false,
            onChanged: (bool? value) =>
                _updateSelectedDaysOfWeek("Mon", value!),
          ),
          Text('Tue'),
          Checkbox(
            value: _selectedDaysOfWeek["Tue"] ?? false,
            onChanged: (bool? value) =>
                _updateSelectedDaysOfWeek("Tue", value!),
          ),
          Text('Wed'),
          Checkbox(
            value: _selectedDaysOfWeek["Wed"] ?? false,
            onChanged: (bool? value) =>
                _updateSelectedDaysOfWeek("Wed", value!),
          ),
          Text('Thur'),
          Checkbox(
            value: _selectedDaysOfWeek["Thu"] ?? false,
            onChanged: (bool? value) =>
                _updateSelectedDaysOfWeek("Thu", value!),
          ),
          Text('Fri'),
          Checkbox(
            value: _selectedDaysOfWeek["Fri"] ?? false,
            onChanged: (bool? value) =>
                _updateSelectedDaysOfWeek("Fri", value!),
          ),
          Text('Sat'),
          Checkbox(
            value: _selectedDaysOfWeek["Sat"] ?? false,
            onChanged: (bool? value) =>
                _updateSelectedDaysOfWeek("Sat", value!),
          ),
          Text('Sun'),
          Checkbox(
            value: _selectedDaysOfWeek["Sun"] ?? false,
            onChanged: (bool? value) =>
                _updateSelectedDaysOfWeek("Sun", value!),
          ),
          SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: () => _addShift(),
            child: Text('Add Shift'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (picked != null && picked != _selectedEndTime) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  void _updateSelectedDaysOfWeek(String day, bool value) {
    setState(() {
      _selectedDaysOfWeek[day] = value;
    });
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  void _addShift() {
    Shift newShift = Shift(
      name: _nameController.text,
      startTime: _selectedStartTime,
      endTime: _selectedEndTime,
      daysOfWeek: Map.from(_selectedDaysOfWeek),
    );

    widget.onAddShift(newShift);

    setState(() {
      _nameController.clear();
      _selectedDaysOfWeek = {
        'Mon': false,
        'Tue': false,
        'Wed': false,
        'Thu': false,
        'Fri': false,
        'Sat': false,
        'Sun': false,
      };
    });
  }
}
