import 'package:dartz/dartz.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/features/mating/matingRequest/domain/entities/mating_request_entity.dart';

import '../../../../../core/error/failure.dart';
import '../repo/mating_request_repository.dart';

class GetSentRequestsMatingUseCase
    implements BaseUseCase<List<MatingRequestEntity>, String> {
  final MatingRequestRepository repository;

  GetSentRequestsMatingUseCase(this.repository);

  @override
  Future<Either<Failure, List<MatingRequestEntity>>> call(String petId) async {
    return await repository.getMatingSent(petId);
  }
}
