import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  const ImageEntity({required this.data});
  final String data;

  @override
  List<Object?> get props => [data];
}
