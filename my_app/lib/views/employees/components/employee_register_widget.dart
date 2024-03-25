//24/03/2024

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_text_form_field.dart';
import '../../../services/employee_service.dart';

class RegisterEmployee extends StatefulWidget {
  const RegisterEmployee({Key? key}) : super(key: key);

  @override
  _RegisterEmployeeState createState() => _RegisterEmployeeState();
}

class _RegisterEmployeeState extends State<RegisterEmployee> {
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
              _buildCreateEmployeeForm(),
              const SizedBox(height: defaultPadding),
              _buildEmployeeWeeklyAvailability(),
              const SizedBox(height: defaultPadding),
              CustomElevatedButton(
                text: 'Submit',
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    Map<String, dynamic> formData = {
                      ..._formKey.currentState!.value,
                      'availability': availability,
                    };
                    try {
                      await _employeeService.createEmployee(formData);
                      _formKey.currentState?.reset();
                      setState(() {
                        availability.clear();
                      });
                    } catch (error) {
                      print('Error adding employee: $error');
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

  Widget _buildCreateEmployeeForm() {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      skipDisabled: true,
      child: const Column(
        children: [
          Text("Create Employee"),
          SizedBox(height: defaultPadding),
          Row(children: [
            Text("First Name: "),
            CustomTextFormField(
                placeholder: "Joe",
                label: "firstname",
                height: 40.0,
                width: 180.0),
            SizedBox(width: defaultPadding),
            Text("Surname: "),
            CustomTextFormField(
                placeholder: "Bloggs",
                label: "lastname",
                height: 40.0,
                width: 180.0),
          ]),
          SizedBox(height: defaultPadding),
          Row(children: [
            Text("Email: "),
            CustomTextFormField(
                placeholder: "email@provider.com",
                label: "email",
                height: 40.0,
                width: 180.0),
            SizedBox(width: defaultPadding),
            Text("Phone: "),
            CustomTextFormField(
                placeholder: "0876543210",
                label: "number",
                height: 40.0,
                width: 180.0),
            SizedBox(width: defaultPadding),
          ]),
          SizedBox(height: defaultPadding),
          Row(children: [
            Text("How many days per week can you work: "),
            CustomTextFormField(
                placeholder: "5",
                label: "days_per_week",
                height: 40.0,
                width: 65.0),
          ]),
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

    return Container(
      width: 350.0,
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
                      value: availability[day]?['start_time'],
                      onChanged: (value) {
                        setState(() {
                          availability[day] ??= {};
                          availability[day]!['start_time'] = value!;
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
                      value: availability[day]?['end_time'],
                      onChanged: (value) {
                        setState(() {
                          availability[day] ??= {};
                          availability[day]!['end_time'] = value!;
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

    for (int hour = buisnessOpeningTime; hour < buisnessClosingTime; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        String formattedHour = hour.toString().padLeft(2, '0');
        String formattedMinute = minute.toString().padLeft(2, '0');
        intervals.add('$formattedHour:$formattedMinute');
      }
    }
    return intervals;
  }
}
