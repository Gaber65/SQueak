import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/vetcare/domain/entities/vet_client.dart';

import '../base_repo/qr_base_repo.dart';

class GetVetClientsUseCase
    implements BaseUseCase<List<VetClient>, GetVetClientsParams> {
  final QRRepository repository;

  GetVetClientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<VetClient>>> call(
    GetVetClientsParams params,
  ) async {
    return await repository.getVetClients(params);
  }
}
