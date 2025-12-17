import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../entities/clinic_search_entity.dart';
import '../repository/base_search_repository.dart';

class GetSupplierUseCase
    extends BaseUseCase<SupplierEntitySearch, NoParameters> {
  final BaseSearchRepository baseSearchRepository;

  GetSupplierUseCase(this.baseSearchRepository);

  @override
  Future<Either<Failure, SupplierEntitySearch>> call(
    NoParameters parameters,
  ) async {
    return await baseSearchRepository.getSupplier();
  }
}
