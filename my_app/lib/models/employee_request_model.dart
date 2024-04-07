import 'package:intl/intl.dart';

class TimeOffRequest {
  String? requestId;
  String employeeId;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  bool isAllDay;
  String requestType;
  String reason;
  String status;
  bool isEmergency;
  DateTime submissionDate;
  bool isDeleted;

  TimeOffRequest({
    this.requestId,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.requestType,
    required this.reason,
    required this.status,
    required this.isEmergency,
    required this.submissionDate,
    required this.isDeleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'employee_id': employeeId,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
      'is_all_day': isAllDay,
      'request_type': requestType,
      'reason': reason,
      'status': status,
      'is_emergency': isEmergency,
      'submission_date': DateFormat('dd-MM-yyyy HH:mm').format(submissionDate),
      'is_deleted': isDeleted,
    };
  }

  factory TimeOffRequest.fromJson(Map<String, dynamic> json) {
    return TimeOffRequest(
      requestId: json['request_id'],
      employeeId: json['employee_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isAllDay: json['is_all_day'],
      requestType: json['request_type'],
      reason: json['reason'],
      status: json['status'],
      isEmergency: json['is_emergency'],
      submissionDate:
          DateFormat('dd-MM-yyyy HH:mm').parse(json['submission_date']),
      isDeleted: json['is_deleted'],
    );
  }
}
