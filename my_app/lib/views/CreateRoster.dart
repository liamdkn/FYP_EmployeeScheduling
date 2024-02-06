import 'package:flutter/material.dart';

class Shift {
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<int> daysOfWeek;

  Shift({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
  });
}

class ShiftListWidget extends StatefulWidget {
  @override
  _ShiftListWidgetState createState() => _ShiftListWidgetState();
}

class _ShiftListWidgetState extends State<ShiftListWidget> {
  List<Shift> shifts = [];

  late TextEditingController _nameController;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  List<int> _selectedDaysOfWeek = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedStartTime = TimeOfDay(hour: 9, minute: 0);
    _selectedEndTime = TimeOfDay(hour: 17, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
                child:
                    Text('Start Time: ${_selectedStartTime.format(context)}'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () => _selectEndTime(context),
                child: Text('End Time: ${_selectedEndTime.format(context)}'),
              ),
              SizedBox(width: 16.0),
              // Individual columns for each day
              Column(
                children: [
                  Text('Mon'),
                  Checkbox(
                    value: _selectedDaysOfWeek.contains(DateTime.monday),
                    onChanged: (bool? value) =>
                        _updateSelectedDaysOfWeek(DateTime.monday, value),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Tue'),
                  Checkbox(
                    value: _selectedDaysOfWeek.contains(DateTime.tuesday),
                    onChanged: (bool? value) =>
                        _updateSelectedDaysOfWeek(DateTime.tuesday, value),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Wed'),
                  Checkbox(
                    value: _selectedDaysOfWeek.contains(DateTime.wednesday),
                    onChanged: (bool? value) =>
                        _updateSelectedDaysOfWeek(DateTime.wednesday, value),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Thu'),
                  Checkbox(
                    value: _selectedDaysOfWeek.contains(DateTime.thursday),
                    onChanged: (bool? value) =>
                        _updateSelectedDaysOfWeek(DateTime.thursday, value),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Fri'),
                  Checkbox(
                    value: _selectedDaysOfWeek.contains(DateTime.friday),
                    onChanged: (bool? value) =>
                        _updateSelectedDaysOfWeek(DateTime.friday, value),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Sat'),
                  Checkbox(
                    value: _selectedDaysOfWeek.contains(DateTime.saturday),
                    onChanged: (bool? value) =>
                        _updateSelectedDaysOfWeek(DateTime.saturday, value),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Sun'),
                  Checkbox(
                    value: _selectedDaysOfWeek.contains(DateTime.sunday),
                    onChanged: (bool? value) =>
                        _updateSelectedDaysOfWeek(DateTime.sunday, value),
                  ),
                ],
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => _addShift(),
          child: Text('Add Shift'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: shifts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(shifts[index].name),
                subtitle: Text(
                  'Start Time: ${shifts[index].startTime.format(context)}\n'
                  'End Time: ${shifts[index].endTime.format(context)}\n'
                  'Days: ${_getSelectedDaysOfWeek(shifts[index].daysOfWeek)}',
                ),
              );
            },
          ),
        ),
        // Container for the TabBar and TabBarView
        Container(
          height: 400,
          child: ShiftTabs(),
        ),
      ],
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

  void _updateSelectedDaysOfWeek(int day, bool? value) {
    setState(() {
      if (value != null && value) {
        _selectedDaysOfWeek.add(day);
      } else {
        _selectedDaysOfWeek.remove(day);
      }
    });
  }

  String _getSelectedDaysOfWeek(List<int> days) {
    if (days.isEmpty) {
      return 'None';
    }
    String result = '';
    days.forEach((day) {
      result += '${_getDayOfWeek(day)}, ';
    });
    return result.substring(0, result.length - 2);
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
    setState(() {
      shifts.add(
        Shift(
          name: _nameController.text,
          startTime: _selectedStartTime,
          endTime: _selectedEndTime,
          daysOfWeek: List.from(_selectedDaysOfWeek),
        ),
      );
      _nameController.clear();
      _selectedDaysOfWeek.clear();
    });
  }
}

class CreateRoster extends StatefulWidget {
  const CreateRoster({Key? key}) : super(key: key);

  @override
  _CreateRosterState createState() => _CreateRosterState();
}

class _CreateRosterState extends State<CreateRoster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Roster'),
      ),
      body: Center(
        child: ShiftListWidget(),
      ),
    );
  }
}

class ShiftTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
              Tab(text: 'Sat'),
              Tab(text: 'Sun'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Placeholder for Monday
                Container(),
                // Placeholder for Tuesday
                Container(),
                // Placeholder for Wednesday
                Container(),
                // Placeholder for Thursday
                Container(),
                // Placeholder for Friday
                Container(),
                // Placeholder for Saturday
                Container(),
                // Placeholder for Sunday
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreateRoster(),
  ));
}
