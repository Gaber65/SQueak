import '../../domain/entities/cage_entity.dart';

class CageModel extends CageEntity {
  const CageModel({required super.name, required super.description});

  factory CageModel.fromJson(Map<String, dynamic> json) {
    return CageModel(
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description};
  }
}
