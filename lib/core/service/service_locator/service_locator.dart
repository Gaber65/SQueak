import 'package:get_it/get_it.dart';

import '../../../features/appointments/exam/presentation/controller/user/user_appointment_cubit.dart';
import '../../../features/layout/search/presentation/controller/search_cubit.dart';
import '../../../features/settings/persentaion/controller/setting_cubit.dart';
import '../../../features/vetcare/presenation/controllers/follow_request/follow_request_cubit.dart';
import 'locatore_export_path.dart';

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

    // Use cases
    sl.registerLazySingleton(() => GetVaccinationNamesUseCase(sl()));
    sl.registerLazySingleton(() => GetPetRemindersUseCase(sl()));
    sl.registerLazySingleton(() => CreateReminderUseCase(sl()));
    sl.registerLazySingleton(() => UpdateReminderUseCase(sl()));
    sl.registerLazySingleton(() => DeleteReminderUseCase(sl()));

    // Repository
    sl.registerLazySingleton<VaccinationRepository>(
      () => VaccinationRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );

    // Data sources
    sl.registerLazySingleton<VaccinationRemoteDataSource>(
      () => VaccinationRemoteDataSourceImpl(),
    );

    sl.registerLazySingleton<VaccinationLocalDataSource>(
      () => VaccinationLocalDataSourceImpl(),
    );

    // Data Cubit
    sl.registerFactory(
      () => VaccinationDataCubit(
        getVaccinationNamesUseCase: sl(),
        getPetRemindersUseCase: sl(),
        createReminderUseCase: sl(),
        updateReminderUseCase: sl(),
        deleteReminderUseCase: sl(),
      ),
    );

    // UI Cubit
    sl.registerFactory(() => VaccinationUiCubit(dataCubit: sl()));

    sl.registerLazySingleton<QRRemoteDataSource>(
      () => QRRemoteDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<QRRepository>(
      () => QRRepositoryImpl(remoteDataSource: sl()),
    );

    // Use cases
    sl.registerLazySingleton(() => CheckClinicInSupplierUseCase(sl()));
    sl.registerLazySingleton(() => FollowQRClinicUseCase(sl()));
    sl.registerLazySingleton(() => GetVetClientsUseCase(sl()));

    // Cubit
    sl.registerFactory(
      () => QRCubit(
        checkClinicInSupplierUseCase: sl(),
        followClinicUseCase: sl(),
        getVetClientsUseCase: sl(),
      ),
    );
  }
}
