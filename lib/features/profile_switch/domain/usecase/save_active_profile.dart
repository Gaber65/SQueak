import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/features/profile_switch/domain/entities/profile_type_entity.dart';

import '../../../../core/base_usecase/base_usecase.dart';
import '../repositories/profile_type_base_repo.dart';



class SaveActiveProfileUseCase extends BaseUseCase<bool, ActiveProfile> {
  final ProfileSwitchRepository repository;

  SaveActiveProfileUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ActiveProfile parameters) {
    return repository.saveActiveProfile(parameters);
  }
}
