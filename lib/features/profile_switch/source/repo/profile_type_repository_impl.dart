import 'package:dartz/dartz.dart';
import 'package:squeak/core/network/error_message_model.dart';
import 'package:squeak/features/profile_switch/domain/repositories/profile_type_base_repo.dart';
import 'package:squeak/features/profile_switch/source/data/profile_local_data_source.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/profile_type_entity.dart';

class ProfileSwitchRepositoryImpl implements ProfileSwitchRepository {
  final ProfileSwitchLocalDataSource localDataSource;

  ProfileSwitchRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, ActiveProfile>> getActiveProfile() async {
    try {
      final profile = await localDataSource.getCachedProfile();
      if (profile == null) {
        return Left(
          LocalDatabaseFailure(
            ErrorMessageModel(
              errors: {
                "profile": ["No cached profile found"],
              },
              message: "No active profile is stored locally.",
              success: false,
              statusCode: 404,
            ),
          ),
        );
      }
      return Right(profile);
    } on LocalDatabaseFailure catch (failure) {
      return Left(LocalDatabaseFailure(failure.error));
    }
  }

  @override
  Future<Either<Failure, bool>> saveActiveProfile(ActiveProfile profile) async {
    try {
      await localDataSource.cacheProfile(profile);
      return const Right(true);
    } on LocalDatabaseFailure catch (failure) {
      return Left(LocalDatabaseFailure(failure.error));
    }
  }
}
