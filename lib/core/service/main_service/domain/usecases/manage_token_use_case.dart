import '../repositories/app_repository.dart';

class ManageTokenUseCase {
  final AppRepository repository;

  ManageTokenUseCase(this.repository);

  Future<void> deleteToken() async {
    await repository.deleteToken();
  }

  Future<void> saveToken() async {
    await repository.saveToken();
  }

  Future<void> removeToken() async {
    await repository.removeToken();
  }

  Future<void> requestNotificationPermissions() async {
    await repository.requestNotificationPermissions();
  }
}
