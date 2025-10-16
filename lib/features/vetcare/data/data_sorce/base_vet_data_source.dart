
import 'package:squeak/features/auth/login/data/models/login_data_model.dart';

import '../models/data_vet_model.dart';
import '../models/vet_client_model.dart';

abstract class BaseVetRemoteDataSource {
  // Register operations
  Future<List<VetClientModel>> register({
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

  Future<LoginData> login({
    required String emailOrPhone,
    required String password,
  });

  // Client operations
  Future<DataVetModel> getClient(String invitationCode);
  Future<DataVetModel> getClientInApp(String code, String phone);
  Future<dynamic> getClinicById(String id);

  // Pet operations
  Future<List<VetClientModel>> getClientsFromVet(String code, String phone, bool isFilter);
  Future<String> addInSqueakStatues({
    required String vetCarePetId,
    String? squeakPetId,
    required int statuesOfAddingPetToSqueak,
  });

  // Follow operations
  Future<bool> acceptInvitation({
    required String clinicCode,
    required String clientId,
    required String squeakUserId,
  });

  // Notification operations
  Future<List<dynamic>> getNotifications(String id);
  Future<void> updateNotificationState(String id);

}