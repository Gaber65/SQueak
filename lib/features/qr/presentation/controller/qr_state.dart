part of 'qr_cubit.dart';

abstract class QrState {}

class QrInitial extends QrState {}

class QrLoading extends QrState {}

class QrLoaded extends QrState {}

class QrLinkSuccess extends QrState {
  final String message;
  QrLinkSuccess(this.message);
}

class QrUnlinkSuccess extends QrState {
  final String message;
  QrUnlinkSuccess(this.message);
}

class QrDownloadSuccess extends QrState {
  final String message;
  QrDownloadSuccess(this.message);
}

class QrScanSuccess extends QrState {
  final PetEntities pet;
  QrScanSuccess(this.pet);
}

class QrScanEmpty extends QrState {
  final String message;
  QrScanEmpty(this.message);
}

class QrScanInvalid extends QrState {
  final String message;
  QrScanInvalid(this.message);
}

class QrError extends QrState {
  final String message;
  QrError(this.message);
}
