import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class EditBoardingUseCase implements BaseUseCase<void, EditBoardingParams> {
  final BoardingRepository repository;

  EditBoardingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(EditBoardingParams params) async {
    return await repository.editBoarding(params);
  }
}
