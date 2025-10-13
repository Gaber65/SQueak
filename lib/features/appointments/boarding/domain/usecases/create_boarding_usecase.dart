import 'package:dartz/dartz.dart';

import '../../../../../core/service/service_locator/locatore_export_path.dart';

class CreateBoardingUseCase implements BaseUseCase<void, CreateBoardingParams> {
  final BoardingRepository repository;

  CreateBoardingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateBoardingParams params) async {
    return await repository.createBoarding(params);
  }
}
