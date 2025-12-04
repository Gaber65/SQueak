import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/signalr/signalr_conversation_services.dart';
import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../domain/entities/chat_entity.dart';
import '../attach_files_in_chat/attachment_options_bottom_sheet.dart';

class MessageInputWidget extends StatelessWidget {
  final TextEditingController messageController;
  final ChatEntity chat;
  final bool hasText;
  final VoidCallback onSendMessage;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final Function(File file, AttachmentType type, {String? caption})
  onAttachmentSelected;

  const MessageInputWidget({
    super.key,
    required this.messageController,
    required this.chat,
    required this.hasText,
    required this.onSendMessage,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onAttachmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = S.of(context);
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
                          controller: messageController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              SignalRConversationHubService().setTyping(
                                petId: chat.petId,
                                conversationId: chat.id,
                                isTyping: true,
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText: s.typeMessage,
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
                          context.read<ChatMessagesCubit>();
                          context.read<MainCubit>();

                          AttachmentOptionsBottomSheet.show(
                            context,
                            onAttachmentSelected: (file, type, {caption}) {
                              onAttachmentSelected(
                                file,
                                type,
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
                onTap: hasText ? onSendMessage : null,
                onLongPressStart: !hasText ? (_) => onStartRecording() : null,
                onLongPressEnd: !hasText ? (_) => onStopRecording() : null,
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
                    hasText ? Icons.send_rounded : Icons.mic,
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
}
