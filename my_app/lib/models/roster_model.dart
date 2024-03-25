import 'package:my_app/models/shift_model.dart';

class Roster {
  final String rosterId;
  final List<IndividualShift> assignedShifts;
  final int conflicts;
  final double fitness;
  final int generations;

  Roster({
    required this.rosterId,
    required this.assignedShifts,
    required this.conflicts,
    required this.fitness,
    required this.generations,
  });

  factory Roster.fromJson(Map<String, dynamic> json) {
    List<dynamic> shiftsJson = json['assigned_shifts'];
    List<IndividualShift> shifts = shiftsJson
        .map((shiftJson) => IndividualShift.fromJson(shiftJson))
        .toList();

    return Roster(
      rosterId: json['roster_id'],
      assignedShifts: shifts,
      conflicts: json['conflicts'],
      fitness: json['fitness'],
      generations: json['generations'],
    );
  }
}
