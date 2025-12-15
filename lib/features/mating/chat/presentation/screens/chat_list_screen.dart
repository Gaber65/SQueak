import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/connectivity/conectivity_services.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_list_cubit.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../../../../settings/persentaion/controller/setting_cubit.dart';
import '../../../layoutMating/presentation/screens/widgets/profile_switcher_builder.dart';
import '../../domain/entities/chat_entity.dart';
import '../widgets/chat_widgets/mating_chat_list_tile.dart';
import '../controllers/chat_list_state.dart';
import '../controllers/chat_app_cubit.dart';
import '../controllers/chat_app_state.dart';

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
  String? _currentPetId;

  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = ConnectivityService().connectionStatus.listen((
      isConnected,
    ) {
      if (isConnected && _currentPetId != null && mounted) {
        print(
          '🌐 [ChatListScreen] Connection restored, refreshing chats silently',
        );
        context.read<ChatListCubit>().refreshChatsWithoutLoading(
          _currentPetId!,
        );
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  // -------------------------------------------------------------
  //  UI
  // -------------------------------------------------------------
  // Note: ChatAppCubit is created here and connects to GeneralHub.
  // GeneralHub remains connected even when navigating to individual chats.
  // ConversationHub is connected/disconnected in the chat detail screen.
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatListCubit>();

    print('📋 [ChatListScreen] Building ChatListScreen');
    print(
      '📡 [ChatListScreen] This screen uses GeneralHub only (no ConversationHub)',
    );

    return BlocSelector<SwitchProfileCubit, SwitchProfileState, PetEntities?>(
      selector: (state) {
        if (state is ProfileLoaded && state.profile.pet != null) {
          final pet = state.profile.pet!;
          if (_currentPetId != pet.petId) {
            print(
              '🔄 [ChatListScreen] Pet changed to: ${pet.petId}, loading chats...',
            );
            cubit.loadChats(pet.petId ?? '');
            _currentPetId = pet.petId;
          }
          return pet;
        }
        return null;
      },
      builder: (_, pet) {
        if (pet == null) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        print(
          '🚀 [ChatListScreen] Creating ChatAppCubit for petId: ${pet.petId}',
        );
        print('🔌 [ChatListScreen] ChatAppCubit will connect to GeneralHub');
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
              // Handle UnreadCountUpdated - Update counter in background without server fetch
              if (state is UnreadCountUpdated) {
                print(
                  '🔔 [ChatListScreen] Received UnreadCountUpdated for conversation ${state.conversationId}: ${state.count}',
                );
                context.read<ChatListCubit>().updateUnreadCountLocally(
                  state.conversationId,
                  state.count,
                );
              }

              // Handle NewMessageDetected - Refresh to get new message details
              if (state is NewMessageDetected) {
                print(
                  '🔄 [ChatListScreen] Received NewMessageDetected for conversation: ${state.conversationId}',
                );
                print('   📨 From: ${state.fromPetId}');
                print('   📝 Content: ${state.contentMessage}');
                print('   🖼️ Image: ${state.imageMessage}');
                print('   🎥 Video: ${state.videoMessage}');
                print('   📎 File: ${state.fileMessage}');
                print('   🎵 Audio: ${state.audioMessage}');
                if (activePet?.petId != null) {
                  context.read<ChatListCubit>().refreshChatsWithoutLoading(
                    activePet!.petId!,
                  );
                }
              }

              // Handle FriendOnlineStatusChanged - Persist delivered status
              if (state is FriendOnlineStatusChanged) {
                if (state.isOnline) {
                  print(
                    '🔄 [ChatListScreen] Friend ${state.petId} came online - updating local chat status',
                  );
                  context.read<ChatListCubit>().updateChatOnlineStatus(
                    state.petId,
                    true,
                  );
                }
              }

              // Full refresh only on leaving conversation (to update last message)
              if (state is ConversationLeft) {
                print(
                  '🔄 [ChatListScreen] Left conversation, doing full refresh',
                );
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
          BlocListener<ChatListCubit, ChatListState>(
            listener: (context, state) {
              if (state is ChatListLoaded) {
                // When list loads, check if any friends are online and update status locally
                // This handles the case where users are ALREADY online when the list loads
                final chatAppCubit = context.read<ChatAppCubit>();
                for (final chat in state.chats) {
                  if (chatAppCubit.generalHub.isPetOnlineFromDict(chat.petId)) {
                    context.read<ChatListCubit>().updateChatOnlineStatus(
                      chat.petId,
                      true,
                    );
                  }
                }
              }
            },
          ),
        ],
        child: BlocBuilder<ChatListCubit, ChatListState>(
          builder: (context, state) {
            // Debug logging
            final chatAppCubit = context.read<ChatAppCubit>();
            debugPrint(
              '📊 Typing indicators: ${chatAppCubit.typingIndicators}',
            );
            debugPrint(
              '📊 Online friends: ${chatAppCubit.generalHub.onlineFriendsDict}',
            );

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
        child: _buildChatTiles(pet!, state.chats, theme, isDark),
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
    PetEntities pet,
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
            current is UnreadCountsPolled ||
            current is NewMessageDetected ||
            current is ChatAppConnected;
      },
      builder: (context, chatAppState) {
        final chatAppCubit = context.read<ChatAppCubit>();

        // Debug logging to see typing indicators
        if (chatAppState is FriendTypingInGeneral) {
          print(
            '🔥 UI REBUILDING for typing: ${chatAppState.toPetId} -> ${chatAppCubit.typingIndicators[chatAppState.toPetId]}',
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children:
                chats.map((chat) {
                  final isTyping =
                      chatAppCubit.typingIndicators[chat.petId] ?? false;
                  final isOnline = chatAppCubit.generalHub.isPetOnlineFromDict(
                    chat.petId,
                  );

                  if (isTyping) {
                    print(
                      '✍️ [ChatListScreen] عرض ${chat.name} (${chat.petId}) مع isTyping=true',
                    );
                    print(
                      '✍️ [ChatListScreen] Rendering ${chat.name} (${chat.petId}) with isTyping=true',
                    );
                  }

                  return StreamBuilder<Map<String, int>>(
                    stream: chatAppCubit.unreadCountsStream,
                    initialData: chatAppCubit.unreadCounts,
                    builder: (context, snapshot) {
                      // Get unread count from stream (real-time), fallback to chat entity
                      final unreadCountsMap = snapshot.data ?? {};
                      final unreadCount =
                          unreadCountsMap[chat.id] ?? chat.unreadedCount;

                      return MatingChatListTile(
                        chat: chat,
                        petEntities: pet,
                        isOnline: isOnline,
                        isTyping: isTyping,
                        unreadCount: unreadCount,
                        onNavigateComplete:
                            () => context.read<ChatListCubit>().loadChats(
                              pet.petId!,
                            ),
                      );
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
