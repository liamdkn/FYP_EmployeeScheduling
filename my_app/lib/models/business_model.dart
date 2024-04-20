class Business {
  final String? businessId;
  final String name;
  final String openingTime;
  final String closingTime;
  final String number;
  final String email;
  final bool isDeleted;

  Business({
    this.businessId,
    required this.name,
    required this.openingTime,
    required this.closingTime,
    required this.number,
    required this.email,
    this.isDeleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'business_id': businessId,
      'name': name,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'number': number,
      'email': email,
      'is_deleted': isDeleted,
    };
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessId: json['business_id'],
      name: json['name'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      number: json['number'],
      email: json['email'],
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Business { id: $businessId, name: $name }';
  }
}
