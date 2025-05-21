import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:squeak/features/appointments/domain/entities/invoice.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';

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