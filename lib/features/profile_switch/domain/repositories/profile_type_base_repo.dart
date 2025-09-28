// domain/repositories/profile_repository.dart
import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/features/profile_switch/domain/entities/profile_type_entity.dart';

abstract class ProfileSwitchRepository {
  Future<Either<Failure, ActiveProfile>> getActiveProfile();
  Future<Either<Failure, bool>> saveActiveProfile(ActiveProfile profile);
}