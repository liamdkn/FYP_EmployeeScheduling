import 'package:flutter/material.dart';

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

  // Helper method to convert TimeOfDay to string
  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }
}
