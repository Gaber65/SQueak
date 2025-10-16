// import 'package:dartz/dartz.dart';
//
// import '../../../../../core/service/service_locator/locatore_export_path.dart';
// import '../../domain/entities/mating_request_entity.dart';
// import '../../domain/entities/pet_mating_entity.dart';
// import '../../domain/repositories/pet_mating_repository.dart';
// import '../../domain/usecases/mating_parameters.dart';
// import '../datasources/pet_mating_remote_data_source.dart';
//
// class PetMatingRepositoryImpl implements BasePetMatingRepository {
//   final PetMatingRemoteDataSource remoteDataSource;
//
//   PetMatingRepositoryImpl({
//     required this.remoteDataSource,
//   });
//
//   @override
//   Future<Either<Failure, List<PetMatingEntity>>> getAvailablePets() async {
//     try {
//       final pets = await remoteDataSource.getAvailablePets();
//       return Right(pets);
//     }  on ServerException catch (failure) {
//       return Left(ServerFailure(failure.errorMessageModel));
//     }
//   }
//
//   @override
//   Future<Either<Failure, List<PetMatingEntity>>> getPetsByStatus(PetMatingStatus status) async {
//     try {
//       final pets = await remoteDataSource.getPetsByStatus(status.index);
//       return Right(pets);
//     }  on ServerException catch (failure) {
//       return Left(ServerFailure(failure.errorMessageModel));
//     }
//   }
//
//   @override
//   Future<Either<Failure, MatingRequestEntity>> sendMatingRequest(
//       SendMatingRequestParameters parameters) async {
//     try {
//       final request = await remoteDataSource.sendMatingRequest(
//         parameters.petId,
//         parameters.message,
//       );
//       return Right(request);
//     }  on ServerException catch (failure) {
//       return Left(ServerFailure(failure.errorMessageModel));
//     }
//   }
//
//   @override
//   Future<Either<Failure, PetMatingEntity>> getPetProfile(String petId) async {
//     try {
//       final pet = await remoteDataSource.getPetProfile(petId);
//       return Right(pet);
//     }  on ServerException catch (failure) {
//       return Left(ServerFailure(failure.errorMessageModel));
//     }
//   }
//
//   @override
//   Future<Either<Failure, void>> updatePetStatus(UpdatePetStatusParameters parameters) async {
//     try {
//       await remoteDataSource.updatePetStatus(parameters.petId, parameters.status.index);
//       return const Right(null);
//     }  on ServerException catch (failure) {
//       return Left(ServerFailure(failure.errorMessageModel));
//     }
//   }
// }
