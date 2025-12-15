import '../../domain/entities/data_vet.dart';

class DataVetModel extends DataVetEntity {
  const DataVetModel({
    required super.isRegistered,
    required super.isApplyInvitation,
    required super.vetICareId,
    required super.name,
    required super.phone,
    required super.countryId,
    required super.gender,
    required super.email,
    required super.clinicName,
    required super.clinicCode,
    required super.squeakUserId,
  });

  factory DataVetModel.fromJson(Map<String, dynamic> json) => DataVetModel(
    isRegistered: json["isRegistered"],
    isApplyInvitation: json["isApplyInvitation"],
    vetICareId: json["vetICareId"],
    name: json["name"],
    phone: json["phone"],
    countryId: json["countryId"],
    gender: json["gender"],
    email: json["email"] ?? '',
    clinicName: json["clinicName"],
    clinicCode: json["clinicCode"],
    squeakUserId: json["squeakUserId"],
  );

  Map<String, dynamic> toJson() => {
    "isRegistered": isRegistered,
    "isApplyInvitation": isApplyInvitation,
    "vetICareId": vetICareId,
    "name": name,
    "phone": phone,
    "countryId": countryId,
    "gender": gender,
    "email": email,
    "clinicName": clinicName,
    "clinicCode": clinicCode,
    "squeakUserId": squeakUserId,
  };
}
