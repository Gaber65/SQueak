import 'package:squeak/core/service/signalr/signalr_conversation_services.dart';
import 'package:squeak/core/service/signalr/signalr_general_service.dart';
import 'package:squeak/features/friendship/domain/usecases/delete_friendship.dart';
import 'package:squeak/features/friendship/domain/usecases/block_friend.dart';
import 'package:squeak/features/layout/post/domain/usecase/create_post.dart';
import 'package:squeak/features/layout/post/domain/usecase/delete_post_usecase.dart';
import 'package:squeak/features/layout/stories/domain/usecases/delete_story_usecase.dart';
import 'package:squeak/features/layout/stories/domain/usecases/get_friends_stories_usecase.dart';
import 'package:squeak/features/layout/stories/domain/usecases/send_reply_msg_to_story_pet.dart';
import 'package:squeak/features/layout/stories/presentation/controllers/story_cubit.dart';

import 'package:squeak/features/mating/chat/domain/usecases/rate_mating_use_case.dart';
import 'package:squeak/features/mating/chat/domain/usecases/clear_conversation_use_case.dart';
import 'package:squeak/features/mating/chat/domain/usecases/delete_message_use_case.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_list_cubit.dart';
import 'package:squeak/features/mating/profile/domain/usecases/get_pet_profile_history_usecase.dart';

import '../../../features/layout/search/presentation/controller/search_cubit.dart';
import '../../../features/layout/stories/domain/usecases/get_all_friend_stories_usecase.dart';
import '../../../features/layout/stories/domain/usecases/get_story_reactions_usecase.dart';
import '../../../features/layout/stories/domain/usecases/react_to_story_usecase.dart';
import '../../../features/mating/matingRequest/domain/usecases/update_mating_request.dart';
import '../../../features/settings/persentaion/controller/setting_cubit.dart';
import '../../../features/vetcare/presenation/controllers/follow_request/follow_request_cubit.dart';
import 'locatore_export_path.dart';

