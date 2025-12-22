import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/error_message_model.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/base_repo/profile_repository.dart';
import '../../domain/entities/owner_entite.dart';
import '../data_source/profile_local_data_source.dart';
import '../data_source/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Owner>> getOwnerData() async {
    try {
      final remoteOwner = await remoteDataSource.getOwnerData();
      await localDataSource.cacheCountryId(remoteOwner.countryId);
      return Right(remoteOwner);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    } catch (_) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Owner>> updateProfile({
    required String fullName,
    required String address,
    required String imageName,
    required String birthDate,
    required int? gender,
  }) async {
    try {
      final updatedOwner = await remoteDataSource.updateProfile(
        fullName: fullName,
        address: address,
        imageName: imageName,
        birthDate: birthDate,
        gender: gender,
      );
      return Right(updatedOwner);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    } catch (_) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }
}
