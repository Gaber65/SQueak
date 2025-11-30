import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:squeak/core/signalr/signalr_connection_status_widget.dart';
import 'package:squeak/core/service/signalr/signalr_service.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_status.dart';
import 'package:squeak/features/mating/chat/domain/entities/message_entity.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_app_bar.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/message_bubble.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attachment_options_bottom_sheet.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../../pets/domain/entities/pet_entity.dart';
import '../controllers/chat_messages_state.dart';

class MatingChatDetailScreen extends StatefulWidget {
  final PetEntities? pet;
  final ChatEntity chat;

  const MatingChatDetailScreen({super.key, required this.chat, this.pet});

  @override
  State<MatingChatDetailScreen> createState() => _MatingChatDetailScreenState();
}

class _MatingChatDetailScreenState extends State<MatingChatDetailScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  late AnimationController _animationController;
  final SignalRService _signalRService = SignalRService();

  bool _isReadOnly = false;
  bool _isMatingStarted = false;
  bool isCompleted = false;
  bool _isBlocked = false;
  bool _isBlockedByMe = false;
  bool _isBlockedByOther = false;

  // Track uploading files to show in chat
  final List<_UploadingMedia> _uploadingFiles = [];

  // Typing indicator
  bool _isOtherUserTyping = false;
  Timer? _typingTimer;
  bool _isCurrentlyTyping = false;
  ChatMessagesCubit? _chatCubit;

  // Recording variables
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  int _recordDuration = 0;
  Timer? _recordTimer;
  bool _hasText = false;
  static const int _maxRecordDuration = 60; 
  ChatMessagesCubit? _recordingCubit; 

  @override
  void initState() {
    super.initState();

    // Connect to Conversation Hub when chat screen opens
    _connectToConversationHub();

    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
      _handleTypingIndicator();
    });

    _isBlocked = widget.chat.isBlock;
    _isBlockedByMe = widget.chat.isBlockedByMe;
    _isBlockedByOther = widget.chat.isBlockedByOther;
    isCompleted = widget.chat.completeMarriageStatues;

    _isMatingStarted = _getChatStatus() == ChatStatus.onMating;
    _isReadOnly = (isCompleted && _isReadOnly) || _isBlocked;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Setup typing listener after a short delay to ensure cubit is ready
    Future.delayed(const Duration(milliseconds: 100), () {
      _setupTypingListener();
    });
  }

  @override
  void dispose() {
    _disconnectFromConversationHub();
    _messageController.dispose();
    _animationController.dispose();
    _recordTimer?.cancel();
    _typingTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  // Connect to Conversation Hub for real-time chat messages
  Future<void> _connectToConversationHub() async {
    try {
      await _signalRService.connectToConversationHub();
      
      // Mark messages as read when opening chat
      if (widget.chat.id.isNotEmpty) {
        final petId = widget.chat.petId;
        if (petId.isNotEmpty) {
          await _signalRService.markMessagesAsRead(widget.chat.id, petId);
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to connect to Conversation Hub: $e');
    }
  }

  // Disconnect from Conversation Hub
  Future<void> _disconnectFromConversationHub() async {
    try {
      await _signalRService.disconnectFromConversationHub();
    } catch (e) {
      debugPrint('❌ Failed to disconnect from Conversation Hub: $e');
    }
  }

  // Setup SignalR listener for typing status
  void _setupTypingListener() {
    _signalRService.onConversationMessageReceived(
      'FriendIsTyping',
      (arguments) {
        if (arguments != null && arguments.isNotEmpty && mounted) {
          final isTyping = arguments[0] as bool? ?? false;
          setState(() {
            _isOtherUserTyping = isTyping;
          });
          debugPrint('👤 Other user typing: $isTyping');
        }
      },
    );
  }

  // Handle typing indicator when user types
  void _handleTypingIndicator() {
    if (widget.chat.id.isEmpty) return;

    final hasText = _messageController.text.trim().isNotEmpty;

    // If user started typing
    if (hasText && !_isCurrentlyTyping) {
      _isCurrentlyTyping = true;
      _sendTypingStatus(true);
    }

    // Reset timer
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isCurrentlyTyping) {
        _isCurrentlyTyping = false;
        _sendTypingStatus(false);
      }
    });
  }

  // Send typing status via cubit
  void _sendTypingStatus(bool isTyping) {
    if (_chatCubit == null) return;
    final petId = widget.chat.id.isEmpty ? widget.chat.matingId : widget.chat.petId;
    
    // ignore: unnecessary_null_comparison
    if (petId != null && widget.chat.id.isNotEmpty) {
      // Send to Conversation Hub (for in-chat typing)
      _chatCubit!.sendTypingStatus(
        conversationId: widget.chat.id,
        petId: petId,
        isTyping: isTyping,
      );

      // Also send to General Hub (for chat list typing indicator)
      final otherPetId = widget.chat.petId;
      _signalRService.setTypingIndicator(
        toPetId: otherPetId,
        isTyping: isTyping,
      );
    }
  }

  ChatStatus _getChatStatus() {
    if (_isBlocked) return ChatStatus.blocked;
    if (isCompleted) return ChatStatus.completed;
    if (_isMatingStarted) return ChatStatus.onMating;
    return ChatStatus.active;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => sl<ChatMessagesCubit>()..loadMessages(widget.chat.id),
      child: BlocConsumer<ChatMessagesCubit, ChatMessagesState>(
        listener: (context, state) {
          final cubit = ChatMessagesCubit.get(context);
          _chatCubit = cubit;

          if (state is MessageSent) {
            final lastIndex = cubit.messagesList.length - 1;
            if (lastIndex >= 0) {
              try {
                _itemScrollController.jumpTo(index: lastIndex);
              } catch (_) {}
            }
            _animationController.forward().then(
              (_) => _animationController.reverse(),
            );
          } else if (state is MessageSendError) {
            errorToast(context, state.message);
          }
          if (state is ChatMessagesLoaded) {
            final messages = cubit.messagesList.toList();
            if (messages.isNotEmpty) {
              final lastIndex = messages.length - 1;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                try {
                  _itemScrollController.jumpTo(index: lastIndex);
                } catch (_) {}
              });
            }
          }
          if (state is MatingFinishSuccess) {
            setState(() {
              isCompleted = true;
              _isReadOnly = true;
            });
          }
          if (state is RenameChatError) {
            errorToast(context, state.message);
          }
          if (state is BlockChatError) {
            errorToast(context, state.message);
          }
          if (state is BlockChatSuccess) {
            setState(() {
              _isBlocked = !_isBlocked;
              if (_isBlocked) {
                _isBlockedByMe = true;
                _isBlockedByOther = false;
              } else {
                _isBlockedByMe = false;
                _isBlockedByOther = false;
              }
              _isReadOnly = _isBlocked;
            });
          }
          if (state is TypingStatusChanged) {
            setState(() {
              _isOtherUserTyping = state.isTyping;
            });
          }
        },
        builder: (context, state) {
          final cubit = ChatMessagesCubit.get(context);

          return Scaffold(
            backgroundColor:
                isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
            appBar: ChatAppBar(chat: widget.chat, cubit: cubit),
            body: Stack(
              children: [
                Column(
                  children: [
                    const SignalRConnectionStatusWidget(),
                    if (isCompleted)
                      _buildStatusBanner(
                        theme,
                        isDark,
                        Icons.lock_rounded,
                        s.chatArchivedReadOnly,
                        const Color(0xFF6C63FF),
                      ),
                    if (_isBlockedByMe)
                      _buildStatusBanner(
                        theme,
                        isDark,
                        Icons.block_rounded,
                        s.chatBlockedNoMessages,
                        Colors.red,
                      ),
                    if (_isBlockedByOther)
                      _buildStatusBanner(
                        theme,
                        isDark,
                        Icons.block_rounded,
                        '${widget.chat.name} ${s.chatBlockedByOther}',
                        Colors.red,
                      ),
                    Expanded(
                      child: _buildMessages(
                        state,
                        context,
                        theme,
                        isDark,
                        s,
                        cubit,
                      ),
                    ),
                    if (!_isReadOnly)
                      _buildMessageInput(cubit, context, theme, s),
                  ],
                ),
                // Recording overlay
                if (_isRecording)
                  _buildRecordingOverlay(isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBanner(
    ThemeData theme,
    bool isDark,
    IconData icon,
    String text,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withOpacity(isDark ? 0.2 : 0.1),
            accentColor.withOpacity(isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(
    ChatMessagesState state,
    BuildContext context,
    ThemeData theme,
    bool isDark,
    S s,
    ChatMessagesCubit cubit,
  ) {
    if (state is ChatMessagesLoading) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.primaryColor.withOpacity(0.1),
                ColorManager.primaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const CircularProgressIndicator(),
        ),
      );
    }
    if (state is ChatMessagesError) {
      return _buildErrorState(context, theme, isDark, s, state.message);
    }
    if (cubit.messagesList.isNotEmpty) {
      return _buildMessagesList(
        cubit.messagesList.toList(),
        context,
        theme,
        isDark,
      );
    }
    return _buildEmptyState(theme, isDark, s);
  }

  Widget _buildErrorState(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    S s,
    String message,
  ) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ]
                        : [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
                        ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildModernButton(
                  s.retry,
                  Icons.refresh_rounded,
                  () => ChatMessagesCubit.get(
                    context,
                  ).loadMessages(widget.chat.id),
                  theme,
                  isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(
    List<MessageEntity> messages,
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    if (messages.isEmpty && _uploadingFiles.isEmpty) return _buildEmptyState(theme, isDark, S.of(context));

    final totalItems = messages.length + _uploadingFiles.length;

    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: isDark ? 0.03 : 0.05,
            child: CustomPaint(
              painter: _ChatBackgroundPainter(color: theme.colorScheme.primary),
            ),
          ),
        ),
        ScrollablePositionedList.builder(
          itemScrollController: _itemScrollController,
          itemPositionsListener: _itemPositionsListener,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: totalItems,
          itemBuilder: (_, index) {
            if (index < messages.length) {
              final message = messages[index];
              final showDateDivider =
                  index == 0 ||
                  !_isSameDay(messages[index - 1].createdAt, message.createdAt);

              return Column(
                children: [
                  if (showDateDivider)
                    _buildDateDivider(message.createdAt, theme, isDark),
                  ChatMessageBubble(
                    message: message,
                    isMe: !message.toMe,
                    conversationId: widget.chat.id,
                  ),
                ],
              );
            } else {
              final uploadIndex = index - messages.length;
              return _buildUploadingBubble(_uploadingFiles[uploadIndex], theme, isDark);
            }
          },
        ),
        if (_isOtherUserTyping)
          Positioned(
            bottom: 8,
            left: 16,
            child: _buildTypingIndicator(theme, isDark),
          ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildDateDivider(DateTime date, ThemeData theme, bool isDark) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    String dateText;
    if (_isSameDay(date, now)) {
      dateText = 'Today';
    } else if (_isSameDay(date, yesterday)) {
      dateText = 'Yesterday';
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                dateText,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark, S s) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ]
                        : [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
                        ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorManager.primaryColor.withOpacity(0.2),
                        ColorManager.primaryColor.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 60,
                    color: ColorManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).noMessagesYet,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).startConversation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(
    ChatMessagesCubit cubit,
    BuildContext context,
    ThemeData theme,
    S localizations,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final bottomSystemPadding = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSystemPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: localizations.typeMessage,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.4,
                              ),
                            ),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.attach_file_rounded,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          size: 22,
                        ),
                        onPressed: () {
                          final chatCubit = context.read<ChatMessagesCubit>();
                          final mainCubit = context.read<MainCubit>();

                          AttachmentOptionsBottomSheet.show(
                            context,
                            onAttachmentSelected: (file, type, {caption}) {
                              _handleAttachment(
                                file,
                                type,
                                chatCubit,
                                mainCubit,
                                caption: caption,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _hasText ? () => _sendMessage(cubit) : null,
                onLongPressStart: !_hasText ? (_) => _startRecording(cubit) : null,
                onLongPressEnd: !_hasText ? (_) => _stopRecording(cubit) : null,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _hasText ? Icons.send_rounded : Icons.mic,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    ThemeData theme,
    bool isDark,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _handleAttachment(
    File file,
    AttachmentType type,
    ChatMessagesCubit cubit,
    MainCubit mainCubit, {
    String? caption,
  }) async {
    final uploadId = DateTime.now().millisecondsSinceEpoch.toString();
    
    setState(() {
      _uploadingFiles.add(_UploadingMedia(
        id: uploadId,
        file: file,
        type: type,
        caption: caption ?? '',
      ));
    });

    try {
      String? mediaUrl;

      if (type == AttachmentType.image) {
        await mainCubit.getGlobalImage(file, UploadPlace.messageImage);
        mediaUrl = mainCubit.modelImage?.data;
      } else if (type == AttachmentType.video) {
        await mainCubit.getGlobalVideo(file, UploadPlace.messageVideo);
        mediaUrl = mainCubit.modelImage?.data;
      } else if (type == AttachmentType.audio) {
        await mainCubit.getGlobalSound(file, UploadPlace.messageRecord);
        mediaUrl = mainCubit.modelImage?.data;
      }

      setState(() {
        _uploadingFiles.removeWhere((item) => item.id == uploadId);
      });

      if (mediaUrl != null && mediaUrl.isNotEmpty) {
        final fromPetId = widget.chat.id.isEmpty ? widget.chat.matingId : null;
        final toPetId = widget.chat.id.isEmpty ? widget.chat.petId : null;
        final currentUserId = CacheHelper.getData('clintId') ?? '';
        String? fromUserId;
        String? toUserId;

        if (widget.chat.lastMessage != null) {
          if (widget.chat.lastMessage!.toMe) {
            fromUserId = widget.chat.lastMessage!.toUserId;
            toUserId = widget.chat.lastMessage!.fromUserId;
          } else {
            fromUserId = widget.chat.lastMessage!.fromUserId;
            toUserId = widget.chat.lastMessage!.toUserId;
          }
        } else {
          fromUserId = currentUserId;
          toUserId = widget.chat.petId;
        }

        cubit.sendMessage(
          chatId: widget.chat.id,
          text: caption ?? '',
          isMe: true,
          fromPetId: fromPetId,
          toPetId: toPetId,
          fromUserId: fromUserId,
          toUserId: toUserId,
          image: type == AttachmentType.image ? mediaUrl : null,
          video: type == AttachmentType.video ? mediaUrl : null,
          audio: type == AttachmentType.audio ? mediaUrl : null,
        );
      } else {
        if (mounted) errorToast(context, 'Upload failed');
      }
    } catch (e) {
      setState(() {
        _uploadingFiles.removeWhere((item) => item.id == uploadId);
      });
      if (mounted) errorToast(context, 'Failed to send');
    }
  }

  Future<void> _startRecording(ChatMessagesCubit cubit) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(const RecordConfig(), path: path);
        
        setState(() {
          _isRecording = true;
          _recordDuration = 0;
          _recordingCubit = cubit; 
        });

        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordDuration++;
          });
          
          // Auto-stop at max duration
          if (_recordDuration >= _maxRecordDuration && _recordingCubit != null) {
            _stopRecording(_recordingCubit!);
          }
        });
      }
    } catch (e) {
      debugPrint('❌ Error starting recording: $e');
    }
  }

  Future<void> _stopRecording(ChatMessagesCubit cubit) async {
    try {
      _recordTimer?.cancel();
      final path = await _audioRecorder.stop();
      
      setState(() {
        _isRecording = false;
      });

      if (path != null && path.isNotEmpty) {
        final file = File(path);
        if (await file.exists()) {
          final mainCubit = context.read<MainCubit>();
          _handleAttachment(file, AttachmentType.audio, cubit, mainCubit);
        }
      }
      
      setState(() {
        _recordDuration = 0;
      });
    } catch (e) {
      debugPrint('❌ Error stopping recording: $e');
      setState(() {
        _isRecording = false;
        _recordDuration = 0;
      });
    }
  }

  void _sendMessage(ChatMessagesCubit cubit) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final fromPetId = widget.chat.id.isEmpty ? widget.chat.matingId : null;
    final toPetId = widget.chat.id.isEmpty ? widget.chat.petId : null;
    final currentUserId = CacheHelper.getData('clintId') ?? '';
    String? fromUserId;
    String? toUserId;

    if (widget.chat.lastMessage != null) {
      if (widget.chat.lastMessage!.toMe) {
        fromUserId = widget.chat.lastMessage!.toUserId;
        toUserId = widget.chat.lastMessage!.fromUserId;
      } else {
        fromUserId = widget.chat.lastMessage!.fromUserId;
        toUserId = widget.chat.lastMessage!.toUserId;
      }
    } else {
      fromUserId = currentUserId;
      toUserId = widget.chat.petId;
    }

    cubit.sendMessage(
      chatId: widget.chat.id,
      text: text,
      isMe: true,
      fromPetId: fromPetId,
      toPetId: toPetId,
      fromUserId: fromUserId,
      toUserId: toUserId,
    );
    _messageController.clear();
  }

  Widget _buildRecordingOverlay(bool isDark) {
    final minutes = (_recordDuration ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordDuration % 60).toString().padLeft(2, '0');
    final isNearLimit = _recordDuration >= _maxRecordDuration - 10; // Last 10 seconds
    
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isNearLimit ? Colors.orange : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$minutes:$seconds',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isNearLimit 
                    ? Colors.orange 
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: List.generate(
                  20,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      width: 3,
                      height: 12 + (index % 3) * 8,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              '< Recording Now',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadingBubble(_UploadingMedia upload, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.7),
                    theme.colorScheme.primary.withOpacity(0.5),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (upload.type == AttachmentType.image)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.file(upload.file, width: 220, height: 160, fit: BoxFit.cover),
                          Positioned.fill(
                            child: Container(
                              color: Colors.black38,
                              child: Center(
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (upload.type == AttachmentType.video)
                    Container(
                      width: 220,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam, color: Colors.white, size: 40),
                          SizedBox(height: 8),
                          CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                          SizedBox(height: 8),
                          Text('Uploading video...', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  if (upload.type == AttachmentType.audio)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.mic, color: Colors.white, size: 24),
                          SizedBox(width: 12),
                          CircularProgressIndicator(color: Colors.white, strokeWidth: 2, strokeCap: StrokeCap.round),
                          SizedBox(width: 12),
                          Text('Uploading...', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  if (upload.caption.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(upload.caption, style: TextStyle(color: Colors.white)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TypingDot(delay: 0),
          const SizedBox(width: 4),
          _TypingDot(delay: 200),
          const SizedBox(width: 4),
          _TypingDot(delay: 400),
        ],
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }
}

class _UploadingMedia {
  final String id;
  final File file;
  final AttachmentType type;
  final String caption;

  _UploadingMedia({
    required this.id,
    required this.file,
    required this.type,
    required this.caption,
  });
}

class _ChatBackgroundPainter extends CustomPainter {
  final Color color;

  _ChatBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    const spacing = 30.0;
    const iconSize = 20.0;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        _drawPawPrint(canvas, paint, x, y, iconSize);
      }
    }
  }

  void _drawPawPrint(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double size,
  ) {
    canvas.drawCircle(Offset(x, y + size * 0.3), size * 0.2, paint);
    canvas.drawCircle(Offset(x, y), size * 0.12, paint);
    canvas.drawCircle(
      Offset(x - size * 0.22, y + size * 0.12),
      size * 0.12,
      paint,
    );
    canvas.drawCircle(
      Offset(x + size * 0.22, y + size * 0.12),
      size * 0.12,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
