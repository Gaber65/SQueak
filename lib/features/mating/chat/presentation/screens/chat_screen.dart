import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:squeak/core/signalr/signalr_connection_status_widget.dart';
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

  bool _isReadOnly = false;
  bool _isMatingStarted = false;
  bool isCompleted = false;
  bool _isBlocked = false;
  bool _isBlockedByMe = false;
  bool _isBlockedByOther = false;

  bool _isUploadingMedia = false;
  File? _uploadingFile;
  AttachmentType? _uploadingType;

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

    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
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
  }

  @override
  void dispose() {
    _messageController.dispose();
    _animationController.dispose();
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
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

          if (state is MessageSent) {
            _messageController.clear();
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
                // WhatsApp-style upload loading overlay
                if (_isUploadingMedia && _uploadingFile != null)
                  _buildUploadingOverlay(isDark),
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
    if (messages.isEmpty) return _buildEmptyState(theme, isDark, S.of(context));

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
          itemCount: messages.length,
          itemBuilder: (_, index) {
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
          },
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
              BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
                builder: (_, state) {
                  final isSending = state is MessageSending;
                  final showMic = !_hasText && !isSending;
                  
                  return GestureDetector(
                    onTap: showMic ? null : (isSending ? null : () => _sendMessage(cubit)),
                    onLongPressStart: showMic ? (_) => _startRecording(cubit) : null,
                    onLongPressEnd: showMic ? (_) => _stopRecording(cubit) : null,
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
                      child: Center(
                        child:
                            isSending
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Icon(
                                  showMic ? Icons.mic : Icons.send_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                      ),
                    ),
                  );
                },
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

  Widget _buildUploadingOverlay(bool isDark) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.85),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            margin: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_uploadingType == AttachmentType.image ||
                    _uploadingType == AttachmentType.video)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Image.file(
                          _uploadingFile!,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_uploadingType == AttachmentType.audio)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF9800).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.audiotrack_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF6200EA),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _uploadingType == AttachmentType.image
                            ? 'Uploading image...'
                            : _uploadingType == AttachmentType.video
                            ? 'Uploading video...'
                            : 'Uploading audio...',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    debugPrint(
      '📎 ChatScreen: Starting attachment upload - Type: $type, Caption: "${caption ?? '(no caption)'}"',
    );

    setState(() {
      _isUploadingMedia = true;
      _uploadingFile = file;
      _uploadingType = type;
    });

    try {
      String? mediaUrl;

      if (type == AttachmentType.image) {
        debugPrint('⬆️  ChatScreen: Uploading image to server...');
        await mainCubit.getGlobalImage(file, UploadPlace.messageImage);
        mediaUrl = mainCubit.modelImage?.data;
        debugPrint(
          '✅ ChatScreen: Image uploaded - modelImage: ${mainCubit.modelImage}, URL: $mediaUrl',
        );
      } else if (type == AttachmentType.video) {
        debugPrint('⬆️  ChatScreen: Uploading video to server...');
        await mainCubit.getGlobalVideo(file, UploadPlace.messageVideo);
        final videoData = mainCubit.modelImage?.data;

        mediaUrl = videoData;
        debugPrint('✅ ChatScreen: Video uploaded - filename: $mediaUrl');
      } else if (type == AttachmentType.audio) {
        debugPrint('⬆️  ChatScreen: Uploading audio to server...');
        await mainCubit.getGlobalSound(file, UploadPlace.messageRecord);
        final audioData = mainCubit.modelImage?.data;

        mediaUrl = audioData;
        debugPrint('✅ ChatScreen: Audio uploaded - filename: $mediaUrl');
      }

      if (mediaUrl != null && mediaUrl.isNotEmpty) {
        final text = caption ?? '';
        debugPrint(
          '💬 ChatScreen: Preparing to send message with media URL and caption',
        );

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

        debugPrint(
          '📤 ChatScreen: Sending message - Type: $type, Media URL: $mediaUrl, Caption: "$text"',
        );
        cubit.sendMessage(
          chatId: widget.chat.id,
          text: text,
          isMe: true,
          fromPetId: fromPetId,
          toPetId: toPetId,
          fromUserId: fromUserId,
          toUserId: toUserId,
          image: type == AttachmentType.image ? mediaUrl : null,
          video: type == AttachmentType.video ? mediaUrl : null,
          audio: type == AttachmentType.audio ? mediaUrl : null,
        );
        debugPrint(
          '✅ ChatScreen: Message sent successfully with media attachment',
        );
      } else {
        debugPrint(
          '❌ ChatScreen: Media URL is null or empty, cannot send message',
        );
        if (mounted) {
          errorToast(context, 'Failed to upload media. Please try again.');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ ChatScreen: Error uploading attachment: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        errorToast(context, 'Failed to send attachment');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingMedia = false;
          _uploadingFile = null;
          _uploadingType = null;
        });
      }
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
