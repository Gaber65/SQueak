import '../../domain/entities/owner_entite.dart';

class OwnerModel extends Owner {
  const OwnerModel({
    required super.fullName,
    required super.userName,
    required super.email,
    required super.phone,
    required super.address,
    required super.imageName,
    required super.birthdate,
    required super.gender,
    required super.role,
    required super.id,
    required super.countryId,
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
      gender: json['gender'],
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
