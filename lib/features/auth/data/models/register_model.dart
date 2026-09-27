class RegisterModel {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;

  RegisterModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "email": email,
    "password": password,
    "phoneNumber": phoneNumber,
    "address": address,
  };
}