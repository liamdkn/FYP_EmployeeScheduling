//8/02/2024

import 'package:flutter/material.dart';
import 'package:my_app/models/employee_model.dart'; 

class Shift {
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;
  Map<String, bool> daysOfWeek;

  Shift({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startTime': _timeOfDayToString(startTime),
      'endTime': _timeOfDayToString(endTime),
      'daysOfWeek': daysOfWeek,
    };
  }

  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }
}

class IndividualShift {
  final String name;
  final String day;
  final String startTime;
  final String endTime;
  final Employee? employee;

  IndividualShift({
    required this.name,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.employee,
  });

  factory IndividualShift.fromJson(Map<String, dynamic> json) {
  return IndividualShift(
    name: json['name'] ?? '',
    day: json['day'] ?? '',
    startTime: json['start_time'] ?? '', 
    endTime: json['end_time'] ?? '', 
    employee: Employee.fromJson(json['employee']),
  );
}


}

