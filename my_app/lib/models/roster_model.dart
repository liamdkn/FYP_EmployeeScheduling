//16/03/2024

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
  List<IndividualShift> assignedShifts = [];
  
  try {
    if (json.containsKey('assigned_shifts') && json['assigned_shifts'] is List) {
      assignedShifts = List<IndividualShift>.from((json['assigned_shifts'] as List).map((shift) {
        if (shift is Map<String, dynamic>) {
          return IndividualShift.fromJson(shift);
        } else {
          print('Invalid shift data: $shift');
        }
      }));
    } else {
      print('No assigned shifts found or assigned shifts is not a list.');
    }
  } catch (error) {
    print('Error parsing shift data in roster from JSON: $error');
  }
  
  return Roster(
    rosterId: json['roster_id'] ?? '',
    assignedShifts: assignedShifts,
    conflicts: json['conflicts'] ?? 0,
    fitness: json['fitness'] ?? 0.0,
    generations: json['generations'] ?? 0,
  );
}
}