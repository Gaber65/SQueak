// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/signalr/signalr_general_service.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_list_cubit.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../core/utils/enums/profile_type.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../../../../settings/persentaion/controller/setting_cubit.dart';
import '../../../layoutMating/presentation/screens/widgets/profile_switcher_builder.dart';
import '../../domain/entities/chat_entity.dart';
import '../widgets/chat_widgets/mating_chat_list_tile.dart';
import '../controllers/chat_list_state.dart';
import '../view/chat_app_cubit.dart';
import '../view/chat_app_state.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ChatListCubit>()),
        BlocProvider(create: (_) => sl<PetCubit>()..getOwnerPets()),
        BlocProvider(create: (_) => sl<SettingCubit>()..getOwnerData()),
        BlocProvider(create: (_) => sl<SwitchProfileCubit>()..loadProfile()),
      ],
      child: const _ChatListView(),
    );
  }
}

class _ChatListView extends StatefulWidget {
  const _ChatListView();

  @override
  State<_ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<_ChatListView> {
  final SignalRGeneralHubService _generalHub = SignalRGeneralHubService();

  StreamSubscription<SignalEvent>? _eventSubscription;
  StreamSubscription<SwitchProfileState>? _profileSubscription;

  String? _currentPetId;
  bool _hubConnected = false;

  @override
  void initState() {
    super.initState();

    // Listen for profile loaded ONCE → connect hub
    _profileSubscription = context.read<SwitchProfileCubit>().stream.listen((
      state,
    ) {
      if (state is ProfileLoaded &&
          state.profile.type == ProfileType.pet &&
          !_hubConnected) {
        _connectHub(state.profile.pet!);
      }
    });
  }

  // -------------------------------------------------------------
  //  CONNECT HUB EXACTLY ONCE
  // -------------------------------------------------------------
  Future<void> _connectHub(PetEntities pet) async {
    try {
      _currentPetId = pet.petId;
      debugPrint("🔄 Connecting to GeneralHub for pet: $_currentPetId)");

      // Note: ChatAppCubit will handle the GeneralHub connection
      // We just set up our local event listeners here
      await _generalHub.connect(
        petId: pet.petId!,
        fullName: pet.petName,
        image: pet.imageName,
      );

      _hubConnected = true;
      debugPrint("✅ GeneralHub connected!");

      _setupHubEvents();
      _requestInitialData();
    } catch (e) {
      debugPrint("❌ Hub connection error: $e");
    }
  }

  // -------------------------------------------------------------
  //  SIGNALR EVENT HANDLERS (REAL-TIME)
  // -------------------------------------------------------------
  void _setupHubEvents() {
    debugPrint("🎧 Listening for SignalR events...");

    // Listen to all hub events
    _eventSubscription = signalEventStream.stream.listen((event) {
      if (event.hub == "GeneralHub") {
        debugPrint("📥 GeneralHub Event → ${event.method}");
      }
    });

    // Friend online/offline
    _generalHub.onFriendConnectionChanged((data) {
      debugPrint("🔥 FriendConnectionChanged → $data");
      if (_currentPetId != null) {
        context.read<ChatListCubit>().loadChats(_currentPetId!);
      }
    });

    // Unread messages count
    _generalHub.onUnreadedMessagesCount((data) {
      debugPrint("🔥 UnreadMessagesCount → $data");
      if (_currentPetId != null) {
        context.read<ChatListCubit>().loadChats(_currentPetId!);
      }
    });

    // Connection confirmation
    _generalHub.onConnectionRegistered((data) {
      debugPrint("🔥 ConnectionRegistered → $data");
    });

    debugPrint("🎧 SignalR event listeners registered");
  }

  // -------------------------------------------------------------
  //  CALL INITIAL DATA FROM HUB
  // -------------------------------------------------------------
  Future<void> _requestInitialData() async {
    if (_currentPetId == null) return;

    try {
      final onlineFriends = await _generalHub.getAllMyOnlinePetFriends(
        _currentPetId!,
      );
      debugPrint("👥 Online friends count: ${onlineFriends?.length}");

      final unread = await _generalHub.getUnreadMessageCounts(_currentPetId!);
      debugPrint("📨 Unread messages: $unread");
    } catch (e) {
      debugPrint("⚠ Initial data error: $e");
    }
  }

  // -------------------------------------------------------------
  //  CLEANUP
  // -------------------------------------------------------------
  @override
  void dispose() {
    debugPrint("🔌 DISCONNECTING HUB...");
    _profileSubscription?.cancel();
    _eventSubscription?.cancel();
    _generalHub.disconnect();
    super.dispose();
  }

  // -------------------------------------------------------------
  //  UI
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatListCubit>();

    return BlocSelector<SwitchProfileCubit, SwitchProfileState, PetEntities?>(
      selector: (state) {
        if (state is ProfileLoaded && state.profile.pet != null) {
          final pet = state.profile.pet!;
          cubit.loadChats(pet.petId!);
          return pet;
        }
        return null;
      },
      builder: (_, pet) {
        if (pet == null) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return BlocProvider(
          create:
              (context) => ChatAppCubit(
                petId: pet.petId!,
                fullName: pet.petName ?? '',
                image: pet.imageName ?? '',
              )..initialize(),
          child: _buildMainUi(pet),
        );
      },
    );
  }

