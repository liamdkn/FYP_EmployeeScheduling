//16/03/2024

class Employee {
  final String id;
  final String firstname;
  final String lastname;
  final int daysPerWeek;
  final List<String> availability;

  Employee({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.daysPerWeek,
    required this.availability,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'days_per_week': daysPerWeek,
      'availability': availability,
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {

  Map<String, dynamic> availabilityData = json['availability'];
  List<String> availability = [];
  availabilityData.forEach((key, value) {
    availability.add('$key: ${value['start_time']} - ${value['end_time']}');
  });

  return Employee(
    id: json['id'],
    firstname: json['firstname'],
    lastname: json['lastname'],
    daysPerWeek: json['days_per_week'],
    availability: availability,
  );
}


  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      daysPerWeek: map['days_per_week'],
      availability: List<String>.from(map['availability']),
    );
  }
}
