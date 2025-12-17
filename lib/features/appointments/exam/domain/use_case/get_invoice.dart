import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:squeak/features/appointments/exam/domain/entities/invoice.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class GetInvoiceUseCase implements BaseUseCase<Invoice, GetInvoiceParams> {
  final AppointmentRepository repository;

  GetInvoiceUseCase(this.repository);

  @override
  Future<Either<Failure, Invoice>> call(GetInvoiceParams params) async {
    return await repository.getInvoice(params.id);
  }
}

class GetInvoiceParams extends Equatable {
  final String id;

  const GetInvoiceParams({required this.id});

  @override
  List<Object?> get props => [id];
}
