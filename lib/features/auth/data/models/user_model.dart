class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phoneNumber: (json['phoneNumber'] ?? '') as String,
      address: (json['address'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
  };
}