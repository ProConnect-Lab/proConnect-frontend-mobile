class RegisterPayload {
  RegisterPayload({
    required this.name,
    required this.email,
    required this.password,
    required this.accountType,
    required this.address,
    this.companyName,
    this.companyAddress,
    this.cfeNumber,
  });

  final String name;
  final String email;
  final String password;
  final String accountType;
  final String address;
  final String? companyName;
  final String? companyAddress;
  final String? cfeNumber;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'account_type': accountType,
      'address': address,
      if (companyName != null) 'company_name': companyName,
      if (companyAddress != null) 'company_address': companyAddress,
      if (cfeNumber != null) 'cfe_number': cfeNumber,
    };
  }
}

class LoginPayload {
  LoginPayload({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
