import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../domain/entities/message_entity.dart';
import 'message_bubble.dart';
import '../chat_widgets/date_divider.dart';
import 'uploading_bubble.dart';
import '../typing_indicator.dart';
import '../chat_widgets/chat_background_painter.dart';

class MessagesList extends StatelessWidget {
  final List<MessageEntity> messages;
  final List<UploadingMedia> uploadingFiles;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final String conversationId;
  final bool isOtherUserTyping;
  final bool isMyTyping;

  const MessagesList({
    super.key,
    required this.messages,
    required this.uploadingFiles,
    required this.itemScrollController,
    required this.itemPositionsListener,
    required this.conversationId,
    this.isOtherUserTyping = false,
    this.isMyTyping = false,
  });

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Add typing indicators to total count
    final typingCount = (isMyTyping ? 1 : 0) + (isOtherUserTyping ? 1 : 0);
    final totalItems = messages.length + uploadingFiles.length + typingCount;

    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: isDark ? 0.03 : 0.05,
            child: CustomPaint(
              painter: ChatBackgroundPainter(color: theme.colorScheme.primary),
            ),
          ),
        ),
        ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: totalItems,
          itemBuilder: (_, index) {
            // Check if this is a typing indicator slot
            final messagesAndUploadsCount =
                messages.length + uploadingFiles.length;

            // If at the end and typing indicators should show
            if (index >= messagesAndUploadsCount) {
              final typingIndex = index - messagesAndUploadsCount;

              // Show other user's typing indicator first (left side)
              if (typingIndex == 0 && isOtherUserTyping) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const TypingIndicator(),
                  ),
                );
              }

              // Show my typing indicator (right side)
              if ((typingIndex == 0 && !isOtherUserTyping && isMyTyping) ||
                  (typingIndex == 1 && isOtherUserTyping && isMyTyping)) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4, top: 4, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: const TypingIndicator(),
                  ),
                );
              }
            }

            if (index < messages.length) {
              final message = messages[index];
              final showDateDivider =
                  index == 0 ||
                  !_isSameDay(messages[index - 1].createdAt, message.createdAt);

              final isMe = !message.toMe;

              return Column(
                children: [
                  if (showDateDivider) DateDivider(date: message.createdAt),
                  ChatMessageBubble(
                    message: message,
                    isMe: isMe,
                    conversationId: conversationId,
                  ),
                ],
              );
            } else {
              final uploadIndex = index - messages.length;
              return UploadingBubble(upload: uploadingFiles[uploadIndex]);
            }
          },
        ),
      ],
    );
  }
}
