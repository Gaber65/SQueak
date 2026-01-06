import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/utils/date_time_formatter.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_messages_cubit.dart';
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';
import 'package:squeak/features/mating/chat/domain/entities/message_status.dart';
import 'package:squeak/generated/l10n.dart';
import '../../../domain/entities/message_entity.dart';
import '../attach_files_in_chat/full_screen_media_viewer.dart';
import '../attach_files_in_chat/audio_player_widget.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_app_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../attach_files_in_chat/in_app_document_viewer.dart';
import 'image_grid_layout.dart';

class ChatMessageBubble extends StatefulWidget {
  final MessageEntity message;
  final bool isMe;
  final String conversationId;
  final String? chatImage;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.conversationId,
    this.chatImage,
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
      onLongPress: !widget.message.toMe ? () async {
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
      } : null,
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
                        // Media content (legacy single attachment fields)
                        if (widget.message.image != null) _buildImageContent(),
                        if (widget.message.video != null) _buildVideoContent(),
                        if (widget.message.audio != null) _buildAudioContent(),
                        if (widget.message.file != null)
                          _buildDocumentContent(),

                        // New attachments array handling
                        if (widget.message.attachments.isNotEmpty)
                          ..._buildAttachmentsContent(),

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
                              StreamBuilder<Map<String, MessageStatus>>(
                                stream:
                                    ChatMessagesCubit.get(
                                      context,
                                    ).messageStatusStream,
                                initialData:
                                    ChatMessagesCubit.get(
                                      context,
                                    ).messageStatuses,
                                builder: (context, snapshot) {
                                  final msgId = widget.message.id;
                                  final statusFromStream =
                                      (msgId != null && msgId.isNotEmpty)
                                          ? snapshot.data != null
                                              ? snapshot.data![msgId]
                                              : null
                                          : null;
                                  var status =
                                      statusFromStream ?? widget.message.status;
                                  try {
                                    final chatAppCubit =
                                        context.read<ChatAppCubit>();
                                    final otherUserId = widget.message.toUserId;
                                    if (!widget.message.toMe &&
                                        status == MessageStatus.sent) {
                                      final isOnline = chatAppCubit.generalHub
                                          .isPetOnlineFromDict(otherUserId);
                                      if (isOnline) {
                                        status = MessageStatus.delivered;
                                      }
                                    }
                                  } catch (_) {}

                                  return _buildStatusIcon(status);
                                },
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

  /// Build WhatsApp-like status icon based on MessageStatus
  Widget _buildStatusIcon(MessageStatus status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case MessageStatus.sent:
        // Single grey/white check - message reached server
        iconData = Icons.done_rounded;
        iconColor = Colors.white.withOpacity(0.8);
        break;
      case MessageStatus.delivered:
        // Double grey checks - message delivered to recipient
        iconData = Icons.done_all_rounded;
        iconColor = Colors.white.withOpacity(0.7);
        break;
      case MessageStatus.seen:
        // Double blue checks - message read by recipient
        iconData = Icons.done_all_rounded;
        iconColor = const Color(0xFF25D366); // WhatsApp green
        break;
    }

    return Icon(iconData, size: 16, color: iconColor);
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
        child:
            (widget.chatImage != null && widget.chatImage!.isNotEmpty)
                ? ClipOval(
                  child: Image.network(
                    imageUrl + widget.chatImage!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          Icons.pets,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        ),
                      );
                    },
                  ),
                )
                : Icon(
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

  Widget _buildDocumentContent() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Extract file name from URL
    final docUrl = widget.message.file!;
    final fileName = docUrl.split('/').last.split('?').first;

    // Determine file extension and icon
    final extension = fileName.split('.').last.toUpperCase();
    IconData icon;
    Color iconColor;

    switch (extension) {
      case 'PDF':
        icon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'DOC':
      case 'DOCX':
        icon = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'XLS':
      case 'XLSX':
        icon = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'PPT':
      case 'PPTX':
        icon = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case 'TXT':
        icon = Icons.text_snippet;
        iconColor = Colors.grey;
        break;
      case 'ZIP':
      case 'RAR':
      case '7Z':
        icon = Icons.folder_zip;
        iconColor = Colors.amber;
        break;
      default:
        icon = Icons.insert_drive_file;
        iconColor = Colors.blueGrey;
    }

    return InkWell(
      onTap: () {
        final fullUrl = documentUrl + docUrl;
        final extension = fileName.split('.').last.toLowerCase();

        // Check if it's an image file
        if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(extension)) {
          // Open as image
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => FullScreenMediaViewer(
                    mediaUrl: fullUrl,
                    mediaType: MediaType.image,
                  ),
            ),
          );
        } else if (extension == 'pdf') {
          // Open PDF directly in app viewer
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => InAppDocumentViewer(
                    documentUrl: fullUrl,
                    fileName: fileName,
                  ),
            ),
          );
        } else {
          // For other documents, show options screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => FullScreenMediaViewer(
                    mediaUrl: fullUrl,
                    mediaType: MediaType.document,
                  ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (widget.isMe
                  ? Colors.white.withOpacity(0.2)
                  : (isDark ? Colors.grey[900] : Colors.grey[300]))
              ?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                widget.isMe
                    ? Colors.white.withOpacity(0.3)
                    : (isDark ? Colors.grey[700]! : Colors.grey[400]!),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      color:
                          widget.isMe
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      extension,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Download icon removed per design request
          ],
        ),
      ),
    );
  }

  /// Build a list of widgets for attachments from the attachments array
  List<Widget> _buildAttachmentsContent() {
    final widgets = <Widget>[];

    // Separate attachments by type
    final imageAttachments = <Attachment>[];
    final videoAttachments = <Attachment>[];
    final documentAttachments = <Attachment>[];
    final audioAttachments = <Attachment>[];

    for (final attachment in widget.message.attachments) {
      switch (attachment.attachmentType) {
        case 0:
          imageAttachments.add(attachment);
          break;
        case 1:
          videoAttachments.add(attachment);
          break;
        case 2:
          documentAttachments.add(attachment);
          break;
        case 3:
          audioAttachments.add(attachment);
          break;
      }
    }

    // Combine images and videos for grid layout (WhatsApp style)
    final mediaAttachments = [...imageAttachments, ...videoAttachments];
    
    // Add media grid layout if there are images or videos
    if (mediaAttachments.isNotEmpty) {
      widgets.add(ImageGridLayout(imageAttachments: mediaAttachments));
    }

    // Add documents individually
    for (final attachment in documentAttachments) {
      widgets.add(_buildAttachmentDocument(attachment.url));
    }

    // Add audio individually
    for (final attachment in audioAttachments) {
      widgets.add(_buildAttachmentAudio(attachment.url));
    }

    return widgets;
  }

  /// Build audio widget for attachment
  Widget _buildAttachmentAudio(String attachmentUrl) {
    final theme = Theme.of(context);
    return AudioPlayerWidget(
      audioUrl: audioUrl + attachmentUrl,
      isMe: widget.isMe,
      primaryColor: theme.colorScheme.primary,
    );
  }

  /// Build document widget for attachment
  Widget _buildAttachmentDocument(String attachmentUrl) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fileName = attachmentUrl.split('/').last.split('?').first;
    final extension = fileName.split('.').last.toUpperCase();

    IconData icon;
    Color iconColor;

    switch (extension) {
      case 'PDF':
        icon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'DOC':
      case 'DOCX':
        icon = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'XLS':
      case 'XLSX':
        icon = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'PPT':
      case 'PPTX':
        icon = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case 'TXT':
        icon = Icons.text_snippet;
        iconColor = Colors.grey;
        break;
      case 'ZIP':
      case 'RAR':
      case '7Z':
        icon = Icons.folder_zip;
        iconColor = Colors.amber;
        break;
      default:
        icon = Icons.insert_drive_file;
        iconColor = Colors.blueGrey;
    }

    return InkWell(
      onTap: () {
        final fullUrl = documentUrl + attachmentUrl;
        final lowerExtension = extension.toLowerCase();

        if ([
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
          'bmp',
        ].contains(lowerExtension)) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => FullScreenMediaViewer(
                    mediaUrl: fullUrl,
                    mediaType: MediaType.image,
                  ),
            ),
          );
        } else if (lowerExtension == 'pdf') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => InAppDocumentViewer(
                    documentUrl: fullUrl,
                    fileName: fileName,
                  ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => InAppDocumentViewer(
                    documentUrl: fullUrl,
                    fileName: fileName,
                  ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (widget.isMe
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary)
              .withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          widget.isMe
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    extension,
                    style: TextStyle(
                      color:
                          widget.isMe
                              ? Colors.white.withOpacity(0.7)
                              : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
