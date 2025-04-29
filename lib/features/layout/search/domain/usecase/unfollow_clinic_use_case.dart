import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../entities/clinic_search_entity.dart';
import '../repository/base_search_repository.dart';

class UnfollowClinicUseCase extends BaseUseCase<ClinicEntitySearch, String> {
  final BaseSearchRepository baseSearchRepository;

  UnfollowClinicUseCase(this.baseSearchRepository);

  @override
  Future<Either<Failure, ClinicEntitySearch>> call(String clinicId) async {
    return await baseSearchRepository.unfollowClinic(clinicId);
  }
}