final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    // Register Cubits
    sl.registerFactory(() => MainCubit(sl(), sl(), sl(), sl(), sl()));
    sl.registerFactory(() => CommentCubit(sl(), sl(), sl(), sl()));
    sl.registerFactory(() => PostCubit(sl(), sl(), sl()));
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
        mergePetsUseCase: sl(),
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
    sl.registerLazySingleton<MergePetsUsecase>(() => MergePetsUsecase(sl()));
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
    sl.registerLazySingleton(() => CreatePostUseCase(sl()));
    sl.registerLazySingleton(() => DeletePostUseCase(sl()));

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
      () =>
          AppointmentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
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

    // Cubits
    sl.registerFactory(
      () => BoardingCubit(
        getBoardingTypesUseCase: sl(),
        createBoardingUseCase: sl(),
        editBoardingUseCase: sl(),
        getBoardingEntriesUseCase: sl(),
        rateBoardingUseCase: sl(),
        shareImageEntriesUseCase: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetBoardingTypesUseCase(sl()));
    sl.registerLazySingleton(() => CreateBoardingUseCase(sl()));
    sl.registerLazySingleton(() => EditBoardingUseCase(sl()));
    sl.registerLazySingleton(() => GetBoardingEntriesUseCase(sl()));
    sl.registerLazySingleton(() => RateBoardingUseCase(sl()));
    sl.registerLazySingleton(() => ShareImageEntriesUseCase(sl()));

    // Repository
    sl.registerLazySingleton<BoardingRepository>(
      () => BoardingRepositoryImpl(remoteDataSource: sl()),
    );

    // Data sources
    sl.registerLazySingleton<BoardingLocalDataSource>(
      () => BoardingLocalDataSourceImpl(),
    );
    sl.registerLazySingleton<BoardingRemoteDataSource>(
      () => BoardingRemoteDataSourceImpl(),
    );

    // UI Cubit

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

    // External

    sl.registerLazySingleton<QrRemoteDataSource>(
      () => QrRemoteDataSourceImpl(),
    );

    // Repositories
    sl.registerLazySingleton<QrRepository>(() => QrRepositoryImpl(sl()));

    // Use cases

    sl.registerLazySingleton(() => LinkPetToQrUseCase(sl()));
    sl.registerLazySingleton(() => UnlinkPetFromQrUseCase(sl()));

    // Cubits
    sl.registerFactory(
      () => QrCubit(linkPetToQrUseCase: sl(), unlinkPetFromQrUseCase: sl()),
    );

    /// 🔹 Data sources
    sl.registerLazySingleton<ProfileSwitchLocalDataSource>(
      () => ProfileSwitchLocalDataSourceImpl(),
    );

    /// 🔹 Repository
    sl.registerLazySingleton<ProfileSwitchRepository>(
      () => ProfileSwitchRepositoryImpl(sl()),
    );

    /// 🔹 UseCases
    sl.registerLazySingleton(() => GetActiveProfileUseCase(sl()));
    sl.registerLazySingleton(() => SaveActiveProfileUseCase(sl()));

    /// 🔹 Cubit
    sl.registerFactory(() => SwitchProfileCubit(sl(), sl()));

    /// 🔹 Pet Friends
    /// 🔹 Repository
    sl.registerLazySingleton<PetFriendRepository>(
      () => PetFriendRepositoryImpl(sl()),
    );

    /// 🔹 use cases
    sl.registerLazySingleton(() => SendPetRequestUseCase(sl()));
    sl.registerLazySingleton(() => UpdatePetRequestUseCase(sl()));
    sl.registerLazySingleton(() => CancelFriendshipUseCase(sl()));
    sl.registerLazySingleton(() => UnblockFriendUseCase(sl()));
    sl.registerLazySingleton(() => BlockFriendUseCase(sl()));
    sl.registerLazySingleton(() => DeleteFriendShipUseCase(sl()));

    sl.registerLazySingleton(() => GetMyRequestsUseCase(sl()));
    sl.registerLazySingleton(() => GetMyFriendsUseCase(sl()));
    sl.registerLazySingleton(() => GetBlockedFriendsUseCase(sl()));
    sl.registerLazySingleton(() => GetSentRequestsUseCase(sl()));
    sl.registerLazySingleton(() => SearchFriendsUseCase(sl()));
    sl.registerLazySingleton(() => SendFriendMessageUseCase(sl()));

    /// 🔹 Data sources
    sl.registerLazySingleton<PetFriendRemoteDataSource>(
      () => PetFriendRemoteDataSourceImpl(),
    );

    /// 🔹 Cubit
    sl.registerFactory(
      () => PetFriendsCubit(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );
    // Data sources
    sl.registerLazySingleton<BaseChatRemoteDataSource>(
      () => ChatRemoteDataSource(),
    );

    // Repository
    sl.registerLazySingleton<BaseChatRepository>(() => ChatRepository(sl()));

    // Use cases
    sl.registerLazySingleton(() => GetChatsUseCase(sl()));
    sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
    sl.registerLazySingleton(() => SendMessageUseCase(sl()));
    sl.registerLazySingleton(() => FinishMatingUseCase(sl()));
    sl.registerLazySingleton(() => BlockChatUseCase(sl()));
    sl.registerLazySingleton(() => RenameChatUseCase(sl()));
    sl.registerLazySingleton(() => RateMatingUseCase(sl()));
    // Clear conversation (delete messages)
    sl.registerLazySingleton(() => ClearConversationUseCase(sl()));
    // Delete single message use case
    sl.registerLazySingleton(() => DeleteMessageUseCase(sl()));

    // Cubits
    sl.registerFactory(
      () => ChatMessagesCubit(
        getMessagesUseCase: sl(),
        sendMessageUseCase: sl(),
        startMatingUseCase: sl(),
        blockChatUseCase: sl(),
        renameChatUseCase: sl(),
        rateMatingUseCase: sl(),
      ),
    );
    sl.registerLazySingleton<SignalRConversationHubService>(() => SignalRConversationHubService());
    sl.registerLazySingleton<SignalRGeneralHubService>(() => SignalRGeneralHubService());

    sl.registerFactory(
      () => ChatListCubit(getChatsUseCase: sl(), signalRService: sl<SignalRGeneralHubService>()),
    );

    /// profile mating
    sl.registerLazySingleton(() => UpdatePetMatingStatuesUseCase(sl()));
    sl.registerLazySingleton<BaseMatingPetProfileRepo>(
      () => MatingPetProfileRepoImpl(sl()),
    );
    sl.registerLazySingleton<MatingProfileDataSource>(
      () => MatingProfileDataSourceImpl(),
    );
    sl.registerFactory(() => ProfileMatingCubit(sl(), sl(), sl()));

    /// 🧱 Data Source
    sl.registerLazySingleton<PetMatingRemoteDataSource>(
      () => PetMatingRemoteDataSourceImpl(),
    );

    /// 🧠 Repository
    sl.registerLazySingleton<BasePetMatingRepository>(
      () => PetMatingRepositoryImpl(remoteDataSource: sl()),
    );

    /// ⚙️ Use Cases
    sl.registerLazySingleton(() => GetAvailablePetsUseCase(sl()));
    sl.registerLazySingleton(() => GetPetProfileMatingUseCase(sl()));
    sl.registerLazySingleton(() => GetPetHistoryMatingUseCase(sl()));
    sl.registerLazySingleton(() => SendMatingRequestUseCase(sl()));
    sl.registerLazySingleton(() => UpdateSentRequestStatusUseCase(sl()));

    /// 🎯 Cubit
    sl.registerFactory(
      () => MatingFeedsCubit(
        getAvailablePetsUseCase: sl(),
        sendMatingRequestUseCase: sl(),
        updatePetStatusUseCase: sl(),
      ),
    );
    // ==========================
    // 🧩 CUBITS
    // ==========================
    sl.registerFactory(() => ManageRequestMatingCubit(sl(), sl(), sl()));

    // ==========================
    // ⚙️ USECASES
    // ==========================
    sl.registerLazySingleton(() => GetMatingRequestsUseCase(sl()));
    sl.registerLazySingleton(() => GetSentRequestsMatingUseCase(sl()));
    sl.registerLazySingleton(
      () => UpdateMatingRequestUseCase(repository: sl()),
    );

    // ==========================
    // 🏗️ REPOSITORIES
    // ==========================
    sl.registerLazySingleton<MatingRequestRepository>(
      () => MatingRequestRepositoryImpl(remoteDataSource: sl()),
    );

    // ==========================
    // 🌐 DATA SOURCES
    // ==========================
    sl.registerLazySingleton<MatingRequestRemoteDataSource>(
      () => MatingRequestRemoteDataSourceImpl(),
    );

    /// 📸 Stories
    sl.registerLazySingleton<StoryRemoteDataSource>(
      () => StoryRemoteDataSourceImpl(),
    );

    sl.registerLazySingleton<StoryRepository>(() => StoryRepositoryImpl(sl()));



    sl.registerLazySingleton(() => CreateStoryUseCase(sl()));
    sl.registerLazySingleton(() => DeleteStoryUseCase(sl()));
    sl.registerLazySingleton(() => GetMyActiveStoriesUseCase(sl()));
    sl.registerLazySingleton(() => GetFriendsStoriesUseCase(sl()));
    sl.registerLazySingleton(() => GetAllFriendStoriesUseCase(sl()));
    sl.registerLazySingleton(() => SendReplyMsgToStoryPetUseCase(sl()));
    sl.registerLazySingleton(() => GetStoryReactionsUseCase(sl()));
    sl.registerLazySingleton(() => ReactToStoryUseCase(sl()));
    sl.registerFactory(() => StoryCubit(
      createStoryUseCase: sl(),
      deleteStoryUseCase: sl(),
      getMyActiveStoriesUseCase: sl(),
      getFriendsStoriesUseCase: sl(),
      getAllFriendStoriesUseCase: sl(),
      sendReplyMsgToStoryPetUseCase: sl(),
      getStoryReactionsUseCase: sl(),
      reactToStoryUseCase: sl(),
    ));

    ///react
    sl.registerLazySingleton(() => ReactCubit(sl(), sl()));
    sl.registerLazySingleton<BaseReactRepo>(() => ReactRepo(sl()));
    sl.registerLazySingleton<ReactDataSource>(() => ReactDataSourceImpl());
    sl.registerLazySingleton(() => ReactOnPostUseCase(sl()));
    sl.registerLazySingleton(() => GetAllReactOnPostUseCase(sl()));
  }
}
