import 'package:equatable/equatable.dart';

class BoardingTypeEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final dynamic price;
  final int unit;
  final bool isActive;
  final bool isSqueakVisible;

  const BoardingTypeEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.price,
    required this.unit,
    required this.isActive,
    required this.isSqueakVisible,
  });

  @override
  List<Object?> get props => [id, code, name, price, unit, isActive, isSqueakVisible];
}
