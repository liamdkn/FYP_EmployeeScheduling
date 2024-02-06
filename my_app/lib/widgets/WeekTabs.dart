import 'package:flutter/material.dart';

class ShiftListWidget extends StatefulWidget {
  const ShiftListWidget({Key? key}) : super(key: key);

  @override
  _ShiftListWidgetState createState() => _ShiftListWidgetState();
}

class _ShiftListWidgetState extends State<ShiftListWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  List<int> _selectedDaysOfWeek = [];
  List<Shift> shifts = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedStartTime = TimeOfDay.now();
    _selectedEndTime = TimeOfDay.now();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              for (var i = 0; i < 7; i++)
                GestureDetector(
                  onTap: () => _toggleDay(i),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _selectedDaysOfWeek.contains(i)
                          ? Colors.blue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _getDayLabel(i),
                      style: TextStyle(
                        color: _selectedDaysOfWeek.contains(i)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => _addShift(),
          child: Text('Add Shift'),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(7, (index) => _buildDayTab(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildDayTab(int dayIndex) {
    final shiftsForDay =
        shifts.where((shift) => shift.daysOfWeek.contains(dayIndex)).toList();

    return ListView.builder(
      itemCount: shiftsForDay.length,
      itemBuilder: (context, index) {
        final shift = shiftsForDay[index];
        return ListTile(
          title: Text(shift.name),
          subtitle: Text(
            'Start Time: ${shift.startTime.format(context)}\n'
            'End Time: ${shift.endTime.format(context)}',
          ),
        );
      },
    );
  }

  void _toggleDay(int dayIndex) {
    setState(() {
      if (_selectedDaysOfWeek.contains(dayIndex)) {
        _selectedDaysOfWeek.remove(dayIndex);
      } else {
        _selectedDaysOfWeek.add(dayIndex);
      }
    });
  }

  void _selectStartTime(BuildContext context) async {
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

  void _selectEndTime(BuildContext context) async {
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

  void _addShift() {
    final shift = Shift(
      name: _nameController.text,
      startTime: _selectedStartTime,
      endTime: _selectedEndTime,
      daysOfWeek: _selectedDaysOfWeek.toList(),
    );
    setState(() {
      shifts.add(shift);
      _nameController.clear();
      _selectedDaysOfWeek.clear();
    });
  }

  String _getDayLabel(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return 'Mon';
      case 1:
        return 'Tue';
      case 2:
        return 'Wed';
      case 3:
        return 'Thu';
      case 4:
        return 'Fri';
      case 5:
        return 'Sat';
      case 6:
        return 'Sun';
      default:
        return '';
    }
  }
}

class Shift {
  final String name;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<int> daysOfWeek;

  Shift({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
  });
}
