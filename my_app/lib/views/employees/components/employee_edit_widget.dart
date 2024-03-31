//25/01/2024

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_text_form_field.dart';
import '../../../services/employee_service.dart';

class EditEmployee extends StatefulWidget {
  final Employee employee;

  const EditEmployee({Key? key, required this.employee}) : super(key: key);

  @override
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, Map<String, String>> availability = {};

  final EmployeeService _employeeService = EmployeeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildEditEmployeeForm(),
              const SizedBox(height: defaultPadding),
              _buildEmployeeWeeklyAvailability(),
              const SizedBox(height: defaultPadding),
              CustomElevatedButton(
                text: 'Update',
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    Map<String, dynamic> formData = {
                      ..._formKey.currentState!.value,
                      'availability': availability,
                    };
                    print('FormDataeee: $formData');
                    try {
                      await _employeeService.editEmployee(
                          widget.employee.id, formData);
                      _formKey.currentState?.reset();
                      setState(() {
                        availability.clear();
                      });
                      Navigator.pop(context);
                    } catch (error) {
                      print('Error updating employee: $error');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditEmployeeForm() {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      skipDisabled: true,
      initialValue: {
        'firstname': widget.employee.firstName,
        'lastname': widget.employee.lastName,
        'email': widget.employee.email,
        'number': widget.employee.number,
        'days_per_week': widget.employee.daysPerWeek.toString(),
      },
      child: Column(
        children: [
          Text("Edit Employee"),
          SizedBox(height: defaultPadding),
          Row(
            children: [
              Text("First Name: "),
              CustomTextFormField(
                label: "firstname",
                height: 40.0,
                width: 180.0,
                initialValue: widget.employee.firstName,
              ),
              SizedBox(width: defaultPadding),
              Text("Surname: "),
              CustomTextFormField(
                label: "lastname",
                height: 40.0,
                width: 180.0,
                initialValue: widget.employee.lastName,
              ),
            ],
          ),
          SizedBox(height: defaultPadding),
          Row(
            children: [
              Text("Email: "),
              CustomTextFormField(
                label: "email",
                height: 40.0,
                width: 220.0,
                initialValue: widget.employee.email,
              ),
              SizedBox(width: defaultPadding),
              Text("Phone: "),
              CustomTextFormField(
                label: "number",
                height: 40.0,
                width: 180.0,
                initialValue: widget.employee.number,
              ),
              SizedBox(width: defaultPadding),
            ],
          ),
          SizedBox(height: defaultPadding),
          Row(
            children: [
              Text("How many days per week can you work: "),
              CustomTextFormField(
                label: "days_per_week",
                height: 40.0,
                width: 65.0,
                initialValue: widget.employee.daysPerWeek.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeWeeklyAvailability() {
    return Column(
      children:
          daysOfWeek.map((day) => _buildDayAvailabilityColumn(day)).toList(),
    );
  }

  Widget _buildDayAvailabilityColumn(String day) {
    List<String> dropdownOptions = generateHalfHourIntervals();

    Map<String, dynamic>? employeeAvailability = widget.employee.availability;
    Map<String, String>? dayAvailability;

    if (employeeAvailability != null && employeeAvailability.containsKey(day)) {
      dayAvailability = Map<String, String>.from(employeeAvailability[day]);
    }

    return Container(
      width: 450.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                day,
                style: const TextStyle(color: primaryTextColour),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: dayAvailability != null
                          ? dayAvailability['start_time']
                          : null,
                      onChanged: (value) {
                        setState(() {
                          if (employeeAvailability != null) {
                            employeeAvailability[day]['start_time'] = value!;
                          }
                        });
                      },
                      items: dropdownOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButton<String>(
                      value: dayAvailability != null
                          ? dayAvailability['end_time']
                          : null,
                      onChanged: (value) {
                        setState(() {
                          if (employeeAvailability != null) {
                            employeeAvailability[day]['end_time'] = value!;
                          }
                        });
                      },
                      items: dropdownOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: const TextStyle(color: primaryTextColour),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> generateHalfHourIntervals() {
    List<String> intervals = [];

    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        String formattedHour = hour.toString().padLeft(2, '0');
        String formattedMinute = minute.toString().padLeft(2, '0');
        intervals.add('$formattedHour:$formattedMinute:00');
      }
    }
    return intervals;
  }
}
