import 'package:dartz/dartz.dart';

import '../../../../core/base_usecase/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../base_repo/profile_repository.dart';
import '../entities/owner_entite.dart';

class GetOwnerDataUseCase extends BaseUseCase<Owner, NoParameters> {
  final ProfileRepository repository;

  GetOwnerDataUseCase(this.repository);

  @override
  Future<Either<Failure, Owner>> call(NoParameters parameters) async {
    return await repository.getOwnerData();
  }
}
