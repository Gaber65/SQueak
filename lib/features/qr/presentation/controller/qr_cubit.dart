import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../../domain/usecases/link_pet_to_qr_usecase.dart';
import '../../domain/usecases/unlink_pet_from_qr_usecase.dart';

import '../../../pets/domain/entities/pet_entity.dart';

part 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  final LinkPetToQrUseCase linkPetToQrUseCase;
  final UnlinkPetFromQrUseCase unlinkPetFromQrUseCase;

  static QrCubit get(context) => BlocProvider.of(context);
  QrCubit({
    required this.linkPetToQrUseCase,
    required this.unlinkPetFromQrUseCase,
  }) : super(QrInitial());

  // Store QR codes for pets

  Future<void> linkPetToQr(String petId, String qrCodeId) async {
    emit(QrLoading());
    final success = await linkPetToQrUseCase(
      LinkPetToQrParams(petId: petId, qrCodeId: qrCodeId),
    );
    success.fold(
      (failure) {
        emit(QrError(failure.error.message));
      },
      (success) {
        emit(
          QrLinkSuccess(
            isArabic()
                ? 'تم ربط اليفك برمز القراءة بنجاح'
                : 'Pet successfully linked to QR code!',
          ),
        );
      },
    );
  }

  Future<void> unlinkPetFromQr(String petId) async {
    emit(QrLoading());
    final success = await unlinkPetFromQrUseCase(petId);
    success.fold(
      (failure) {
        emit(QrError(failure.error.message));
      },
      (success) {
        emit(
          QrUnlinkSuccess(
            isArabic()
                ? 'تم فصل اليفك من رمز القراءة بنجاح'
                : 'Pet successfully unlinked from QR code!',
          ),
        );
      },
    );
  }
}
