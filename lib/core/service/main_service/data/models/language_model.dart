import '../../domain/entities/language_entity.dart';

class LanguageModel extends LanguageEntity {
  const LanguageModel({required super.language});

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      LanguageModel(language: json['language']);
}
