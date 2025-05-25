import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../repositories/boarding_repository.dart';

class RateBoardingUseCase implements BaseUseCase<void, RateBoardingParams> {
  final BoardingRepository repository;

  RateBoardingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RateBoardingParams params) async {
    return await repository.rateBoarding(params);
  }
}
