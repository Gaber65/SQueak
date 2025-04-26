import 'package:get_it/get_it.dart';
import 'package:squeak/core/network/dio.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/presentation/controller/notifications_cubit.dart';
import 'package:squeak/features/layout/post/domain/usecase/get_user_posts_use_case.dart';
import 'package:squeak/features/layout/post/presentation/controller/post_cubit.dart';
import 'package:squeak/features/layout/search/domain/usecase/follow_clinic_use_case.dart';
import 'package:squeak/features/layout/search/domain/usecase/get_client_form_vet_use_case.dart';

import '../../../features/comments/data/data_source/comment_data_source.dart';
import '../../../features/comments/data/repository/comment_repository.dart';
import '../../../features/comments/domain/repository/base_comment_repository.dart';
import '../../../features/comments/domain/usecase/create_comment_use_case.dart';
import '../../../features/comments/domain/usecase/delete_comment_use_case.dart';
import '../../../features/comments/domain/usecase/get_comment_use_case.dart';
import '../../../features/comments/domain/usecase/update_comment_use_case.dart';
import '../../../features/comments/presentation/controller/comment_cubit.dart';
import '../../../features/layout/notification/NotificationAPI/data/data_source/notification_data_source.dart';
import '../../../features/layout/notification/NotificationAPI/data/repository/notification_repository.dart';
import '../../../features/layout/notification/NotificationAPI/domain/repository/base_repository_notification.dart';
import '../../../features/layout/notification/NotificationAPI/domain/usecase/get_all_notifications_use_case.dart';
import '../../../features/layout/notification/NotificationAPI/domain/usecase/get_post_notification_use_case.dart';
import '../../../features/layout/notification/NotificationAPI/domain/usecase/update_notification_state_use_case.dart';
import '../../../features/layout/post/data/data_source/post_data_source.dart';
import '../../../features/layout/post/data/repository/post_repository.dart';
import '../../../features/layout/post/domain/repository/base_post_repository.dart';
import '../../../features/layout/search/data/data_source/search_data_source.dart';
import '../../../features/layout/search/data/repository/search_repository.dart';
import '../../../features/layout/search/domain/repository/base_search_repository.dart';
import '../../../features/layout/search/domain/usecase/get_search_list_use_case.dart'
    show GetSearchListUseCase;
import '../../../features/layout/search/domain/usecase/get_supplier_use_case.dart';
import '../../../features/layout/search/domain/usecase/unfollow_clinic_use_case.dart'
    show UnfollowClinicUseCase;
import '../../../features/layout/search/presentation/controller/search_cubit.dart';
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
    // Register Cubits
    sl.registerFactory(() => MainCubit(sl(), sl(), sl(), sl(), sl()));
    sl.registerFactory(() => CommentCubit(sl(), sl(), sl(), sl()));
    sl.registerFactory(() => PostCubit(sl()));
    sl.registerFactory(() => SearchCubit(sl(), sl(), sl(), sl(), sl()));
    sl.registerFactory(() => NotificationsCubit(sl(), sl(), sl()));

    // Register Data sources
    sl.registerLazySingleton<MainRemoteDataSource>(
      () => MainRemoteDataSource(),
    );
    sl.registerLazySingleton<BaseCommentRemoteDataSource>(
      () => CommentRemoteDataSource(),
    );
    sl.registerLazySingleton<BasePostRemoteDataSource>(
      () => PostRemoteDataSource(),
    );
    sl.registerLazySingleton<BaseSearchRemoteDataSource>(
      () => SearchRemoteDataSource(),
    );
    sl.registerLazySingleton<BaseNotificationRemoteDataSource>(
      () => NotificationRemoteDataSource(),
    );

    // Register Repositories
    sl.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(sl()));
    sl.registerLazySingleton<BaseCommentRepository>(
      () => CommentRepository(sl()),
    );
    sl.registerLazySingleton<BasePostRepository>(() => PostRepository(sl()));
    sl.registerLazySingleton<BaseSearchRepository>(
      () => SearchRepository(sl()),
    );
    sl.registerLazySingleton<BaseNotificationRepository>(
      () => NotificationRepository(sl()),
    );

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
    sl.registerLazySingleton(() => UpdateCommentUseCase(sl()));
    sl.registerLazySingleton(() => GetCommentPostUseCase(sl()));
    sl.registerLazySingleton(() => DeleteCommentPostUseCase(sl()));
    sl.registerLazySingleton(() => CreateCommentUseCase(sl()));
    sl.registerLazySingleton(() => GetAllPostUseCase(sl()));

    sl.registerLazySingleton(() => FollowClinicUseCase(sl()));
    sl.registerLazySingleton(() => GetClientFormVetUseCase(sl()));
    sl.registerLazySingleton(() => GetSearchListUseCase(sl()));
    sl.registerLazySingleton(() => GetSupplierUseCase(sl()));
    sl.registerLazySingleton(() => UnfollowClinicUseCase(sl()));

    sl.registerLazySingleton(() => UpdateNotificationStateUseCase(sl()));
    sl.registerLazySingleton(() => GetAllNotificationsUseCase(sl()));
    sl.registerLazySingleton(() => GetPostNotificationUseCase(sl()));

    sl.registerLazySingleton<DioFinalHelper>(() => DioFinalHelper());
  }
}
