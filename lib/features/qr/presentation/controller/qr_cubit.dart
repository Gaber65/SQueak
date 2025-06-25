import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/link_qr_usecase.dart';
import '../../domain/usecases/unlink_qr_usecase.dart';
import '../../domain/usecases/scan_qr_usecase.dart';
import '../../../pets/domain/entities/pet_entity.dart';

part 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  final LinkQrUseCase linkQrUseCase;
  final UnlinkQrUseCase unlinkQrUseCase;
  final ScanQrUseCase scanQrUseCase;

  QrCubit({
    required this.linkQrUseCase,
    required this.unlinkQrUseCase,
    required this.scanQrUseCase,
  }) : super(QrInitial());

  Future<void> linkQr(String petId, String qrCodeId) async {
    try {
      emit(QrLoading());
      final success = await linkQrUseCase(petId, qrCodeId);
      if (success) {
        emit(QrLinkSuccess());
      } else {
        emit(QrError('Failed to link QR code. It may already be in use.'));
      }
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }

  Future<void> unlinkQr(String petId) async {
    try {
      emit(QrLoading());
      final success = await unlinkQrUseCase(petId);
      if (success) {
        emit(QrUnlinkSuccess());
      } else {
        emit(QrError('Failed to unlink QR code'));
      }
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }

  Future<void> scanQr(String qrCodeId) async {
    try {
      emit(QrLoading());
      final pet = await scanQrUseCase(qrCodeId);
      if (pet != null) {
        emit(QrScanSuccess(pet));
      } else {
        emit(QrScanEmpty());
      }
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }
}
