import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:squeak/core/signalr/signalr_connection_status_widget.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_status.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_app_bar.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attachment_options_bottom_sheet.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/status_banner.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_empty_state.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_error_state.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_loading_state.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/messages_list.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/message_input_widget.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/recording_overlay.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/uploading_bubble.dart';
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
  // final SignalRService _signalRService = SignalRService();

  bool _isReadOnly = false;
  bool _isMatingStarted = false;
  bool isCompleted = false;
  bool _isBlocked = false;
  bool _isBlockedByMe = false;
  bool _isBlockedByOther = false;

  // Track uploading files to show in chat
  final List<UploadingMedia> _uploadingFiles = [];

  // Typing indicator
  bool _isOtherUserTyping = false;
  Timer? _typingTimer;

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
    // _connectToConversationHub();

    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
      // _handleTypingIndicator();
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
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   _setupTypingListener();
    // });
  }

  @override
  void dispose() {
    // _disconnectFromConversationHub();
    _messageController.dispose();
    _animationController.dispose();
    _recordTimer?.cancel();
    _typingTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  // Connect to Conversation Hub for real-time chat messages
  // Future<void> _connectToConversationHub() async {
  //   try {
  //     await _signalRService.connectToConversationHub();

  //     // Mark messages as read when opening chat
  //     if (widget.chat.id.isNotEmpty) {
  //       final petId = widget.chat.petId;
  //       if (petId.isNotEmpty) {
  //         await _signalRService.markMessagesAsRead(widget.chat.id, petId);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('❌ Failed to connect to Conversation Hub: $e');
  //   }
  // }

  // Disconnect from Conversation Hub
  // Future<void> _disconnectFromConversationHub() async {
  //   try {
  //     await _signalRService.disconnectFromConversationHub();
  //   } catch (e) {
  //     debugPrint('❌ Failed to disconnect from Conversation Hub: $e');
  //   }
  // }

  // // Setup SignalR listener for typing status
  // void _setupTypingListener() {
  //   _signalRService.onConversationMessageReceived('FriendIsTyping', (
  //     arguments,
  //   ) {
  //     if (arguments != null && arguments.isNotEmpty && mounted) {
  //       final isTyping = arguments[0] as bool? ?? false;
  //       setState(() {
  //         _isOtherUserTyping = isTyping;
  //       });
  //       debugPrint('👤 Other user typing: $isTyping');
  //     }
  //   });
  // }

  // // Handle typing indicator when user types
  // void _handleTypingIndicator() {
  //   if (widget.chat.id.isEmpty) return;

  //   final hasText = _messageController.text.trim().isNotEmpty;

  //   // If user started typing
  //   if (hasText && !_isCurrentlyTyping) {
  //     _isCurrentlyTyping = true;
  //     _sendTypingStatus(true);
  //   }

  //   // Reset timer
  //   _typingTimer?.cancel();
  //   _typingTimer = Timer(const Duration(seconds: 2), () {
  //     if (_isCurrentlyTyping) {
  //       _isCurrentlyTyping = false;
  //       _sendTypingStatus(false);
  //     }
  //   });
  // }

  // // Send typing status via cubit
  // void _sendTypingStatus(bool isTyping) {
  //   if (_chatCubit == null) return;
  //   final petId =
  //       widget.chat.id.isEmpty ? widget.chat.matingId : widget.chat.petId;

  //   // ignore: unnecessary_null_comparison
  //   if (petId != null && widget.chat.id.isNotEmpty) {
  //     // Send to Conversation Hub (for in-chat typing)
  //     // _chatCubit!.sendTypingStatus(
  //     //   conversationId: widget.chat.id,
  //     //   petId: petId,
  //     //   isTyping: isTyping,
  //     // );

  //     // Also send to General Hub (for chat list typing indicator)
  //     final otherPetId = widget.chat.petId;
  //     _signalRService.setTypingIndicator(
  //       toPetId: otherPetId,
  //       isTyping: isTyping,
  //     );
  //   }
  // }

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
                      StatusBanner(
                        icon: Icons.lock_rounded,
                        text: s.chatArchivedReadOnly,
                        accentColor: const Color(0xFF6C63FF),
                      ),
                    if (_isBlockedByMe)
                      StatusBanner(
                        icon: Icons.block_rounded,
                        text: s.chatBlockedNoMessages,
                        accentColor: Colors.red,
                      ),
                    if (_isBlockedByOther)
                      StatusBanner(
                        icon: Icons.block_rounded,
                        text: '${widget.chat.name} ${s.chatBlockedByOther}',
                        accentColor: Colors.red,
                      ),
                    Expanded(child: _buildMessages(state, cubit)),
                    if (!_isReadOnly)
                      MessageInputWidget(
                        messageController: _messageController,
                        chat: widget.chat,
                        hasText: _hasText,
                        onSendMessage: () => _sendMessage(cubit),
                        onStartRecording: () => _startRecording(cubit),
                        onStopRecording: () => _stopRecording(cubit),
                        onAttachmentSelected: (file, type) {
                          final mainCubit = context.read<MainCubit>();
                          _handleAttachment(file, type, cubit, mainCubit);
                        },
                      ),
                  ],
                ),
                // Recording overlay
                if (_isRecording)
                  RecordingOverlay(
                    recordDuration: _recordDuration,
                    maxRecordDuration: _maxRecordDuration,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessages(ChatMessagesState state, ChatMessagesCubit cubit) {
    if (state is ChatMessagesLoading) {
      return const ChatLoadingState();
    }
    if (state is ChatMessagesError) {
      return ChatErrorState(
        message: state.message,
        onRetry: () => cubit.loadMessages(widget.chat.id),
      );
    }
    if (cubit.messagesList.isNotEmpty || _uploadingFiles.isNotEmpty) {
      return MessagesList(
        messages: cubit.messagesList.toList(),
        uploadingFiles: _uploadingFiles,
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        conversationId: widget.chat.id,
        isOtherUserTyping: _isOtherUserTyping,
      );
    }
    return const ChatEmptyState();
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
      _uploadingFiles.add(
        UploadingMedia(
          id: uploadId,
          file: file,
          type: type,
          caption: caption ?? '',
        ),
      );
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
        final path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

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
          if (_recordDuration >= _maxRecordDuration &&
              _recordingCubit != null) {
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
}
