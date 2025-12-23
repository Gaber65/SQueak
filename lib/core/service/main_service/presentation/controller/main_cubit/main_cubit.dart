import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/enums/upload_place.dart';
import 'package:video_compress/video_compress.dart';
import '../../../../cache/shared_preferences/cache_helper.dart';
import '../../../domain/entities/image_entity.dart';
import '../../../domain/entities/language_entity.dart';
import '../../../domain/repositories/app_repository.dart';
import '../../../domain/usecases/change_language_use_case.dart';
import '../../../domain/usecases/manage_token_use_case.dart';
import '../../../domain/usecases/mange_upload_image_use_case.dart';
import '../../../domain/usecases/mange_upload_sound_use_case.dart';
import '../../../domain/usecases/mange_upload_video_use_case.dart';
import '../../../domain/usecases/mange_upload_document_use_case.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final ChangeLanguageUseCase changeLanguageUseCase;
  final ManageTokenUseCase manageTokenUseCase;
  final ManageUploadImageUseCase manageUploadUseCase;
  final ManageUploadVideoUseCase manageUploadVideoUseCase;
  final ManageUploadSoundUseCase manageUploadSoundUseCase;
  final ManageUploadDocumentUseCase manageUploadDocumentUseCase;

  MainCubit(
    this.changeLanguageUseCase,
    this.manageTokenUseCase,
    this.manageUploadUseCase,
    this.manageUploadVideoUseCase,
    this.manageUploadSoundUseCase,
    this.manageUploadDocumentUseCase,
  ) : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);
  String? language;

  void changeAppLang({String? fromSharedLang, String? langMode}) {
    if (fromSharedLang != null) {
      language = fromSharedLang;

      setLangInAPI(fromSharedLang == 'ar' ? 1 : 0);
      emit(AppChangeModeState());
    } else {
      language = langMode;
      setLangInAPI(language == 'ar' ? 1 : 0);

      CacheHelper.saveData('language', langMode!).then((value) {
        emit(AppChangeModeState());
      });
    }
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeFromSharedState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData('isDark', isDark);
      emit(AppChangeModeState());
    }
  }

  void setLangInAPI(int langMode) async {
    emit(AppChangeModeState());
    final languageEntity = LanguageEntity(language: langMode);
    try {
      await changeLanguageUseCase.execute(languageEntity);
      emit(AppChangeModeState());
    } catch (e) {
      emit(AppChangeModeError());
    }
  }

  Future<void> saveToken() async {
    emit(SaveTokenLoading());
    try {
      await manageTokenUseCase.saveToken();
      emit(SaveTokenSuccess());
    } catch (e) {
      emit(SaveTokenError());
    }
  }

  void resetState() {
    isNotificationEnabled = false;
    emit(MainInitial());
  }

  bool isNotificationEnabled = false;
  Future<void> requestNotificationPermissions() async {
    emit(RequestNotificationPermissionsLoading());
    try {
      isNotificationEnabled = true;
      await manageTokenUseCase.requestNotificationPermissions();
      emit(RequestNotificationPermissionsSuccess());
    } catch (e) {
      isNotificationEnabled = false;
      emit(RequestNotificationPermissionsError());
    }
  }

  Future<void> deleteToken() async {
    emit(DeleteTokenLoading());
    try {
      isNotificationEnabled = false;
      await manageTokenUseCase.deleteToken();
      emit(DeleteTokenSuccess());
    } catch (e) {
      isNotificationEnabled = true;
      emit(DeleteTokenError());
    }
  }

  Future<void> removeToken() async {
    emit(SaveTokenLoading());
    try {
      await manageTokenUseCase.removeToken();
      emit(SaveTokenSuccess());
    } catch (e) {
      emit(SaveTokenError());
    }
  }

  ImageEntity? modelImage;
  Future<void> getGlobalImage(File file, UploadPlace uploadPlace) async {
    emit(ImageHelperLoading());
    final result = await manageUploadUseCase(
      UploadImageParams(file: file, uploadPlace: uploadPlace),
    );
    result.fold((l) => emit(ImageHelperError()), (r) {
      emit(ImageHelperSuccess());
      modelImage = r;
    });
  }

  Future<File?> convertToMp4(File file) async {
    print('*****************');
    try {
      final info = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      return info?.file;
    } catch (e) {
      print(e.toString());
      print('***************');
      return null;
    }
  }

  Future<void> getGlobalVideo(File file, UploadPlace uploadPlace) async {
    emit(VideoHelperLoading());

    File uploadFile = file;

    if (uploadPlace != UploadPlace.messageVideo) {
      final convertedFile = await convertToMp4(file);

      if (convertedFile == null) {
        emit(VideoHelperError());
        return;
      }

      uploadFile = convertedFile;
    }

    final result = await manageUploadVideoUseCase(
      UploadImageParams(file: uploadFile, uploadPlace: uploadPlace),
    );

    result.fold((l) => emit(VideoHelperError()), (r) {
      modelImage = r;
      emit(VideoHelperSuccess());
    });
  }

  Future<void> getGlobalSound(File file, UploadPlace uploadPlace) async {
    emit(SoundHelperLoading());
    final result = await manageUploadSoundUseCase(
      UploadImageParams(file: file, uploadPlace: uploadPlace),
    );
    result.fold((l) => emit(SoundHelperError()), (r) {
      emit(SoundHelperSuccess());
      modelImage = r;
    });
  }

  Future<void> getGlobalDocument(File file, UploadPlace uploadPlace) async {
    emit(DocumentHelperLoading());
    final result = await manageUploadDocumentUseCase(
      UploadImageParams(file: file, uploadPlace: uploadPlace),
    );
    result.fold((l) => emit(DocumentHelperError()), (r) {
      emit(DocumentHelperSuccess());
      modelImage = r;
    });
  }
}
