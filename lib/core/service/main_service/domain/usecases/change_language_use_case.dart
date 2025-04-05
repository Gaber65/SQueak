import '../entities/language_entity.dart';
import '../repositories/app_repository.dart';

class ChangeLanguageUseCase {
  final AppRepository repository;

  ChangeLanguageUseCase(this.repository);

  Future<void> execute(LanguageEntity languageEntity) async {
    await repository.changeLanguage(languageEntity);
  }
}
