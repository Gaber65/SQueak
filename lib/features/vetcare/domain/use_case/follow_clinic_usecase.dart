import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../base_repo/qr_base_repo.dart';

class FollowQRClinicUseCase implements BaseUseCase<bool, FollowClinicParams> {
  final QRRepository repository;

  FollowQRClinicUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(FollowClinicParams params) async {
    return await repository.followClinic(params);
  }
}
