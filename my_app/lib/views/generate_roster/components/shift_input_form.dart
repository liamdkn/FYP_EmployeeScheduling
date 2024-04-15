import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_formbuilder_text_field.dart';
import 'package:my_app/views/main/components/custom_text_form_field.dart';
import '../../../models/shift_model.dart';

class ShiftInputWidget extends StatefulWidget {
  final Function(IndividualShift) onAddIndividualShift;
  final DateTime? startDate;

  const ShiftInputWidget({
    Key? key,
    required this.onAddIndividualShift,
    required this.startDate,
  }) : super(key: key);

  @override
  _ShiftInputWidgetState createState() => _ShiftInputWidgetState();
}

class _ShiftInputWidgetState extends State<ShiftInputWidget> {
  late TextEditingController _nameController;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  late List<bool> _selectedDaysOfWeek;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedStartTime = TimeOfDay(hour: 9, minute: 0);
    _selectedEndTime = TimeOfDay(hour: 17, minute: 0);
    _selectedDaysOfWeek = List<bool>.filled(7, false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: listBorderColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildWideLayout();
            } else {
              return _buildNarrowLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomFormBuilderTextField(
                  name: 'shiftName',
                  hintText: 'Enter shift name',
                  controller: _nameController,
                ),
                const SizedBox(height: defaultPadding),
                _buildTimePickerButton(
                  text: 'Start Time',
                  time: _selectedStartTime,
                  onPressed: _selectStartTime,
                ),
                const SizedBox(height: defaultPadding),
                _buildTimePickerButton(
                  text: 'End Time',
                  time: _selectedEndTime,
                  onPressed: _selectEndTime,
                ),
                const SizedBox(height: 32.0),
                CustomElevatedButton(
                  onPressed: _addIndividualShift,
                  text: "Add Shift",
                  width: double.infinity,
                )
              ],
            ),
          ),
          const SizedBox(width: 50.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: _buildDayOfWeekCheckboxes()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            label: 'shiftName',
            placeholder: 'Enter shift name',
            controller: _nameController,
            width: 200,
          ),
          const SizedBox(height: defaultPadding),
          _buildTimePickerButton(
            text: 'Start Time',
            time: _selectedStartTime,
            onPressed: _selectStartTime,
          ),
          const SizedBox(height: defaultPadding),
          _buildTimePickerButton(
            text: 'End Time',
            time: _selectedEndTime,
            onPressed: _selectEndTime,
          ),
          const SizedBox(height: defaultPadding),
          _buildDayOfWeekCheckboxes(),
          const SizedBox(height: defaultPadding),
          CustomElevatedButton(
            onPressed: _addIndividualShift,
            text: "Add Shift",
          )
        ],
      ),
    );
  }

  Widget _buildTimePickerButton({
    required String text,
    required TimeOfDay time,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('$text: ${time.format(context)}'),
    );
  }

  Widget _buildDayOfWeekCheckboxes() {
    return Container(
      constraints: BoxConstraints(maxWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(daysOfWeek.length, (index) {
          final day = daysOfWeek[index];
          return Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 16.0),
                child: Text(day),
              ),
              Spacer(),
              Checkbox(
                value: _selectedDaysOfWeek[index],
                onChanged: (value) {
                  setState(() {
                    _selectedDaysOfWeek[index] = value!;
                  });
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _selectStartTime() async {
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

  Future<void> _selectEndTime() async {
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

  void _addIndividualShift() {
    String shiftName = _nameController.text;
    String startTime =
        convertTimeTo24HourFormat(_selectedStartTime.format(context));
    String endTime =
        convertTimeTo24HourFormat(_selectedEndTime.format(context));
    List<bool> selectedDays = _selectedDaysOfWeek;

    DateTime selectedDate = widget.startDate!;
    int daysToSubtract = selectedDate.weekday - 1;
    DateTime startDate = selectedDate.subtract(Duration(days: daysToSubtract));

    List<int> selectedWeekDays = [];
    for (int i = 0; i < daysOfWeek.length; i++) {
      if (selectedDays[i]) {
        selectedWeekDays.add(i);
      }
    }
    //create shifts
    for (int dayIndex in selectedWeekDays) {
      DateTime shiftDate = startDate.add(Duration(days: dayIndex));
      String formattedDate = DateFormat('dd-MM-yyyy').format(shiftDate);
      IndividualShift individualShift = IndividualShift(
        name: shiftName,
        day: daysOfWeek[dayIndex],
        startTime: startTime,
        endTime: endTime,
        employee: null,
        date: formattedDate,
      );
      widget.onAddIndividualShift(individualShift);
    }

    setState(() {
      _nameController.clear();
      _selectedDaysOfWeek = List<bool>.filled(7, false);
    });
  }

  String convertTimeTo24HourFormat(String time) {
    final format = time.contains('AM') ? 'AM' : 'PM';
    final splitTime = time.split(':');
    final hour = int.parse(splitTime[0]);
    final minute = splitTime[1].split(' ')[0];
    final formattedHour = format == 'AM' ? hour % 12 : (hour % 12) + 12;
    return '${formattedHour.toString().padLeft(2, '0')}:$minute';
  }
}
