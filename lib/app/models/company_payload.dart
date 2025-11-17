class CompanyPayload {
  CompanyPayload({
    required this.name,
    required this.cfeNumber,
    required this.address,
  });

  final String name;
  final String cfeNumber;
  final String address;

  Map<String, dynamic> toJson() => {
        'name': name,
        'cfe_number': cfeNumber,
        'address': address,
      };
}
