// presentation/cubit/main_cubit.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/enums/upload_place.dart';

import '../../../../cache/shared_preferences/cache_helper.dart';
import '../../../domain/entities/language_entity.dart';
import '../../../domain/repositories/app_repository.dart';
import '../../../domain/usecases/change_language_use_case.dart';
import '../../../domain/usecases/manage_token_use_case.dart';
import '../../../domain/usecases/mange_upload_image_use_case.dart';
import '../../../domain/usecases/mange_upload_sound_use_case.dart';
import '../../../domain/usecases/mange_upload_video_use_case.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final ChangeLanguageUseCase changeLanguageUseCase;
  final ManageTokenUseCase manageTokenUseCase;
  final ManageUploadImageUseCase manageUploadUseCase;
  final ManageUploadVideoUseCase manageUploadVideoUseCase;
  final ManageUploadSoundUseCase manageUploadSoundUseCase;

  MainCubit(
    this.changeLanguageUseCase,
    this.manageTokenUseCase,
    this.manageUploadUseCase,
    this.manageUploadVideoUseCase,
    this.manageUploadSoundUseCase,
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
      print(isDark);
      print(CacheHelper.getData('isDark'));
      emit(AppChangeModeState());
    }
  }

  // Token methods
  Future<void> deleteToken() async {
    emit(DeleteTokenLoading());
    try {
      await manageTokenUseCase.deleteToken();
      emit(DeleteTokenSuccess());
    } catch (e) {
      emit(DeleteTokenError());
    }
  }

  // Change language method
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

  Future<void> removeToken() async {
    emit(SaveTokenLoading());
    try {
      await manageTokenUseCase.removeToken();
      emit(SaveTokenSuccess());
    } catch (e) {
      emit(SaveTokenError());
    }
  }

  Future<void> requestNotificationPermissions() async {
    emit(RequestNotificationPermissionsLoading());
    try {
      await manageTokenUseCase.requestNotificationPermissions();
      emit(RequestNotificationPermissionsSuccess());
    } catch (e) {
      emit(RequestNotificationPermissionsError());
    }
  }

  // File Upload methods
  Future<void> getGlobalImage(File file, UploadPlace uploadPlace) async {
    emit(ImageHelperLoading());
    final result = await manageUploadUseCase(
      UploadImageParams(file: file, uploadPlace: uploadPlace),
    );
    result.fold(
      (l) => emit(ImageHelperError()),
      (r) => emit(ImageHelperSuccess()),
    );
  }

  Future<void> getGlobalVideo(File file, UploadPlace uploadPlace) async {
    emit(VideoHelperLoading());
    final result = await manageUploadVideoUseCase(
      UploadImageParams(file: file, uploadPlace: uploadPlace),
    );
    result.fold(
      (l) => emit(VideoHelperError()),
      (r) => emit(VideoHelperSuccess()),
    );
  }

  Future<void> getGlobalSound(File file, UploadPlace uploadPlace) async {
    emit(SoundHelperLoading());
    final result = await manageUploadSoundUseCase(
      UploadImageParams(file: file, uploadPlace: uploadPlace),
    );
    result.fold(
      (l) => emit(SoundHelperError()),
      (r) => emit(SoundHelperSuccess()),
    );
  }
}