  // MAIN UI BUILDER
  Widget _buildMainUi(PetEntities? activePet) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ChatAppCubit, ChatAppState>(
            listener: (context, state) {
              // Refresh chat list on relevant SignalR events
              if (state is UnreadCountUpdated ||
                  state is MessageReceived ||
                  state is FriendOnlineStatusChanged) {
                if (activePet?.petId != null) {
                  context.read<ChatListCubit>().loadChats(activePet!.petId!);
                }
              }

              if (state is ChatAppError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: BlocBuilder<ChatListCubit, ChatListState>(
          builder: (context, state) {
            // Debug logging
            final chatAppCubit = context.read<ChatAppCubit>();
            debugPrint('📊 Typing indicators: ${chatAppCubit.typingIndicators}');
            debugPrint('📊 Online friends: ${chatAppCubit.onlineFriends}');
            
            return CustomScrollView(
              slivers: [
                _buildAppBar(context, theme, isDark),
                SliverToBoxAdapter(
                  child: _buildChatListContent(state, activePet),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  //  APP BAR
  // -------------------------------------------------------------
  SliverAppBar _buildAppBar(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      title: Text(
        "All Chats",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      actions: [buildProfileSwitcher(context)],
    );
  }

  // -------------------------------------------------------------
  //  CHAT LIST LOGIC
  // -------------------------------------------------------------
  Widget _buildChatListContent(ChatListState state, PetEntities? pet) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (state is ChatListLoading) {
      return DogLoadingStateWidget(
        theme: theme,
        isDark: isDark,
        text: "Loading chats...",
        s: S.of(context),
      );
    }

    if (state is ChatListError) {
      return _buildError(state.message);
    }

    if (state is ChatListLoaded) {
      if (state.chats.isEmpty) return _buildEmpty();

      return RefreshIndicator(
        onRefresh: () async {
          if (pet.petId != null) {
            await context.read<ChatListCubit>().loadChats(pet.petId!);
          }
        },
        child: _buildChatTiles(pet!.petId!, state.chats, theme, isDark),
      );
    }

    return _buildEmpty();
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        children: [
          Lottie.network(
            "https://lottie.host/b1930cd0-34dc-4097-9233-a36331b2372b/Oqk8zoLEPO.json",
          ),
          Text("Error: $message"),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        children: [
          Lottie.network(
            "https://lottie.host/efe816d3-f5da-499c-b0b5-ffc0cd6f713e/oj7UhZc4wU.json",
          ),
          const Text("No chats yet"),
        ],
      ),
    );
  }

  Widget _buildChatTiles(
    String petId,
    List<ChatEntity> chats,
    ThemeData theme,
    bool isDark,
  ) {
    return BlocBuilder<ChatAppCubit, ChatAppState>(
      buildWhen: (previous, current) {
        // Rebuild when online status, typing status, or unread count changes
        return current is FriendOnlineStatusChanged ||
            current is FriendTypingInGeneral ||
            current is UnreadCountUpdated ||
            current is ChatAppConnected;
      },
      builder: (context, chatAppState) {
        final chatAppCubit = context.read<ChatAppCubit>();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children:
                chats
                    .map(
                      (chat) => MatingChatListTile(
                        chat: chat,
                        petId: petId,
                        isOnline:
                            chatAppCubit.onlineFriends[chat.petId] ?? false,
                        isTyping:
                            chatAppCubit.typingIndicators[chat.petId] ?? false,
                        unreadCount:
                            chatAppCubit.unreadCounts[chat.id] ??
                            chat.unreadedCount,
                        onNavigateComplete:
                            () =>
                                context.read<ChatListCubit>().loadChats(petId),
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );
  }
}
