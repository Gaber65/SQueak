import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

import '../entities/boarding_type_entity.dart';

class GetBoardingTypesUseCase implements BaseUseCase<List<BoardingTypeEntity>, String> {
  final BoardingRepository repository;

  GetBoardingTypesUseCase(this.repository);

  @override
  Future<Either<Failure, List<BoardingTypeEntity>>> call(String clinicCode) async {
    return await repository.getBoardingTypes(clinicCode);
  }
}
