import 'package:equatable/equatable.dart';

class CageEntity extends Equatable {
  final String name;
  final String description;

  const CageEntity({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}
