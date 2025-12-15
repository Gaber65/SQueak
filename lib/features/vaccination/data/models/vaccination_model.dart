import '../../domain/entities/vaccination_entity.dart';
import '../../../../core/service/global_function/format_utils.dart';

class VaccinationModel extends VaccinationEntity {
  const VaccinationModel({
    required super.id,
    required super.petId,
    required super.vaccinationId,
    required super.vacDate,
    required super.status,
    required super.comment,
    required VaccinationNameModel super.vaccination,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'vaccinationId': vaccinationId,
      'vacDate': vacDate,
      'status': status,
      'comment': comment,
      'vaccination': (vaccination as VaccinationNameModel).toJson(),
    };
  }
}

class VaccinationNameModel extends VaccinationNameEntity {
  const VaccinationNameModel({required super.vacName, required super.vacID});

  factory VaccinationNameModel.fromJson(Map<String, dynamic> json) {
    return VaccinationNameModel(
      vacName: isArabic() ? json['arName'] : json['enName'],
      vacID: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'vacName': vacName, 'id': vacID};
  }
}
