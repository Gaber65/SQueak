part of 'qr_cubit.dart';

abstract class QrState {}

class QrInitial extends QrState {}

class QrLoading extends QrState {}

class QrLinkSuccess extends QrState {}

class QrUnlinkSuccess extends QrState {}

class QrScanSuccess extends QrState {
  final PetEntities pet;
  QrScanSuccess(this.pet);
}

class QrScanEmpty extends QrState {}

class QrError extends QrState {
  final String message;
  QrError(this.message);
}
