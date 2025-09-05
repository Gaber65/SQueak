import 'package:dartz/dartz.dart';
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';

import '../../../../core/error/failure.dart';
import '../entities/data_vet.dart';
import '../entities/vet_client.dart';

abstract class BaseVetRepository {
  // Register operations
  Future<Either<Failure, List<VetClient>>> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String clientId,
    required String birthDate,
    required int gender,
    required String clinicCode,
    required int countryId,
  });

  Future<Either<Failure, LoginEntity>> login({
    required String emailOrPhone,
    required String password,
  });

  // Client operations
  Future<Either<Failure, DataVetEntity>> getClient(String invitationCode);
  Future<Either<Failure, DataVetEntity>> getClientInApp(String code, String phone);
  Future<Either<Failure, dynamic>> getClinicById(String id);

  // Pet operations
  Future<Either<Failure, List<VetClient>>> getClientsFromVet(String code, String phone, bool isFilter);
  Future<Either<Failure, String>> addInSqueakStatues({
    required String vetCarePetId,
    String? squeakPetId,
    required int statuesOfAddingPetToSqueak,
  });

  // Follow operations
  Future<Either<Failure, bool>> acceptInvitation({
    required String clinicCode,
    required String clientId,
    required String squeakUserId,
  });

  // Notification operations
  Future<Either<Failure, List<dynamic>>> getNotifications(String id);
  Future<Either<Failure, void>> updateNotificationState(String id);

}