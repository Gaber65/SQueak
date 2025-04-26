import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../entities/clinic_search_entity.dart';
import '../repository/base_search_repository.dart' show BaseSearchRepository;

class GetSearchListUseCase
    extends BaseUseCase<List<ClinicEntitySearch>, String> {
  final BaseSearchRepository baseSearchRepository;

  GetSearchListUseCase(this.baseSearchRepository);

  @override
  Future<Either<Failure, List<ClinicEntitySearch>>> call(
    String clinicCode,
  ) async {
    return await baseSearchRepository.getSearchList(clinicCode);
  }
}
