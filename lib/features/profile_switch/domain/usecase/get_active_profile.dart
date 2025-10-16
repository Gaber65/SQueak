import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/features/profile_switch/domain/entities/profile_type_entity.dart';

import '../../../../core/base_usecase/base_usecase.dart';
import '../repositories/profile_type_base_repo.dart';

class GetActiveProfileUseCase extends BaseUseCase<ActiveProfile, NoParameters> {
  final ProfileSwitchRepository repository;

  GetActiveProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ActiveProfile>> call(NoParameters parameters) {
    return repository.getActiveProfile();
  }
}
