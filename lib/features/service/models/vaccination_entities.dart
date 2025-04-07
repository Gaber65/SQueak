import 'package:squeak/core/constant/global_function/global_function.dart';

class VaccinationModel {
  final String id;
  final String petId;
  final String vaccinationId;
  final String vacDate;
  final bool status;
  final String comment;
  final VaccinationNameModel vaccination;

  VaccinationModel({
    required this.id,
    required this.petId,
    required this.vaccinationId,
    required this.vacDate,
    required this.status,
    required this.comment,
    required this.vaccination,
  });


  factory VaccinationModel.fromJson(Map<String, dynamic> json) {
    return VaccinationModel(
      id: json['id'],
      petId: json['petId'],
      vaccinationId: json['vaccinationId'],
      vacDate: json['vacDate'],
      status: json['status'],
      comment: json['comment'],
      vaccination: VaccinationNameModel.fromJson(json['vaccination']),
    );
  }

}

class VaccinationNameModel {
  final String vacName;
  final String vacID;

  const VaccinationNameModel({
    required this.vacName,
    required this.vacID,
  });


  factory VaccinationNameModel.fromJson(Map<String, dynamic> json) {
    return VaccinationNameModel(
      vacName: isArabic() ? json['arName'] : json['enName'],
      vacID: json['id'],
    );
  }
}
