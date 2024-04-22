class Employee {
  final String? id;
  final String firstName;
  final String lastName;
  final int daysPerWeek;
  final Map<String, Map<String, String>> availability;
  final bool isAdmin;
  final bool isDeleted;
  final String email;
  final String number;
  final String? businessId;

  Employee({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.daysPerWeek,
    required this.availability,
    required this.isAdmin,
    required this.isDeleted,
    required this.email,
    required this.number,
    this.businessId,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'firstname': firstName,
      'lastname': lastName,
      'days_per_week': daysPerWeek,
      'availability': availability,
      'is_admin': isAdmin,
      'is_deleted': isDeleted,
      'email': email,
      'number': number,
      'business_id': businessId,
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
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
      firstName: json['firstname'],
      lastName: json['lastname'],
      daysPerWeek: json['days_per_week'],
      availability: availability,
      isAdmin: json['is_admin'],
      isDeleted: json['is_deleted'],
      email: json['email'],
      number: json['number'],
      businessId: json['business_id'],
    );
  }

  @override
  String toString() {
    return 'Employee { id: $id, firstName: $firstName, lastName: $lastName, email: $email, number: $number, daysPerWeek: $daysPerWeek, isAdmin: $isAdmin, isDeleted: $isDeleted, availability: $availability, businessId: $businessId }';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Employee &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.daysPerWeek == daysPerWeek &&
        other.businessId == businessId;
  }

  @override
  int get hashCode {
    return Object.hash(
      firstName,
      lastName,
      daysPerWeek,
      businessId,
    );
  }
}
