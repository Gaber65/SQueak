import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../entities/vet_client_search_entity.dart';
import '../repository/base_search_repository.dart';

class GetClientFormVetUseCase
    extends BaseUseCase<List<VetSearchClientEntity>, String> {
  final BaseSearchRepository baseSearchRepository;

  GetClientFormVetUseCase(this.baseSearchRepository);

  @override
  Future<Either<Failure, List<VetSearchClientEntity>>> call(
    String clinicCode,
  ) async {
    return await baseSearchRepository.getClintFormVetVoid(clinicCode);
  }
}
