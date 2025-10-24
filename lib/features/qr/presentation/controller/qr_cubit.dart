import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

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
  bool isLoading = false;
  Future<void> linkPetToQr(String petId, String qrCodeId) async {
    isLoading = true;
    emit(QrLoading());
    final success = await linkPetToQrUseCase(
      LinkPetToQrParams(petId: petId, qrCodeId: qrCodeId),
    );
    success.fold(
      (failure) {
        isLoading = false;
        emit(QrError(extractFirstError(failure)));
      },
      (success) {
        isLoading = false;
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

  Future<void> unlinkPetFromQr(String petId, String qrCodeId) async {
    emit(QrLoading());
    final success = await unlinkPetFromQrUseCase(
      LinkPetToQrParams(petId: petId, qrCodeId: qrCodeId),
    );
    success.fold(
      (failure) {
        emit(QrError(extractFirstError(failure)));
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
