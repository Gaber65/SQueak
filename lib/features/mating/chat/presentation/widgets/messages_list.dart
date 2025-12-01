import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../domain/entities/message_entity.dart';
import 'message_bubble.dart';
import 'date_divider.dart';
import 'uploading_bubble.dart';
import 'typing_indicator.dart';
import 'chat_background_painter.dart';

class MessagesList extends StatelessWidget {
  final List<MessageEntity> messages;
  final List<UploadingMedia> uploadingFiles;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final String conversationId;
  final bool isOtherUserTyping;

  const MessagesList({
    super.key,
    required this.messages,
    required this.uploadingFiles,
    required this.itemScrollController,
    required this.itemPositionsListener,
    required this.conversationId,
    this.isOtherUserTyping = false,
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
    final totalItems = messages.length + uploadingFiles.length;

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
            if (index < messages.length) {
              final message = messages[index];
              final showDateDivider =
                  index == 0 ||
                  !_isSameDay(messages[index - 1].createdAt, message.createdAt);

              return Column(
                children: [
                  if (showDateDivider) DateDivider(date: message.createdAt),
                  ChatMessageBubble(
                    message: message,
                    isMe: !message.toMe,
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
        if (isOtherUserTyping)
          const Positioned(bottom: 8, left: 16, child: TypingIndicator()),
      ],
    );
  }
}
