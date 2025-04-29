import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base_usecase/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../base_repo/base_vet_repository.dart';
import '../entities/vet_client.dart';

class GetClientsFromVetUseCase extends BaseUseCase<List<VetClient>, GetClientsParams> {
  final BaseVetRepository repository;

  GetClientsFromVetUseCase(this.repository);

  @override
  Future<Either<Failure, List<VetClient>>> call(GetClientsParams params) async {
    return await repository.getClientsFromVet(
      params.code,
      params.phone,
      params.isFilter,
    );
  }
}

class GetClientsParams extends Equatable {
  final String code;
  final String phone;
  final bool isFilter;

  const GetClientsParams({
    required this.code,
    required this.phone,
    required this.isFilter,
  });

  @override
  List<Object> get props => [code, phone, isFilter];
}

class AddInSqueakStatusUseCase extends BaseUseCase<String, AddInSqueakParams> {
  final BaseVetRepository repository;

  AddInSqueakStatusUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(AddInSqueakParams params) async {
    return await repository.addInSqueakStatues(
      vetCarePetId: params.vetCarePetId,
      squeakPetId: params.squeakPetId,
      statuesOfAddingPetToSqueak: params.statuesOfAddingPetToSqueak,
    );
  }
}

class AddInSqueakParams extends Equatable {
  final String vetCarePetId;
  final String? squeakPetId;
  final int statuesOfAddingPetToSqueak;

  const AddInSqueakParams({
    required this.vetCarePetId,
    this.squeakPetId,
    required this.statuesOfAddingPetToSqueak,
  });

  @override
  List<Object?> get props => [vetCarePetId, squeakPetId, statuesOfAddingPetToSqueak];
}