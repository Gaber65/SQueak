import 'package:equatable/equatable.dart';

class PetBoardingEntity extends Equatable {
  final String name;

  const PetBoardingEntity({required this.name});

  @override
  List<Object?> get props => [name];
}
