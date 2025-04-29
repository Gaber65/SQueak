import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../domain/entities/post_entity.dart'; // عشان ErrorMessageModel


class PostDataModel extends PostEntity {
  PostDataModel({
    required super.title,
    required super.content,
    required super.createdAt,
    required super.video,
    required super.clinic,
    required super.specieId,
    required super.specie,
    required super.clinicId,
    required super.numberOfComments,
    required super.postId,
    required super.image,
  });

  factory PostDataModel.fromJson(Map<String, dynamic> json) {
    return PostDataModel(
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'],
      video: json['video'],
      clinic: ClinicModel.fromJson(json['clinic']),
      specieId: json['specieId'],
      specie:
          json['speciePost'] != null
              ? SpecieModel.fromJson(json['speciePost'])
              : null,
      clinicId: json['clinicId'],
      numberOfComments: json['numberOfComments'],
      postId: json['id'],
      image: json['image'],
    );
  }
}

class ClinicModel extends ClinicEntity {
  ClinicModel({
    required super.name,
    required super.location,
    required super.city,
    required super.address,
    required super.phone,
    required super.image,
    required super.code,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      name: json['name'],
      location: json['location'],
      city: json['city'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'] ?? '120240808070538549.png',
      code: json['code'],
    );
  }
}

class SpecieModel extends SpecieEntity {
  SpecieModel({required super.arType, required super.enType});

  factory SpecieModel.fromJson(Map<String, dynamic> json) {
    return SpecieModel(arType: json['arType'], enType: json['enType']);
  }
}
