import '../../domain/entities/boarding_type_entity.dart';

class BoardingTypeModel extends BoardingTypeEntity {
  const BoardingTypeModel({
    required super.id,
    required super.code,
    required super.name,
    required super.price,
    required super.unit,
    required super.isActive,
    required super.isSqueakVisible,
  });

  factory BoardingTypeModel.fromJson(Map<String, dynamic> json) {
    return BoardingTypeModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      price: json['price'],
      unit: json['unit'],
      isActive: json['isActive'],
      isSqueakVisible: json['isSqueakVisible'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'price': price,
      'unit': unit,
      'isActive': isActive,
      'isSqueakVisible': isSqueakVisible,
    };
  }

  BoardingTypeEntity toEntity() {
    return BoardingTypeEntity(
      id: id,
      code: code,
      name: name,
      price: price,
      unit: unit,
      isActive: isActive,
      isSqueakVisible: isSqueakVisible,
    );
  }
}
