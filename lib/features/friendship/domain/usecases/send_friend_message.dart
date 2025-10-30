import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/send_friend_message_parameters.dart';

class SendFriendMessageUseCase extends BaseUseCase<Map<String, dynamic>, SendFriendPetMessageParameters> {
  final PetFriendRepository repository;

  SendFriendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(SendFriendPetMessageParameters parameters) async {
    return await repository.sendFriendMessage(parameters);
  }
}
