class Company {
  Company({
    required this.id,
    required this.name,
    this.cfeNumber,
    this.address,
  });

  final int id;
  final String name;
  final String? cfeNumber;
  final String? address;

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as int,
      name: json['name'] as String,
      cfeNumber: json['cfe_number'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cfe_number': cfeNumber,
      'address': address,
    };
  }
}
