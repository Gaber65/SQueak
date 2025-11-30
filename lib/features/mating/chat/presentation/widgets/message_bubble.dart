import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/utils/date_time_formatter.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_messages_cubit.dart';
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';
import 'package:squeak/generated/l10n.dart';
import '../../domain/entities/message_entity.dart';
import 'full_screen_media_viewer.dart';
import 'audio_player_widget.dart';

class ChatMessageBubble extends StatefulWidget {
  final MessageEntity message;
  final bool isMe;
  final String conversationId;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.conversationId,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isMe ? 0.2 : -0.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onLongPress: () async {
        bool onlyForMe = true;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text(S.of(context).deleteMessage),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<bool>(
                        value: true,
                        groupValue: onlyForMe,
                        onChanged: (v) => setState(() => onlyForMe = v ?? true),
                        title: Text(S.of(context).deleteMessageForMe),
                      ),
                      RadioListTile<bool>(
                        value: false,
                        groupValue: onlyForMe,
                        onChanged: (v) => setState(() => onlyForMe = v ?? true),
                        title: Text(S.of(context).deleteMessageForEveryone),
                      ),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(false),
                          icon: Icon(Icons.cancel),
                          label: Text(S.of(context).cancel),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.delete_sweep_rounded),
                          label: Text(S.of(context).delete),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );

        if (confirmed == true) {
          // Ensure message has an id
          if (widget.message.id == null || widget.message.id!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cannot delete unsent message')),
            );
            return;
          }

          final params = DeleteMessageParameters(
            conversationId: widget.conversationId,
            onlyFromMe: onlyForMe,
            messageId: widget.message.id!,
          );

          debugPrint('DeleteMessage request body: ${params.toJson()}');

          // Call cubit to delete
          final cubit = ChatMessagesCubit.get(context);
          await cubit.deleteMessage(params);
        }
      },
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              mainAxisAlignment:
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!widget.isMe) ..._buildSenderInfo(context),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                          widget.isMe
                              ? LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                              : LinearGradient(
                                colors:
                                    isDark
                                        ? [Colors.grey[800]!, Colors.grey[850]!]
                                        : [
                                          Colors.grey[200]!,
                                          Colors.grey[100]!,
                                        ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(widget.isMe ? 20 : 4),
                        bottomRight: Radius.circular(widget.isMe ? 4 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Media content
                        if (widget.message.image != null) _buildImageContent(),
                        if (widget.message.video != null) _buildVideoContent(),
                        if (widget.message.audio != null) _buildAudioContent(),

                        // Text message
                        if (widget.message.description.isNotEmpty)
                          Text(
                            widget.message.description,
                            style: TextStyle(
                              color:
                                  widget.isMe
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white
                                          : Colors.black87),
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),

                        // Timestamp and read status
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateTimeFormatter.formattedTime(
                                widget.message.createdAt,
                                Localizations.localeOf(context).toString(),
                              ),
                              style: TextStyle(
                                color:
                                    widget.isMe
                                        ? Colors.white.withOpacity(0.8)
                                        : (isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600]),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (widget.isMe) ...[
                              const SizedBox(width: 6),
                              Icon(
                                widget.message.isRead
                                    ? Icons.done_all_rounded
                                    : Icons.done_rounded,
                                size: 16,
                                color:
                                    widget.message.isRead
                                        ? const Color(0xFF25D366) // WhatsApp green for read
                                        : Colors.white.withOpacity(0.7),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.isMe) const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSenderInfo(BuildContext context) {
    return [
      Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.only(right: 8, bottom: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.3),
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.pets,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ];
  }

  Widget _buildImageContent() {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => FullScreenMediaViewer(
                  mediaUrl: imageUrl + widget.message.image!,
                  mediaType: MediaType.image,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FastCachedImage(
            url: imageUrl + widget.message.image!,
            width: 220,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder:
                (context, url, error) => Container(
                  width: 220,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_rounded,
                        color: Colors.grey[600],
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Image not available',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
            loadingBuilder:
                (context, progress) => Container(
                  width: 220,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => FullScreenMediaViewer(
                  mediaUrl: videoUrl + widget.message.video!,
                  mediaType: MediaType.video,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        width: 220,
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.videocam_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Video',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioContent() {
    final theme = Theme.of(context);
    return AudioPlayerWidget(
      audioUrl: audioUrl + widget.message.audio!,
      isMe: widget.isMe,
      primaryColor: theme.colorScheme.primary,
    );
  }
}
