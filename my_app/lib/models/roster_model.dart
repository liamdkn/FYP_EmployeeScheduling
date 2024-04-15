import 'package:intl/intl.dart';
import 'package:my_app/models/shift_model.dart';

class Roster {
  final String? rosterId;
  final String? rosterName;
  final List<IndividualShift> assignedShifts;
  final int? conflicts;
  final double fitness;
  final int? generations;
  final String startDate;
  final DateTime? endDate;
  final bool? isCurrentRoster;
  final bool isPublished;
  final DateTime? dateCreated;
  final int? weekNumber;
  final bool isDeleted;

  Roster({
    this.rosterId,
    this.rosterName,
    required this.assignedShifts,
    this.conflicts,
    required this.fitness,
    this.generations,
    required this.startDate,
    this.endDate,
    this.isCurrentRoster,
    required this.isPublished,
    this.dateCreated,
    this.weekNumber,
    required this.isDeleted,
  });

  Map<String, dynamic> toJson() {
    ;
    return {
      'roster_id': rosterId,
      'roster_name': rosterName,
      'assigned_shifts': assignedShifts.map((shift) => shift.toJson()).toList(),
      'conflicts': conflicts,
      'fitness': fitness,
      'generations': generations,
      'start_date': startDate,
      'end_date': endDate?.toIso8601String(),
      'is_current_roster': isCurrentRoster,
      'is_published': isPublished,
      'date_created': dateCreated?.toIso8601String(),
      'week_number': weekNumber,
      'is_deleted': isDeleted,
    };
  }

  factory Roster.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> shiftsJson =
        List<Map<String, dynamic>>.from(json['assigned_shifts']);
    List<IndividualShift> shifts = shiftsJson
        .map((shiftJson) => IndividualShift.fromJson(shiftJson))
        .toList();

    return Roster(
      rosterId: json['roster_id'],
      rosterName: json['roster_name'] ?? 'Roster Name',
      assignedShifts: shifts,
      conflicts: json['conflicts'] ?? 0,
      fitness: json['fitness'] ?? 0.0,
      generations: json['generations'] ?? 0,
      startDate: json['start_date'],
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      isCurrentRoster: json['is_current_roster'] as bool? ?? false,
      isPublished: json['is_published'],
      dateCreated: json['date_created'] != null
          ? DateTime.parse(json['date_created'])
          : null,
      weekNumber: json['week_number'] as int? ?? 0,
      isDeleted: json['is_deleted'] ?? false,
    );
  }
}
