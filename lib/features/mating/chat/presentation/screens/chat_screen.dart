// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_status.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_widgets/chat_app_bar.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/attachment_options_bottom_sheet.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/status_banner.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_widgets/chat_empty_state.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_widgets/chat_error_state.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_widgets/chat_loading_state.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/message_widgets/messages_list.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/message_widgets/message_input_widget.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/recording_overlay.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/message_widgets/uploading_bubble.dart';
import 'package:squeak/core/service/signalr/signalr_conversation_services.dart';
import 'package:squeak/features/mating/chat/domain/entities/message_entity.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../../pets/domain/entities/pet_entity.dart';
import '../controllers/chat_messages_state.dart';
import '../controllers/chat_app_cubit.dart';
import '../controllers/chat_app_state.dart';

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
  final List<UploadingMedia> _uploadingFiles = [];
  bool _isOtherUserTyping = false;
  bool _isFriendInConversation = false;
  bool _isLoadingMore = false;
  int? _firstVisibleIndexBeforeLoad;
  int _oldMessagesLengthBeforeLoad = 0;
  Timer? _typingTimer;
  int _incomingTypingEventCount = 0;
  Timer? _incomingTypingResetTimer;
  Timer? _incomingTypingHideTimer;

  // Recording variables
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  int _recordDuration = 0;
  Timer? _recordTimer;
  bool _hasText = false;
  static const int _maxRecordDuration = 120;
  ChatMessagesCubit? _recordingCubit;
  ChatAppCubit? _recordingChatAppCubit;
  ChatAppCubit? _chatAppCubit;
  static const double maxMediaSizeMB = 25.0;

  @override
  void initState() {
    super.initState();

    _messageController.addListener(() {
      final hasText = _messageController.text.trim().isNotEmpty;
      setState(() {
        _hasText = hasText;
      });
      _handleTypingIndicator(hasText);
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
    _typingTimer?.cancel();
    _incomingTypingResetTimer?.cancel();
    _incomingTypingHideTimer?.cancel();

    if (_chatAppCubit != null) {
      try {
        _chatAppCubit!.setTyping(
          conversationId: widget.chat.id,
          isTyping: false,
        );
        try {
          _chatAppCubit!.setTypingInGeneral(
            petId: widget.chat.petId,
            isTyping: false,
            fromPetId: widget.pet?.petId ?? '',
          );
        } catch (_) {}
        conversationSignalEventStream.add(
          ConversationSignalEvent('ConversationHub', 'PetLeftConversation', [
            {'ConversationId': widget.chat.id, 'PetId': widget.pet?.petId},
          ]),
        );
        _chatAppCubit!.leaveConversation();
      } catch (e) {}
    }
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

  void _handleTypingIndicator(bool isTyping) {
    _typingTimer?.cancel();

    if (isTyping) {
      if (mounted) {
        try {
          context.read<ChatAppCubit>().setTyping(
            conversationId: widget.chat.id,
            isTyping: true,
          );
          context.read<ChatAppCubit>().setTypingInGeneral(
            petId: widget.chat.petId,
            isTyping: true,
            fromPetId: widget.pet?.petId ?? '',
          );
        } catch (_) {}
      }

      // Set timer to send typing=false after 2 seconds of inactivity
      _typingTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          try {
            context.read<ChatAppCubit>().setTyping(
              conversationId: widget.chat.id,
              isTyping: false,
            );
            context.read<ChatAppCubit>().setTypingInGeneral(
              petId: widget.chat.petId,
              isTyping: false,
              fromPetId: widget.pet?.petId ?? '',
            );
          } catch (_) {
            // Provider not available yet
          }
        }
      });
    } else {
      // Send typing=false immediately when text is cleared
      if (mounted) {
        try {
          context.read<ChatAppCubit>().setTyping(
            conversationId: widget.chat.id,
            isTyping: false,
          );
          try {
            context.read<ChatAppCubit>().setTypingInGeneral(
              petId: widget.chat.petId,
              isTyping: false,
              fromPetId: widget.pet?.petId ?? '',
            );
          } catch (_) {}
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  sl<ChatMessagesCubit>()
                    ..loadMessages(widget.chat.id, widget.pet!.petId!),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChatAppCubit, ChatAppState>(
            listener: (context, state) {
              if (state is ConversationJoined) {}

              if (state is MessageReceived &&
                  state.conversationId == widget.chat.id) {
                final cubit = ChatMessagesCubit.get(context);
                final messageId = state.message.id;
                final alreadyExists =
                    messageId != null &&
                    cubit.messagesList.any((m) {
                      return m.id == messageId;
                    });
                if (!alreadyExists) {
                  cubit.addReceivedMessage(state.message, widget.pet!.ownerId);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    final lastIndex =
                        ChatMessagesCubit.get(context).messagesList.length - 1;
                    if (lastIndex >= 0) {
                      try {
                        _itemScrollController.jumpTo(index: lastIndex);
                      } catch (_) {}
                    }
                  });
                }
              }
              if (state is FriendTypingInConversation &&
                  state.conversationId == widget.chat.id) {
                if (state.isTyping) {
                  _incomingTypingEventCount++;
                  _incomingTypingResetTimer?.cancel();
                  _incomingTypingResetTimer = Timer(
                    const Duration(milliseconds: 800),
                    () {
                      _incomingTypingEventCount = 0;
                    },
                  );
                  if (_incomingTypingEventCount >= 2) {
                    _incomingTypingHideTimer?.cancel();
                    _incomingTypingHideTimer = Timer(
                      const Duration(seconds: 2),
                      () {
                        if (mounted) {
                          setState(() {
                            _isOtherUserTyping = false;
                          });
                        }
                      },
                    );

                    if (mounted && !_isOtherUserTyping) {
                      setState(() {
                        _isOtherUserTyping = true;
                      });
                    }
                  }
                } else {
                  _incomingTypingResetTimer?.cancel();
                  _incomingTypingEventCount = 0;
                  _incomingTypingHideTimer?.cancel();
                  if (mounted && _isOtherUserTyping) {
                    setState(() {
                      _isOtherUserTyping = false;
                    });
                  }
                }
              }

              if (state is PetJoinedConversation) {
                final data = state.data;
                final joinedPetId =
                    data['petId']?.toString() ?? data['PetId']?.toString();
                if (joinedPetId != null && joinedPetId == widget.chat.petId) {
                  try {
                    ChatMessagesCubit.get(context).markOutgoingMessagesAsRead();
                  } catch (e) {}
                  if (mounted) {
                    setState(() {
                      _isFriendInConversation = true;
                    });
                  }
                }
              }
              if (state is PetLeftConversation) {
                final data = state.data;
                final leftPetId = data['petId']?.toString();
                final leftConversationId = data['conversationId']?.toString();
                if (leftPetId == widget.chat.petId ||
                    leftConversationId == widget.chat.id) {
                  if (mounted) {
                    setState(() {
                      _isOtherUserTyping = false;
                      _isFriendInConversation = false;
                    });
                  }
                }
              }
              if (state is ChatAppError) {
                debugPrint('❌ ChatAppCubit Error: ${state.message}');
                if (mounted) {
                  errorToast(context, state.message);
                }
              }
              if (state is FriendOnlineStatusChanged) {
                if (state.petId == widget.chat.petId && state.isOnline) {
                  ChatMessagesCubit.get(context).markSentMessagesAsDelivered();
                }
              }
            },
          ),
          BlocListener<ChatMessagesCubit, ChatMessagesState>(
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    try {
                      if (_isLoadingMore) {
                        final newLength = cubit.messagesList.length;
                        final added = newLength - _oldMessagesLengthBeforeLoad;
                        final firstBefore = _firstVisibleIndexBeforeLoad ?? 0;
                        int targetIndex = (firstBefore + (added > 0 ? added : 0)).toInt();
                        if (targetIndex < 0) targetIndex = 0;
                        if (targetIndex > newLength - 1) targetIndex = newLength - 1;
                        _itemScrollController.jumpTo(index: targetIndex);
                      } else {
                        final lastIndex = messages.length - 1;
                        _itemScrollController.jumpTo(index: lastIndex);
                      }
                    } catch (_) {}
                    _isLoadingMore = false;
                    _firstVisibleIndexBeforeLoad = null;
                    _oldMessagesLengthBeforeLoad = 0;
                  });
                }
                _joinConversationAfterLoad();
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
          ),
        ],
        child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
          builder: (context, state) {
            final cubit = ChatMessagesCubit.get(context);

            return BlocBuilder<ChatAppCubit, ChatAppState>(
              buildWhen: (previous, current) {
                // Rebuild when online status or typing status changes
                return current is FriendOnlineStatusChanged ||
                    current is FriendTypingInConversation ||
                    current is PetLeftConversation ||
                    current is ChatAppConnected;
              },
              builder: (context, chatAppState) {
                final chatAppCubit = context.read<ChatAppCubit>();

                return Scaffold(
                  backgroundColor:
                      isDark
                          ? const Color(0xFF121212)
                          : const Color(0xFFF5F5F5),
                  appBar: ChatAppBar(
                    chat: widget.chat,
                    cubit: cubit,
                    isOnline: chatAppCubit.generalHub.isPetOnlineFromDict(
                      widget.chat.petId,
                    ),
                    isTyping:
                        chatAppCubit.typingIndicators[widget.chat.petId] ??
                        false,
                  ),
                  body: Stack(
                    children: [
                      Column(
                        children: [
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
                              text:
                                  '${widget.chat.name} ${s.chatBlockedByOther}',
                              accentColor: Colors.red,
                            ),
                          Expanded(child: _buildMessages(state, cubit)),
                          if (!_isReadOnly)
                            MessageInputWidget(
                              messageController: _messageController,
                              chat: widget.chat,
                              hasText: _hasText,
                              onSendMessage:
                                  () => _sendMessage(cubit, chatAppCubit),
                              onStartRecording:
                                  () => _startRecording(cubit, chatAppCubit),
                              onStopRecording:
                                  () => _stopRecording(cubit, chatAppCubit),
                              onAttachmentSelected: (files, type, {caption}) {
                                final mainCubit = context.read<MainCubit>();
                                _handleAttachments(
                                  files,
                                  type,
                                  cubit,
                                  mainCubit,
                                  chatAppCubit,
                                  caption: caption,
                                );
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
            );
          },
        ),
      ),
    );
  }

  // NEW METHOD: Join conversation and mark messages as read after successful load
  Future<void> _joinConversationAfterLoad() async {
    if (!mounted) return;

    try {
      _chatAppCubit = context.read<ChatAppCubit>();
      await _chatAppCubit?.joinConversation(widget.chat.id);

      conversationSignalEventStream.add(
        ConversationSignalEvent(
          'ConversationHub',
          'PetIsJoinedToConversation',
          [
            {'ConversationId': widget.chat.id, 'PetId': widget.pet?.petId},
          ],
        ),
      );

      if (widget.pet?.petId != null && mounted) {
        await _chatAppCubit?.conversationHub.markMessagesAsSeen(
          conversationId: widget.chat.id,
          petId: widget.pet!.petId!,
        );
      }
    } catch (e) {}
  }

  Widget _buildMessages(ChatMessagesState state, ChatMessagesCubit cubit) {
    if (state is ChatMessagesLoading || state is ChatMessagesInitial) {
      return const ChatLoadingState();
    }
    if (state is ChatMessagesError) {
      return ChatErrorState(
        message: state.message,
        onRetry: () => cubit.loadMessages(widget.chat.id, widget.pet!.petId!),
      );
    }
    if (cubit.messagesList.isNotEmpty || _uploadingFiles.isNotEmpty) {
      return MessagesList(
        messages: cubit.messagesList.toList(),
        uploadingFiles: _uploadingFiles,
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        conversationId: widget.chat.id,
        chatImage: widget.chat.image,
        isOtherUserTyping: _isOtherUserTyping,
        hasMoreMessages: cubit.hasMoreMessages,
        isLoadingMore: cubit.isLoadingMore,
            onLoadMore: () {
              final positions = _itemPositionsListener.itemPositions.value;
              int firstIndex = 0;
              if (positions.isNotEmpty) {
                try {
                  firstIndex = positions.map((p) => p.index).reduce((a, b) => a < b ? a : b);
                } catch (_) {}
              }
              setState(() {
                _isLoadingMore = true;
                _firstVisibleIndexBeforeLoad = firstIndex;
                _oldMessagesLengthBeforeLoad = cubit.messagesList.length;
              });
              cubit.loadMoreMessages(widget.chat.id);
            },
      );
    }
    return const ChatEmptyState();
  }

  double _getFileSizeMB(File file) {
    try {
      return file.lengthSync() / (1024 * 1024);
    } catch (e) {
      return 0.0;
    }
  }

  bool _isFileSizeValid(File file, AttachmentType type) {
    final sizeMB = _getFileSizeMB(file);
    return sizeMB <= maxMediaSizeMB;
  }

  String _getFileSizeErrorMessage(File file, AttachmentType type) {
    final sizeMB = _getFileSizeMB(file);
    return 'File too large. Maximum size is ${maxMediaSizeMB.toInt()}MB. Current: ${sizeMB.toStringAsFixed(2)} MB';
  }

  void _handleAttachments(
    List<File> files,
    AttachmentType type,
    ChatMessagesCubit cubit,
    MainCubit mainCubit,
    ChatAppCubit chatAppCubit, {
    String? caption,
  }) {
    for (final file in files) {
      _handleAttachment(
        file,
        type,
        cubit,
        mainCubit,
        chatAppCubit,
        caption: caption,
      );
    }
  }

  void _handleAttachment(
    File file,
    AttachmentType type,
    ChatMessagesCubit cubit,
    MainCubit mainCubit,
    ChatAppCubit chatAppCubit, {
    String? caption,
  }) async {
    if (!_isFileSizeValid(file, type)) {
      if (mounted) {
        final errorMessage = _getFileSizeErrorMessage(file, type);
        errorToast(context, errorMessage);
      }
      return;
    }

    final uploadId = DateTime.now().millisecondsSinceEpoch.toString();

    if (mounted) {
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
    }

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
      } else if (type == AttachmentType.file) {
        await mainCubit.getGlobalDocument(file, UploadPlace.messageFiles);
        mediaUrl = mainCubit.modelImage?.data;
      }

      if (mounted) {
        setState(() {
          _uploadingFiles.removeWhere((item) => item.id == uploadId);
        });
      }

      if (mediaUrl != null && mediaUrl.isNotEmpty) {
        debugPrint('📤 Sending media message: $mediaUrl');
        await chatAppCubit.sendMessage(
          conversationId: widget.chat.id,
          toPetId: widget.chat.petId,
          description: caption ?? '',
          image: type == AttachmentType.image ? mediaUrl : null,
          video: type == AttachmentType.video ? mediaUrl : null,
          audio: type == AttachmentType.audio ? mediaUrl : null,
          file: type == AttachmentType.file ? mediaUrl : null,
        );

        // Increase unread count with media type flags
        await chatAppCubit.increaseUnreadMessageCount(
          conversationId: widget.chat.id,
          toPetId: widget.chat.petId,
          fromPetId: widget.pet?.petId ?? '',
          content: caption ?? '',
          imageMessage: type == AttachmentType.image,
          videoMessage: type == AttachmentType.video,
          fileMessage: type == AttachmentType.file,
          audioMessage: type == AttachmentType.audio,
        );

        debugPrint('✅ Media message sent successfully');
      } else {
        debugPrint('❌ Upload failed: mediaUrl is null or empty');
        if (mounted) errorToast(context, 'Upload failed');
      }
    } catch (e) {
      debugPrint('❌ Error in _handleAttachment: $e');
      if (mounted) {
        setState(() {
          _uploadingFiles.removeWhere((item) => item.id == uploadId);
        });
      }
      if (mounted) errorToast(context, 'Failed to send: $e');
    }
  }

  Future<void> _startRecording(
    ChatMessagesCubit cubit,
    ChatAppCubit chatAppCubit,
  ) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(const RecordConfig(), path: path);

        if (mounted) {
          setState(() {
            _isRecording = true;
            _recordDuration = 0;
            _recordingCubit = cubit;
            _recordingChatAppCubit = chatAppCubit;
          });
        }

        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _recordDuration++;
            });
          }

          // Auto-stop at max duration
          if (_recordDuration >= _maxRecordDuration &&
              _recordingCubit != null &&
              _recordingChatAppCubit != null) {
            _stopRecording(_recordingCubit!, _recordingChatAppCubit!);
          }
        });
      }
    } catch (e) {
      debugPrint('❌ Error starting recording: $e');
    }
  }

  Future<void> _stopRecording(
    ChatMessagesCubit cubit,
    ChatAppCubit chatAppCubit,
  ) async {
    try {
      _recordTimer?.cancel();
      final path = await _audioRecorder.stop();

      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }

      if (path != null && path.isNotEmpty) {
        final file = File(path);
        if (await file.exists()) {
          // Check audio file size before processing
          if (!_isFileSizeValid(file, AttachmentType.audio)) {
            if (mounted) {
              final errorMessage = _getFileSizeErrorMessage(
                file,
                AttachmentType.audio,
              );
              errorToast(context, errorMessage);
            }
            // Delete the recorded file if it's too large
            try {
              await file.delete();
            } catch (e) {
              debugPrint('❌ Error deleting oversized audio file: $e');
            }
            return;
          }

          final mainCubit = context.read<MainCubit>();
          _handleAttachment(
            file,
            AttachmentType.audio,
            cubit,
            mainCubit,
            chatAppCubit,
          );
        }
      }

      if (mounted) {
        setState(() {
          _recordDuration = 0;
        });
      }
    } catch (e) {
      debugPrint('❌ Error stopping recording: $e');
      if (mounted) {
        setState(() {
          _isRecording = false;
          _recordDuration = 0;
        });
      }
    }
  }

  void _sendMessage(ChatMessagesCubit cubit, ChatAppCubit chatAppCubit) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Prevent sending messages longer than allowed
    if (text.length > MessageInputWidget.maxCharacters) {
      showDialog(
        context: context,
        builder:
            (c) => AlertDialog(
              title: const Text('Character Limit Reached'),
              content: Text(
                'Message cannot exceed ${MessageInputWidget.maxCharacters} characters. Current: ${text.length}',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(c).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    // Stop typing indicators
    chatAppCubit.setTyping(conversationId: widget.chat.id, isTyping: false);
    chatAppCubit.setTypingInGeneral(
      petId: widget.chat.petId,
      isTyping: false,
      fromPetId: widget.pet?.petId ?? '',
    );

    // Debug: log outgoing attempt
    try {
      debugPrint('➡️ Sending message locally: "$text" to ${widget.chat.petId}');
    } catch (_) {}

    // Add an optimistic outgoing message locally so sender sees it immediately
    final localMessage = MessageEntity(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      description: text,
      image: null,
      video: null,
      audio: null,
      file: null,
      fromUserId: widget.pet?.petId ?? '',
      toUserId: widget.chat.petId,
      createdAt: DateTime.now(),
      toMe: false,
    );
    if (_isFriendInConversation) {
      try {
        cubit.addOutgoingMessage(localMessage);
        try {
          debugPrint(
            '✅ Added local message id=${localMessage.id} currentCount=${cubit.messagesList.length}',
          );
        } catch (_) {}
      } catch (e) {
        debugPrint('❌ addOutgoingMessage error: $e');
      }
    } else {
      // Friend not in conversation: do not show optimistic local bubble
      try {
        debugPrint(
          'ℹ️ Friend not in conversation, skipping local optimistic message',
        );
      } catch (_) {}
    }

    // Scroll to show the new message
    Future.delayed(const Duration(milliseconds: 100), () {
      final lastIndex = cubit.messagesList.length - 1;
      if (lastIndex >= 0) {
        try {
          _itemScrollController.jumpTo(index: lastIndex);
        } catch (_) {}
      }
    });

    // Send to server
    try {
      chatAppCubit.sendMessage(
        conversationId: widget.chat.id,
        toPetId: widget.chat.petId,
        description: text,
      );
      try {
        debugPrint('📤 Sent to server: "$text" (local id=${localMessage.id})');
      } catch (_) {}
    } catch (e) {
      debugPrint('❌ sendMessage error: $e');
    }

    chatAppCubit.increaseUnreadMessageCount(
      conversationId: widget.chat.id,
      toPetId: widget.chat.petId,
      fromPetId: widget.pet?.petId ?? '',
      content: text,
      imageMessage: false,
      videoMessage: false,
      fileMessage: false,
      audioMessage: false,
    );

    _messageController.clear();
  }
}
