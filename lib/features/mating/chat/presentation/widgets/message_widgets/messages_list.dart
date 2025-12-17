import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../domain/entities/message_entity.dart';
import 'message_bubble.dart';
import '../chat_widgets/date_divider.dart';
import 'uploading_bubble.dart';
import '../typing_indicator.dart';
import '../chat_widgets/chat_background_painter.dart';

class MessagesList extends StatefulWidget {
  final List<MessageEntity> messages;
  final List<UploadingMedia> uploadingFiles;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final String conversationId;
  final String? chatImage;
  final bool isOtherUserTyping;
  final VoidCallback? onLoadMore;
  final bool hasMoreMessages;
  final bool isLoadingMore;

  const MessagesList({
    super.key,
    required this.messages,
    required this.uploadingFiles,
    required this.itemScrollController,
    required this.itemPositionsListener,
    required this.conversationId,
    this.chatImage,
    this.isOtherUserTyping = false,
    this.onLoadMore,
    this.hasMoreMessages = false,
    this.isLoadingMore = false,
  });

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  void initState() {
    super.initState();
    widget.itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final positions = widget.itemPositionsListener.itemPositions.value;

    if (positions.isNotEmpty) {
      final minPosition = positions
          .where((position) => position.itemTrailingEdge > 0)
          .reduce(
            (min, position) => position.index < min.index ? position : min,
          );

      if (minPosition.index <= 2 &&
          widget.hasMoreMessages &&
          !widget.isLoadingMore &&
          widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final typingCount = widget.isOtherUserTyping ? 1 : 0;
    final loadingCount = widget.isLoadingMore ? 1 : 0;
    final totalItems =
        widget.messages.length +
        widget.uploadingFiles.length +
        typingCount +
        loadingCount;

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
          itemScrollController: widget.itemScrollController,
          itemPositionsListener: widget.itemPositionsListener,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: totalItems,
          itemBuilder: (_, index) {
            if (widget.isLoadingMore && index == 0) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            final adjustedIndex = widget.isLoadingMore ? index - 1 : index;
            final messagesAndUploadsCount =
                widget.messages.length + widget.uploadingFiles.length;

            if (adjustedIndex >= messagesAndUploadsCount) {
              if (widget.isOtherUserTyping) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const TypingIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            }
            if (adjustedIndex < widget.messages.length) {
              final message = widget.messages[adjustedIndex];
              final showDateDivider =
                  adjustedIndex == 0 ||
                  !_isSameDay(
                    widget.messages[adjustedIndex - 1].createdAt,
                    message.createdAt,
                  );

              final isMe = !message.toMe;

              return Column(
                children: [
                  if (showDateDivider) DateDivider(date: message.createdAt),
                  ChatMessageBubble(
                    message: message,
                    isMe: isMe,
                    conversationId: widget.conversationId,
                    chatImage: widget.chatImage,
                  ),
                ],
              );
            } else {
              final uploadIndex = adjustedIndex - widget.messages.length;
              return UploadingBubble(
                upload: widget.uploadingFiles[uploadIndex],
              );
            }
          },
        ),
      ],
    );
  }
}
