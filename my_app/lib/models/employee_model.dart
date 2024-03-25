class Employee {
  final String id;
  final String firstname;
  final String lastname;
  final int daysPerWeek;
  final Map<String, Map<String, String>> availability;
  final bool isAdmin;
  final bool isDeleted;

  Employee({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.daysPerWeek,
    required this.availability,
    required this.isAdmin,
    required this.isDeleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'days_per_week': daysPerWeek,
      'availability': availability,
      'is_admin': isAdmin,
      'is_deleted': isDeleted,
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> availabilityData = json['availability'];
    Map<String, Map<String, String>> availability = {};
    availabilityData.forEach((key, value) {
      availability[key] = {
        'start_time': value['start_time'],
        'end_time': value['end_time'],
      };
    });

    return Employee(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      daysPerWeek: json['days_per_week'],
      availability: availability,
      isAdmin: json['is_admin'],
      isDeleted: json['is_deleted'],
    );
  }
}
