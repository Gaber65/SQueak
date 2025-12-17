import 'package:equatable/equatable.dart';

class Clinic extends Equatable {
  final String id;
  final String name;
  final String location;
  final String city;
  final String address;
  final String phone;
  final String image;
  final String code;
  final AdminEntity? admin;
  final List<SpecialityEntity> specialities;

  const Clinic({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.address,
    required this.phone,
    required this.image,
    required this.code,
    required this.admin,
    required this.specialities,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    city,
    address,
    phone,
    image,
    code,
    admin,
    specialities,
  ];
}

class AdminEntity extends Equatable {
  final String id;
  final String fullName;
  final dynamic image;
  final int gender;
  final dynamic doctorCode;
  final dynamic specialization;

  const AdminEntity({
    required this.id,
    required this.fullName,
    required this.image,
    required this.gender,
    required this.doctorCode,
    required this.specialization,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    image,
    gender,
    doctorCode,
    specialization,
  ];
}

class SpecialityEntity extends Equatable {
  final String id;
  final String name;

  const SpecialityEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class ClinicInfo extends Equatable {
  final Clinic data;
  final String id;

  const ClinicInfo({required this.data, required this.id});

  @override
  List<Object?> get props => [data, id];
}

class MySupplier extends Equatable {
  final List<ClinicInfo> data;

  const MySupplier({required this.data});

  @override
  List<Object?> get props => [data];
}
