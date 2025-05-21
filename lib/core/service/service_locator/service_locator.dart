import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart'
    show InternetConnectionChecker;
import 'package:squeak/core/network/dio.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/data/data_source/appointment_local_data_source.dart';
import 'package:squeak/features/appointments/data/data_source/appointment_remote_data_source.dart';
import 'package:squeak/features/appointments/data/repo/appointment_repository_impl.dart';
import 'package:squeak/features/appointments/domain/base_repo/appointment_base_repository.dart';
import 'package:squeak/features/appointments/domain/use_case/create_appointment.dart';
import 'package:squeak/features/appointments/domain/use_case/delete_appointment.dart';
import 'package:squeak/features/appointments/domain/use_case/get_availabilities.dart';
import 'package:squeak/features/appointments/domain/use_case/get_client_in_clinic.dart';
import 'package:squeak/features/appointments/domain/use_case/get_doctors.dart';
import 'package:squeak/features/appointments/domain/use_case/get_invoice.dart';
import 'package:squeak/features/appointments/domain/use_case/get_suppliers.dart';
import 'package:squeak/features/appointments/domain/use_case/get_user_appointments.dart';
import 'package:squeak/features/appointments/domain/use_case/rate_appointment.dart';
import 'package:squeak/features/appointments/presentation/controller/clinic/appointment_cubit.dart';
import 'package:squeak/features/appointments/presentation/controller/user/user_appointment_cubit.dart';
import 'package:squeak/features/layout/layout/data/datasources/layout_local_data_source.dart';
import 'package:squeak/features/layout/layout/data/datasources/layout_remote_data_source.dart';
import 'package:squeak/features/layout/layout/data/repositories/layout_repository_impl.dart';
import 'package:squeak/features/layout/layout/domain/repositories/layout_repository.dart';
import 'package:squeak/features/layout/layout/domain/usecases/get_current_app_version_usecase.dart';
import 'package:squeak/features/layout/layout/domain/usecases/get_version_usecase.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/presentation/controller/notifications_cubit.dart';
import 'package:squeak/features/layout/post/domain/usecase/get_user_posts_use_case.dart';
import 'package:squeak/features/layout/post/presentation/controller/post_cubit.dart';
import 'package:squeak/features/layout/search/domain/usecase/follow_clinic_use_case.dart';
import 'package:squeak/features/layout/search/domain/usecase/get_client_form_vet_use_case.dart';
import 'package:squeak/features/settings/domain/use_case/get_owner_data_usecase.dart';
import 'package:squeak/features/settings/domain/use_case/update_profile_usecase.dart';

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
import '../../../features/pets/data/data_source/pet_local_data_source.dart';
import '../../../features/pets/data/data_source/pet_remote_data_source.dart';
import '../../../features/pets/data/repo/pet_repository_impl.dart';
import '../../../features/pets/domain/base_repo/pet_base_repository.dart';
import '../../../features/pets/domain/use_case/get_all_breeds_usecase.dart';
import '../../../features/pets/domain/use_case/get_owner_pets_usecase.dart';
import '../../../features/pets/domain/use_case/delete_pet_usecase.dart';
import '../../../features/pets/domain/use_case/create_pet_usecase.dart';
import '../../../features/pets/domain/use_case/get_all_species_usecase.dart';
import '../../../features/pets/domain/use_case/get_breeds_by_species_usecase.dart';
import '../../../features/pets/domain/use_case/update_pet_usecase.dart';
import '../../../features/pets/presentation/controller/pet_cubit.dart';
import '../../../features/settings/data/data_source/profile_local_data_source.dart';
import '../../../features/settings/data/data_source/profile_remote_data_source.dart';
import '../../../features/settings/data/repo/profile_repository_impl.dart';
import '../../../features/settings/domain/base_repo/profile_repository.dart';
import '../../../features/settings/persentaion/controller/setting_cubit.dart';
import '../../../features/vetcare/data/data_sorce/base_vet_data_source.dart';
import '../../../features/vetcare/data/data_sorce/vet_remote_data_source.dart';
import '../../../features/vetcare/data/repo/vet_repository_impl.dart';
import '../../../features/vetcare/domain/base_repo/base_vet_repository.dart';
import '../../../features/vetcare/domain/use_case/follow_request_usecase.dart';
import '../../../features/vetcare/domain/use_case/pet_async_usecase.dart';
import '../../../features/vetcare/domain/use_case/register_vet_usecase.dart';
import '../../../features/vetcare/presenation/controllers/follow_request/follow_request_cubit.dart';
import '../../../features/vetcare/presenation/controllers/pet_async/pet_async_cubit.dart';
import '../../../features/vetcare/presenation/controllers/vet_register/vet_register_cubit.dart';
import '../../network/network_info.dart';
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
    sl.registerFactory(
      () => PetCubit(
        getOwnerPetsUseCase: sl(),
        getAllBreedsUseCase: sl(),
        getBreedsBySpeciesUseCase: sl(),
        getAllSpeciesUseCase: sl(),
        createPetUseCase: sl(),
        updatePetUseCase: sl(),
        deletePetUseCase: sl(),
      ),
    );
    sl.registerFactory(
      () => SettingCubit(getOwnerDataUseCase: sl(), updateProfileUseCase: sl()),
    );

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
    sl.registerLazySingleton<PetRemoteDataSource>(
      () => PetRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<PetLocalDataSource>(
      () => PetLocalDataSourceImpl(),
    );

    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(),
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
    sl.registerLazySingleton<PetRepository>(
      () => PetRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
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

    sl.registerLazySingleton(() => GetOwnerPetsUseCase(sl()));
    sl.registerLazySingleton(() => GetAllBreedsUseCase(sl()));
    sl.registerLazySingleton(() => GetBreedsBySpeciesUseCase(sl()));
    sl.registerLazySingleton(() => GetAllSpeciesUseCase(sl()));
    sl.registerLazySingleton(() => CreatePetUseCase(sl()));
    sl.registerLazySingleton(() => UpdatePetUseCase(sl()));
    sl.registerLazySingleton(() => DeletePetUseCase(sl()));

    sl.registerLazySingleton(() => GetOwnerDataUseCase(sl()));
    sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

    sl.registerLazySingleton<DioFinalHelper>(() => DioFinalHelper());
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker.createInstance(),
    );

    sl.registerFactory(
      () => VetRegisterCubit(
        registerUseCase: sl(),
        loginUseCase: sl(),
        getClientUseCase: sl(),
      ),
    );

    sl.registerFactory(
      () => FollowRequestCubit(
        acceptInvitationUseCase: sl(),
        getNotificationsUseCase: sl(),
        updateNotificationStateUseCase: sl(),
      ),
    );

    sl.registerFactory(
      () => PetAsyncCubit(
        getClientsFromVetUseCase: sl(),
        addInSqueakStatusUseCase: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => RegisterVetUseCase(sl()));
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => GetClientUseCase(sl()));

    sl.registerLazySingleton(() => AcceptInvitationUseCase(sl()));
    sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
    sl.registerLazySingleton(() => UpdateNotificationToVetStateUseCase(sl()));

    sl.registerLazySingleton(() => GetClientsFromVetUseCase(sl()));
    sl.registerLazySingleton(() => AddInSqueakStatusUseCase(sl()));

    // Repository
    sl.registerLazySingleton<BaseVetRepository>(() => VetRepository(sl()));

    sl.registerFactory(
      () => LayoutCubit(
        getVersionUseCase: sl(),
        getCurrentAppVersionUseCase: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetVersionUseCase(sl()));
    sl.registerLazySingleton(() => GetCurrentAppVersionUseCase(sl()));

    // Repository
    sl.registerLazySingleton<LayoutRepository>(
      () => LayoutRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    );

    // Data sources
    sl.registerLazySingleton<LayoutRemoteDataSource>(
      () => LayoutRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<LayoutLocalDataSource>(
      () => LayoutLocalDataSourceImpl(),
    );

    // Data sources
    sl.registerLazySingleton<BaseVetRemoteDataSource>(
      () => VetRemoteDataSource(),
    );
    // Cubits
    sl.registerFactory(
      () => AppointmentCubit(
        getAvailabilitiesUseCase: sl(),
        getSuppliersUseCase: sl(),
        getDoctorsUseCase: sl(),
        getClientInClinicUseCase: sl(),
        createAppointmentUseCase: sl(),
        unfollowClinicUseCase: sl(),
        followClinicUseCase: sl(),
      ),
    );

    sl.registerFactory(
      () => UserAppointmentCubit(
        getUserAppointments: sl(),
        deleteAppointment: sl(),
        rateAppointment: sl(),
        getSuppliers: sl(),
        followClinic: sl(),
        getInvoice: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetAvailabilitiesUseCase(sl()));
    sl.registerLazySingleton(() => GetSuppliersUseCase(sl()));
    sl.registerLazySingleton(() => GetDoctorsUseCase(sl()));
    sl.registerLazySingleton(() => GetClientInClinicUseCase(sl()));
    sl.registerLazySingleton(() => CreateAppointmentUseCase(sl()));
    sl.registerLazySingleton(() => GetUserAppointmentsUseCase(sl()));
    sl.registerLazySingleton(() => DeleteAppointmentUseCase(sl()));
    sl.registerLazySingleton(() => RateAppointmentUseCase(sl()));
    sl.registerLazySingleton(() => GetInvoiceUseCase(sl()));

    // Repository
    sl.registerLazySingleton<AppointmentRepository>(
      () => AppointmentRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    );

    // Data sources
    sl.registerLazySingleton<AppointmentRemoteDataSource>(
      () => AppointmentRemoteDataSourceImpl(),
    );

    sl.registerLazySingleton<AppointmentLocalDataSource>(
      () => AppointmentLocalDataSourceImpl(),
    );
  }
}
