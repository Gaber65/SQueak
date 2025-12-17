import 'package:equatable/equatable.dart';

class Owner extends Equatable {
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

  const Owner({
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

  @override
  List<Object?> get props => [
    userName,
    fullName,
    email,
    phone,
    address,
    imageName,
    birthdate,
    gender,
    role,
    id,
    countryId,
  ];

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phone,
      'address': address,
      'imageName': imageName,
      'birthDate': birthdate,
      'gender': gender,
      'userType': role,
      'id': id,
    };
  }
}
