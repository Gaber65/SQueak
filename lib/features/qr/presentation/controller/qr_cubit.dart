import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/qr_code_entity.dart';
import '../../domain/usecases/link_pet_to_qr_usecase.dart';
import '../../domain/usecases/unlink_pet_from_qr_usecase.dart';
import '../../domain/usecases/get_qr_by_pet_usecase.dart';
import '../../domain/usecases/download_qr_usecase.dart';
import '../../domain/usecases/scan_qr_usecase.dart';
import '../../../pets/domain/entities/pet_entity.dart';

part 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  final LinkPetToQrUseCase linkPetToQrUseCase;
  final UnlinkPetFromQrUseCase unlinkPetFromQrUseCase;
  final GetQrByPetUseCase getQrByPetUseCase;
  final DownloadQrUseCase downloadQrUseCase;
  final ScanQrUseCase scanQrUseCase;
  static QrCubit get(context) => BlocProvider.of(context);
  QrCubit({
    required this.linkPetToQrUseCase,
    required this.unlinkPetFromQrUseCase,
    required this.getQrByPetUseCase,
    required this.downloadQrUseCase,
    required this.scanQrUseCase,
  }) : super(QrInitial());

  // Store QR codes for pets

  Map<String, QrCodeEntity> petQrCodes = {};

  Future<void> loadQrCodeForPet(String petId) async {
    try {
      final qrCode = await getQrByPetUseCase(petId);
      if (qrCode != null) {
        petQrCodes[petId] = qrCode;
      }
      emit(QrLoaded());
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }

  Future<void> linkPetToQr(String petId, String qrCodeId) async {
    try {
      emit(QrLoading());
      final success = await linkPetToQrUseCase(petId, qrCodeId);

      if (success) {
        // Update local cache
        petQrCodes[petId] = QrCodeEntity(
          id: qrCodeId,
          petId: petId,
          linkedAt: DateTime.now(),
        );
        emit(QrLinkSuccess('Pet successfully linked to QR code!'));
      } else {
        emit(QrError('Failed to link QR code. It may already be in use.'));
      }
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }

  Future<void> unlinkPetFromQr(String petId) async {
    try {
      emit(QrLoading());
      final success = await unlinkPetFromQrUseCase(petId);

      if (success) {
        // Remove from local cache
        petQrCodes.remove(petId);
        emit(QrUnlinkSuccess('Pet successfully unlinked from QR code!'));
      } else {
        emit(QrError('Failed to unlink QR code'));
      }
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }

  Future<void> downloadQrCode(String petId, String petName) async {
    try {
      emit(QrLoading());
      final qrCode = petQrCodes[petId];

      if (qrCode != null) {
        final success = await downloadQrUseCase(qrCode.id, petName);
        if (success) {
          emit(QrDownloadSuccess('QR code downloaded successfully!'));
        } else {
          emit(QrError('Failed to download QR code'));
        }
      } else {
        emit(QrError('No QR code found for this pet'));
      }
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }

  Future<void> scanQrCode(String qrCodeId) async {
    try {
      emit(QrLoading());
      final pet = await scanQrUseCase(qrCodeId);

      if (pet != null) {
        emit(QrScanSuccess(pet));
      } else {
        emit(QrScanEmpty('This QR code isn\'t linked to any pet yet.'));
      }
    } catch (e) {
      if (e.toString().contains('not a valid Squeak code')) {
        emit(QrScanInvalid('This QR code is not a valid Squeak code.'));
      } else {
        emit(QrError(e.toString()));
      }
    }
  }

  bool isPetLinkedToQr(String petId) {
    return petQrCodes.containsKey(petId) && petQrCodes[petId]!.isLinked;
  }

  QrCodeEntity? getQrCodeForPet(String petId) {
    return petQrCodes[petId];
  }
}
