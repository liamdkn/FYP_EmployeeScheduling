import 'package:my_app/models/employee_model.dart';

class IndividualShift {
  static int _idCounter = 0; //unique id

  final String id;
  final String name;
  final String day;
  final String startTime;
  final String endTime;
  Employee? employee;
  final String date;

  IndividualShift({
    required this.name,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.employee,
    required this.date,
  }) : id = (++_idCounter).toString(); //increment id for each shift obj

  factory IndividualShift.fromJson(Map<String, dynamic> json) {
    return IndividualShift(
      name: json['name'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      employee:
          json['employee'] != null ? Employee.fromJson(json['employee']) : null,
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'employee': employee?.toJson(),
      'date': date,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }
}
