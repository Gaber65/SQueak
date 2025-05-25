import 'package:dartz/dartz.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';



class GetSuppliersUseCase implements BaseUseCase<MySupplier, NoParameters> {
  final AppointmentRepository repository;

  GetSuppliersUseCase(this.repository);

  @override
  Future<Either<Failure, MySupplier>> call(NoParameters params) async {
    return await repository.getSuppliers();
  }
}