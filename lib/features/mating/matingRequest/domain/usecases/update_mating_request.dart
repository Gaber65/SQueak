import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class UpdateMatingRequestUseCase
    implements BaseUseCase<String, UpdateRequestStatusParams> {
  final MatingRequestRepository repository;

  UpdateMatingRequestUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(UpdateRequestStatusParams params) async {
    return await repository.updateRequestStatus(params);
  }
}
