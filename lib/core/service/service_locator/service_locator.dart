import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:squeak/core/network/dio.dart';

import '../main_service/data/datasources/remote_data_source.dart';
import '../main_service/data/repositories/app_repository_impl.dart';
import '../main_service/domain/repositories/app_repository.dart';
import '../main_service/domain/usecases/change_language_use_case.dart';
import '../main_service/domain/usecases/manage_token_use_case.dart';
import '../main_service/domain/usecases/mange_upload_image_use_case.dart';
import '../main_service/domain/usecases/mange_upload_sound_use_case.dart';
import '../main_service/domain/usecases/mange_upload_video_use_case.dart';
import '../main_service/presentation/controller/main_cubit/main_cubit.dart';

final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    // Register Data sources
    sl.registerLazySingleton<MainRemoteDataSource>(
      () => MainRemoteDataSource(),
    );
    // Register Repositories
    sl.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(sl()));
    // Register Use Cases
    sl.registerLazySingleton<ChangeLanguageUseCase>(
      () => ChangeLanguageUseCase(sl()),
    );
    sl.registerLazySingleton<ManageTokenUseCase>(
      () => ManageTokenUseCase(sl()),
    );
    sl.registerLazySingleton<ManageUploadImageUseCase>(
      () => ManageUploadImageUseCase(sl()),
    );
    sl.registerLazySingleton<ManageUploadVideoUseCase>(
      () => ManageUploadVideoUseCase(sl()),
    );
    sl.registerLazySingleton<ManageUploadSoundUseCase>(
      () => ManageUploadSoundUseCase(sl()),
    );

    // Register Cubits
    sl.registerFactory(() => MainCubit(sl(), sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<DioFinalHelper>(() => DioFinalHelper());
  }
}
