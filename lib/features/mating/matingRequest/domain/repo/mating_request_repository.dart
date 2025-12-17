import 'package:dartz/dartz.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/matingRequest/domain/entities/mating_request_entity.dart';

abstract class MatingRequestRepository {
  Future<Either<Failure, List<MatingRequestEntity>>> getMatingRequests(
    String petId,
  );
  Future<Either<Failure, List<MatingRequestEntity>>> getMatingSent(
    String petId,
  );
  Future<Either<Failure, String>> updateRequestStatus(
    UpdateRequestStatusParams params,
  );
}

class UpdateRequestStatusParams {
  final String matingRequestId;
  final RequestStatus status;

  UpdateRequestStatusParams({
    required this.matingRequestId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {'matingRequestId': matingRequestId, 'statues': status.index};
  }
}
