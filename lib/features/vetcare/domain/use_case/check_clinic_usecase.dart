import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../base_repo/qr_base_repo.dart';

class CheckClinicInSupplierUseCase
    implements BaseUseCase<bool, CheckClinicParams> {
  final QRRepository repository;

  CheckClinicInSupplierUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckClinicParams params) async {
    return await repository.checkClinicInSupplier(params);
  }
}
