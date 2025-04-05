import 'package:equatable/equatable.dart';

class LanguageEntity extends Equatable {
  final int language;

  const LanguageEntity({required this.language});

  @override
  List<Object?> get props => [language];
}
