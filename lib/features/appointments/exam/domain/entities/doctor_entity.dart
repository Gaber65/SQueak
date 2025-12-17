import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String id;
  final String name;
  final String image;

  const Doctor({required this.id, required this.name, required this.image});

  @override
  List<Object?> get props => [id, name, image];
}
