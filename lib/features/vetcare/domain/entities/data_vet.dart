import 'package:equatable/equatable.dart';

class DataVetEntity extends Equatable {
  final dynamic isRegistered;
  final dynamic isApplyInvitation;
  final dynamic vetICareId;
  final dynamic name;
  final dynamic phone;
  final dynamic countryId;
  final dynamic gender;
  final dynamic email;
  final dynamic clinicName;
  final dynamic clinicCode;
  final dynamic squeakUserId;

  const DataVetEntity({
    required this.isRegistered,
    required this.isApplyInvitation,
    required this.vetICareId,
    required this.name,
    required this.phone,
    required this.countryId,
    required this.gender,
    required this.email,
    required this.clinicName,
    required this.clinicCode,
    required this.squeakUserId,
  });

  @override
  List<Object?> get props => [
    isRegistered,
    isApplyInvitation,
    vetICareId,
    name,
    phone,
    countryId,
    gender,
    email,
    clinicName,
    clinicCode,
    squeakUserId,
  ];
}
