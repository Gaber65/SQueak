import 'package:squeak/core/utils/export_path/export_files.dart';

class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.name,
    required this.image,
  });

  final String id;
  final String name;
  final String image;

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['fullName'],
      image: (json['image'] == null || json['image'] == '')
          ? 'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/vet-clinic-abstract-concept-vector-illustration-vet-hospital-surgery-vaccination-services-animal-clinic-pets-medical-care-veterinary-service-diagnostic-equipment-abstract-metaphor.png?alt=media&token=46eafb21-5c60-47b3-bc61-1c3f65f4629f'
          : imageUrl + json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = name;
    data['image'] = image;
    return data;
  }
}
