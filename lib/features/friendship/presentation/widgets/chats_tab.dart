import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/signalr/signalr_general_service.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/presentation/widgets/empty_chats_widget.dart';
import 'package:squeak/features/friendship/presentation/widgets/friends_tab.dart';
import 'package:squeak/features/friendship/presentation/widgets/section_header_widget.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_widgets/mating_chat_list_tile.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  bool _isConnecting = false;
  StreamSubscription<SignalEvent>? _eventSubscription;
  final Map<String, bool> _typingStates = {};
  final Map<String, int> _unreadCounts = {};
  String? _currentActivePetId;
  final SignalRGeneralHubService _generalHub = SignalRGeneralHubService();

  @override
  void initState() {
    super.initState();
    _initializeSignalR();
  }

  Future<void> _initializeSignalR() async {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      final activePet = SwitchProfileCubit.get(context).activeProfile?.pet;
      if (activePet?.petId == null) {
        debugPrint('❌ No active pet ID found');
        return;
      }
      _currentActivePetId = activePet!.petId;
      debugPrint('🔄 Connecting to GeneralHub for pet: $_currentActivePetId');

      // Connect to GeneralHub
      await _generalHub.connect(
        petId: _currentActivePetId!,
        fullName: activePet.petName,
        image: activePet.imageName,
      );

      debugPrint('✅ GeneralHub connected successfully from ChatsTab');

      // Setup event listeners
      _setupEventListeners();

      // Fire the 3 events after successful connection
      _fireInitialEvents();
    } catch (e) {
      debugPrint('❌ Failed to connect GeneralHub: $e');
      _setupEventListeners();
      debugPrint('✅ Both hubs connected successfully from ChatsTab');
    } finally {
      _isConnecting = false;
    }
  }
  void _setupEventListeners() {
    debugPrint('🎧 Setting up GeneralHub event listeners...');
    _eventSubscription = signalEventStream.stream.listen((event) {
      if (event.hub == 'GeneralHub') {
        debugPrint('📥 GeneralHub Event: ${event.method}');
        _handleSignalEvent(event);
      }
    });
  }

  void _fireInitialEvents() {
    if (_currentActivePetId == null) return;
    debugPrint('🔥 Requesting initial data from server...');
    debugPrint('ℹ️  Events will be handled through centralized stream');
    _requestInitialData();
  }

  Future<void> _requestInitialData() async {
    if (_currentActivePetId == null) return;
    debugPrint('📡 Requesting initial data from server...');
    try {
      final onlineFriends = await _generalHub.getAllMyOnlinePetFriends(
        _currentActivePetId!,
      );
      if (onlineFriends != null) {
        debugPrint('✅ Got ${onlineFriends.length} online friends');
      }

      final unreadCounts = await _generalHub.getUnreadMessageCounts(
        _currentActivePetId!,
      );
      if (unreadCounts != null) {
        debugPrint('✅ Got unread counts: $unreadCounts');
        if (mounted) {
          setState(() {
            _unreadCounts.clear();
            _unreadCounts.addAll(unreadCounts);
          });
        }
      }

      debugPrint('✅ Initial data requests completed');
    } catch (e) {
      debugPrint('⚠️ Error requesting initial data: $e');
    }
  }

  void _handleSignalEvent(SignalEvent event) {
    debugPrint('📥 SignalR Event: ${event.hub} - ${event.method}');

    if (event.hub == 'GeneralHub') {
      _handleGeneralHubEvent(event);
    }
  }

  void _handleGeneralHubEvent(SignalEvent event) {
    debugPrint('📥 GeneralHub Event: ${event.method}');

    switch (event.method) {
      case 'ConnectionRegistered':
        _handleConnectionRegistered(event.data);
        break;

      case 'FriendConnectionChanged':
        _handleFriendConnectionChange(event.data);
        break;

      case 'UnreadedMessagesCountPetConversation':
        _handleUnreadCountsUpdate(event.data);
        break;

      case 'FriendIsTyping':
        _handleGlobalTypingIndicator(event.data);
        break;

      case 'ChatListUpdated':
        _refreshChatsList();
        _showSnackBar('Chat list updated');
        break;

      case 'ReceiveMessage':
      case 'NewMessage':
        _refreshChatsList();
        _handleNewMessage(event.data);
        break;
    }
  }

  void _handleGlobalTypingIndicator(List<Object?>? data) {
    if (data != null && data.isNotEmpty) {
      final typingData = data.first as Map<String, dynamic>?;
      if (typingData != null) {
        final petId = typingData['PetId'] as String?;
        final isTyping = typingData['IsTyping'] as bool?;
        final petName = typingData['PetName'] as String?;
        if (petId != null && isTyping != null) {
          setState(() {
            _typingStates[petId] = isTyping;
          });

          if (isTyping) {
            _showSnackBar('$petName is typing...');
          }
        }
      }
    }
  }

  void _handleUnreadCountsUpdate(List<Object?>? data) {
    if (data != null && data.isNotEmpty) {
      final countsData = data.first as Map<String, dynamic>?;
      if (countsData != null) {
        final unreadCounts =
            (countsData['UnreadedCounts'] ?? countsData['UnreadCounts'])
                as Map<dynamic, dynamic>?;

        if (unreadCounts != null && mounted) {
          setState(() {
            _unreadCounts.clear();
            unreadCounts.forEach((key, value) {
              _unreadCounts[key.toString()] = value as int;
            });
          });
          debugPrint('📊 Unread counts updated: $_unreadCounts');
        }
      }
    }
  }

  void _handleConnectionRegistered(List<Object?>? data) {
    if (data != null && data.isNotEmpty) {
      final connectionData = data.first as Map<String, dynamic>?;
      if (connectionData != null) {
        debugPrint('✅ Connection Registered: $connectionData');
        if (mounted) {
          setState(() {
          });
        }
      }
    }
  }

  void _handleFriendConnectionChange(List<Object?>? data) {
    if (data != null && data.isNotEmpty) {
      final connectionData = data.first as Map<String, dynamic>?;
      if (connectionData != null) {
        final petId = connectionData['PetId'] as String?;
        final isOnline = connectionData['IsOnline'] as bool?;
        final petName = connectionData['FullName'] as String?;

        debugPrint(
          '👥 Friend Status: $petName ${isOnline == true ? 'online' : 'offline'}',
        );
        if (mounted) {
          _refreshChatsList();

          if (petId != null && isOnline != null && petName != null) {
            _showSnackBar('$petName is now ${isOnline ? 'online' : 'offline'}');
          }
        }
      }
    }
  }

  void _handleNewMessage(List<Object?>? data) {
    if (data != null && data.isNotEmpty) {
      final messageData = data.first as Map<String, dynamic>?;
      if (messageData != null) {
        final fromPetId = messageData['FromPetId'] as String?;
        final conversationId = messageData['ConversationId'] as String?;
        _refreshChatsList();
        if (fromPetId != null && conversationId != null) {
          _showNewMessageNotification(fromPetId, conversationId);
        }
      }
    }
  }


  void _showNewMessageNotification(String fromPetId, String conversationId) {
    debugPrint(
      '📨 New message from $fromPetId in conversation $conversationId',
    );
    _showSnackBar('New message received');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _refreshChatsList() {
    final activePet = SwitchProfileCubit.get(context).activeProfile?.pet;
    if (activePet?.petId != null) {
      _currentActivePetId = activePet!.petId;
      PetFriendsCubit.get(context).loadChats(petId: activePet.petId!);
    }
  }

 

  @override
  void dispose() {
    debugPrint('🔌 Disconnecting GeneralHub from ChatsTab');
    _generalHub.disconnect();
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildConnectionStatus(),
        Expanded(
          child: BlocBuilder<PetFriendsCubit, PetFriendsState>(
            builder: (context, state) {
              final activePet =
                  SwitchProfileCubit.get(context).activeProfile?.pet;
              _currentActivePetId = activePet?.petId;
              if (state is ChatsLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  
                });
              }

              if (state is ChatsLoading) {
                return DogLoadingStateWidget(
                  theme: Theme.of(context),
                  isDark: Theme.of(context).brightness == Brightness.dark,
                  s: S.of(context),
                  text: S.of(context).loadingPetsChats,
                );
              } else if (state is ChatsLoadFailed) {
                return _buildErrorState(context, state.message);
              } else if (state is ChatsLoaded) {
                if (state.chats.isEmpty) {
                  return const EmptyChatsWidget();
                }
                return _buildChatsList(
                  context,
                  state.chats,
                  activePet?.petId ?? '',
                );
              }
              return const EmptyChatsWidget();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    return StreamBuilder<bool>(
      stream: _generalHub.connectionStream,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? _generalHub.isConnected;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isConnected ? 0 : 40,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isConnected ? 0 : 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.orange[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.signal_wifi_off,
                    color: Colors.orange[800],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Connecting to chat...',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange[800]!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            isArabic() ? 'فشل تحميل المحادثات' : 'Failed to load chats',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              final activePet =
                  SwitchProfileCubit.get(context).activeProfile?.pet;
              if (activePet?.petId != null) {
                PetFriendsCubit.get(
                  context,
                ).loadChats(petId: activePet!.petId!);
              }
            },
            icon: const Icon(Icons.refresh),
            label: Text(isArabic() ? 'حاول مرة أخرى' : 'Try Again'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _initializeSignalR,
            icon: const Icon(Icons.wifi),
            label: Text(isArabic() ? 'إعادة الاتصال' : 'Reconnect Hubs'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(
    BuildContext context,
    List<ChatEntity> chats,
    String petId,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        if (petId.isNotEmpty) {
          await PetFriendsCubit.get(context).loadChats(petId: petId);
        }
      },
      child: StreamBuilder<SignalEvent>(
        stream: signalEventStream.stream,
        builder: (context, snapshot) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildChatsHeader(chats.length),
              const SizedBox(height: 16),
              ...chats.asMap().entries.map(
                (entry) => AnimatedItem(
                  index: entry.key,
                  child: MatingChatListTile(
                    chat: entry.value,
                    petId: petId,
                    onNavigateComplete: () async {
                      if (petId.isNotEmpty) {
                        await PetFriendsCubit.get(
                          context,
                        ).loadChats(petId: petId);
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatsHeader(int chatCount) {
    return Row(
      children: [
        Expanded(
          child: SectionHeader(
            icon: IconlyBold.chat,
            title: isArabic() ? 'محادثاتي' : 'My Chats',
            count: chatCount,
            color: ColorManager.primaryColor,
          ),
        ),
        // Quick actions
        _buildQuickActions(),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        // Refresh unread counts
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {},
          tooltip: 'Refresh unread counts',
        ),
        // Connection status indicator
        StreamBuilder<bool>(
          stream: _generalHub.connectionStream,
          builder: (context, snapshot) {
            final isConnected = snapshot.data ?? _generalHub.isConnected;
            return Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isConnected ? Colors.green : Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        isConnected
                            ? Colors.green.withOpacity(0.5)
                            : Colors.red.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  bool isArabic() {
    return Localizations.localeOf(context).languageCode == 'ar';
  }
}
