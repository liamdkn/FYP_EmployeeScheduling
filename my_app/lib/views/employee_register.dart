//25/01/2024

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/employee_service.dart'; // Import your service class

class RegisterEmployee extends StatefulWidget {
  const RegisterEmployee({Key? key}) : super(key: key);

  @override
  _RegisterEmployeeState createState() => _RegisterEmployeeState();
}

class _RegisterEmployeeState extends State<RegisterEmployee> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Map to store the selected start and end times for each day
  Map<String, Map<String, String>> dayTimeMap = {};

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final EmployeeService _employeeService = EmployeeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Employee'),
      ),
      body: SingleChildScrollView(
        child: _buildStyledContainer(),
      ),
    );
  }

  Widget _buildStyledContainer() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          skipDisabled: true,
          child: Column(
            children: [
              FormBuilderTextField(
                name: "firstname",
                decoration: InputDecoration(labelText: "First Name"),
              ),
              FormBuilderTextField(
                name: "lastname",
                decoration: InputDecoration(labelText: "Last Name"),
              ),
              FormBuilderTextField(
                name: "email",
                decoration: InputDecoration(labelText: "Email Address"),
              ),
              FormBuilderTextField(
                name: "number",
                decoration: InputDecoration(labelText: "Phone Number"),
              ),
              _buildDaysWithTwoDropdowns(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    // Combine the form data with dayTimeMap
                    Map<String, dynamic> formData = {
                      ..._formKey.currentState!.value,
                      'dayTimeMap': dayTimeMap,
                    };
                    try {
                      await _employeeService.addEmployee(formData);
                      print("Form sent");
                      // Clear the form and dayTimeMap after successfully saving to Firestore
                      _formKey.currentState?.reset();
                      setState(() {
                        dayTimeMap.clear();
                      });
                    } catch (error) {
                      print('Front end: Error adding employee: $error');
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          )),
    );
  }

  Widget _buildDaysWithTwoDropdowns() {
    return Column(
      children:
          daysOfWeek.map((day) => _buildDayRowWithTwoDropdowns(day)).toList(),
    );
  }

  Widget _buildDayRowWithTwoDropdowns(String day) {
    List<String> dropdownOptions = generateHalfHourIntervals();

    return Row(
      children: [
        Text(day),
        SizedBox(width: 8),
        DropdownButton<String>(
          value: dayTimeMap[day] != null ? dayTimeMap[day]!['startTime'] : null,
          onChanged: (value) {
            setState(() {
              dayTimeMap[day] ??= {};
              dayTimeMap[day]!['startTime'] = value!;
            });
          },
          items: dropdownOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
        SizedBox(width: 8),
        DropdownButton<String>(
          value: dayTimeMap[day] != null ? dayTimeMap[day]!['endTime'] : null,
          onChanged: (value) {
            setState(() {
              dayTimeMap[day] ??= {};
              dayTimeMap[day]!['endTime'] = value!;
            });
          },
          items: dropdownOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<String> generateHalfHourIntervals() {
    List<String> intervals = [];

    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        String formattedHour = hour.toString().padLeft(2, '0');
        String formattedMinute = minute.toString().padLeft(2, '0');
        intervals.add('$formattedHour:$formattedMinute');
      }
    }

    return intervals;
  }
}
