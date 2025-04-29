import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base_usecase/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../base_repo/base_vet_repository.dart';

class AcceptInvitationUseCase extends BaseUseCase<bool, AcceptInvitationParams> {
  final BaseVetRepository repository;

  AcceptInvitationUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(AcceptInvitationParams params) async {
    return await repository.acceptInvitation(
      clinicCode: params.clinicCode,
      clientId: params.clientId,
      squeakUserId: params.squeakUserId,
    );
  }
}

class AcceptInvitationParams extends Equatable {
  final String clinicCode;
  final String clientId;
  final String squeakUserId;

  const AcceptInvitationParams({
    required this.clinicCode,
    required this.clientId,
    required this.squeakUserId,
  });

  @override
  List<Object> get props => [clinicCode, clientId, squeakUserId];
}

class GetNotificationsUseCase extends BaseUseCase<List<dynamic>, String> {
  final BaseVetRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(String id) async {
    return await repository.getNotifications(id);
  }
}

class UpdateNotificationToVetStateUseCase extends BaseUseCase<void, String> {
  final BaseVetRepository repository;

  UpdateNotificationToVetStateUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.updateNotificationState(id);
  }
}