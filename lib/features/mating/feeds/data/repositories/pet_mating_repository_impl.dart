import 'package:dartz/dartz.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/usecases/mating_parameters.dart';

class PetMatingRepositoryImpl implements BasePetMatingRepository {
  final PetMatingRemoteDataSource remoteDataSource;

  PetMatingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PetEntities>>> getAvailablePets(
    String specieId,
  ) async {
    try {
      final pets = await remoteDataSource.getAvailablePets(specieId);
      return Right(pets);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, String>> sendMatingRequest(
    SendMatingRequestParameters parameters,
  ) async {
    try {
      final request = await remoteDataSource.sendMatingRequest(parameters);
      return Right(request);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, void>> updateSentRequestStatus(
    SendMatingRequestParameters parameters,
  ) async {
    try {
      await remoteDataSource.updateSentRequestStatus(parameters);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
