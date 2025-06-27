import 'package:dartz/dartz.dart';

import 'package:squeak/core/error/failure.dart';

import '../../../../core/base_usecase/base_usecase.dart';
import '../repositories/qr_repository.dart';

class LinkPetToQrUseCase extends BaseUseCase<bool, LinkPetToQrParams> {
  final QrRepository repository;

  LinkPetToQrUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(LinkPetToQrParams params) async {
    return await repository.linkPetToQr(params.petId, params.qrCodeId);
  }
}

class LinkPetToQrParams {
  final String petId;
  final String qrCodeId;

  LinkPetToQrParams({required this.petId, required this.qrCodeId});
}
