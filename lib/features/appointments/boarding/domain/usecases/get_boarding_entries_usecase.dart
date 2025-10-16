import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

import '../entities/boarding_entry_entity.dart';

class GetBoardingEntriesUseCase implements BaseUseCase<List<BoardingEntryEntity>, GetBoardingEntriesParams> {
  final BoardingRepository repository;

  GetBoardingEntriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<BoardingEntryEntity>>> call(GetBoardingEntriesParams params) async {
    return await repository.getBoardingEntries(params.phone, params.applyFilter);
  }
}

class GetBoardingEntriesParams extends Equatable {
  final String phone;
  final bool applyFilter;

  const GetBoardingEntriesParams({
    required this.phone,
    required this.applyFilter,
  });

  @override
  List<Object?> get props => [phone, applyFilter];
}
