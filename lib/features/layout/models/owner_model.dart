class OwnerModel {
  final String userName;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String imageName;
  final dynamic countryId;
  final String birthdate;
  final int gender;
  final int role;
  final String id;

  const OwnerModel({
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phone,
    required this.address,
    required this.imageName,
    required this.birthdate,
    required this.gender,
    required this.role,
    required this.id,
    required this.countryId,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      userName: json['userName'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      imageName: json['imageName'] ?? '',
      birthdate: json['birthDate'] ?? '',
      gender: json['gender'] ?? 1,
      role: json['userType'] ?? 1,
      countryId: json['countryId'] ?? 1,
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['fullName'] = fullName;
    data['email'] = email;
    data['phoneNumber'] = phone;
    data['address'] = address;
    data['imageName'] = imageName;
    data['birthDate'] = birthdate;
    data['gender'] = gender;
    data['userType'] = role;
    data['id'] = id;
    return data;
  }
}
