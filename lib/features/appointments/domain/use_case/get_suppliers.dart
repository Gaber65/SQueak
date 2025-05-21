import 'package:dartz/dartz.dart';
import 'package:squeak/features/appointments/domain/entities/clinic_entity.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';


class GetSuppliersUseCase implements BaseUseCase<MySupplier, NoParameters> {
  final AppointmentRepository repository;

  GetSuppliersUseCase(this.repository);

  @override
  Future<Either<Failure, MySupplier>> call(NoParameters params) async {
    return await repository.getSuppliers();
  }
}