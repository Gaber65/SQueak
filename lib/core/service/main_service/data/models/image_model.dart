import 'package:squeak/core/service/main_service/domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  const ImageModel({required super.data});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(data: json['message'] ?? '');
  }
}
