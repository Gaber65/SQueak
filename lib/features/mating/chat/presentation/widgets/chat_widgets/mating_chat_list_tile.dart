import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../screens/chat_screen.dart';
import '../../controllers/chat_app_cubit.dart';

class MatingChatListTile extends StatelessWidget {
  final ChatEntity chat;
  final PetEntities petEntities;
  final Future<void> Function()? onNavigateComplete;
  final bool compact;
  final bool isOnline;
  final bool isTyping;
  final int unreadCount;

  const MatingChatListTile({
    super.key,
    required this.chat,
    required this.petEntities,
    this.onNavigateComplete,
    this.compact = false,
    this.isOnline = false,
    this.isTyping = false,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDark
                        ? [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.02),
                        ]
                        : [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
                        ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  // Get the ChatAppCubit from current context before navigation
                  final chatAppCubit = context.read<ChatAppCubit>();

                  await Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              BlocProvider.value(
                                value: chatAppCubit,
                                child: MatingChatDetailScreen(
                                  chat: chat,
                                  pet: petEntities,
                                ),
                              ),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        var begin = const Offset(1.0, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );

                  try {
                    if (onNavigateComplete != null) {
                      await onNavigateComplete!();
                    }
                  } catch (_) {}
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildAvatar(chat),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildLastMessage(chat, theme),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatLastMessageTime(chat),
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99
                                      ? '99+'
                                      : unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (chat.completeMarriageStatues)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B9D),
                                    Color(0xFFFFC371),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF6B9D,
                                    ).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Mating',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (chat.isBlock)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red[400]!, Colors.red[600]!],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.block,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    S.of(navigatorKey.currentContext!).block,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ChatEntity chat) {
    final img = chat.image ?? '';

    Widget avatarWidget;
    if (img.isEmpty) {
      avatarWidget = Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              ColorManager.primaryColor.withOpacity(0.3),
              ColorManager.primaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: Icon(Icons.pets, color: ColorManager.primaryColor, size: 28),
      );
    } else {
      final base = imageUrl;
      final fullUrl = base + img;

      avatarWidget = Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              ColorManager.primaryColor.withOpacity(0.3),
              ColorManager.primaryColor.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: ColorManager.primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            fullUrl,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        ColorManager.primaryColor.withOpacity(0.2),
                        ColorManager.primaryColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.pets,
                    color: ColorManager.primaryColor,
                    size: 28,
                  ),
                ),
          ),
        ),
      );
    }

    // Wrap with online indicator
    return Stack(
      children: [
        avatarWidget,
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLastMessage(ChatEntity chat, ThemeData theme) {
    // Show typing indicator if friend is typing
    if (isTyping) {
      return Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                ColorManager.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isArabic() ? 'يكتب...' : 'Typing...',
            style: TextStyle(
              fontSize: 14,
              color: ColorManager.primaryColor,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (chat.lastMessage == null) {
      return Text(
        isArabic() ? 'لا رسائل بعد' : 'No messages yet',
        style: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontStyle: FontStyle.italic,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final message = chat.lastMessage!;
    final isFromMe = !message.toMe;

    String messageText = message.description;
    IconData? mediaIcon;
    if (message.image != null && message.image!.isNotEmpty) {
      mediaIcon = Icons.image;
      messageText = isArabic() ? 'صورة' : 'Photo';
    } else if (message.video != null && message.video!.isNotEmpty) {
      mediaIcon = Icons.videocam;
      messageText = isArabic() ? 'فيديو' : 'Video';
    } else if (message.audio != null && message.audio!.isNotEmpty) {
      mediaIcon = Icons.mic;
      messageText = isArabic() ? 'صوت' : 'Audio';
    }

    // If no media and no description, show "No messages yet"
    if (mediaIcon == null && messageText.isEmpty) {
      return Text(
        isArabic() ? 'لا رسائل بعد' : 'No messages yet',
        style: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontStyle: FontStyle.italic,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Row(
      children: [
        if (isFromMe)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.done_all,
              size: 16,
              color:
                  message.isRead
                      ? const Color(0xFF25D366)
                      : Theme.of(
                        navigatorKey.currentContext!,
                      ).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        if (mediaIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              mediaIcon,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        Expanded(
          child: Text(
            messageText,
            style: TextStyle(
              fontSize: 14,
              color:
                  isFromMe
                      ? theme.colorScheme.onSurface.withOpacity(0.6)
                      : theme.colorScheme.onSurface.withOpacity(0.85),
              fontWeight: isFromMe ? FontWeight.normal : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatLastMessageTime(ChatEntity chat) {
    try {
      final msg = chat.lastMessage;
      if (msg == null) return '';

      final hasImage = msg.image != null && msg.image!.isNotEmpty;
      final hasVideo = msg.video != null && msg.video!.isNotEmpty;
      final hasAudio = msg.audio != null && msg.audio!.isNotEmpty;
      final hasDescription = msg.description.isNotEmpty;

      if (!hasImage && !hasVideo && !hasAudio && !hasDescription) return '';

      final dt = msg.createdAt.toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      final arabic = isArabic();

      if (diff.inSeconds < 60) return arabic ? 'الآن' : 'Just now';
      if (diff.inMinutes < 60) {
        return arabic
            ? 'منذ ${diff.inMinutes} دقيقة'
            : '${diff.inMinutes} minutes ago';
      }
      if (diff.inHours < 24) {
        return arabic
            ? 'منذ ${diff.inHours} ساعة'
            : '${diff.inHours} hours ago';
      }
      if (diff.inDays == 1) {
        return arabic
            ? 'أمس في ${DateFormat('h:mm a', 'ar').format(dt)}'
            : 'Yesterday at ${DateFormat('h:mm a').format(dt)}';
      }
      if (diff.inDays < 7) {
        return arabic
            ? '${DateFormat('EEEE', 'ar').format(dt)} في ${DateFormat('h:mm a', 'ar').format(dt)}'
            : DateFormat("EEEE 'at' h:mm a").format(dt);
      }

      return arabic
          ? '${DateFormat('MMM d', 'ar').format(dt)} في ${DateFormat('h:mm a', 'ar').format(dt)}'
          : DateFormat("MMM d 'at' h:mm a").format(dt);
    } catch (_) {
      return '';
    }
  }
}
