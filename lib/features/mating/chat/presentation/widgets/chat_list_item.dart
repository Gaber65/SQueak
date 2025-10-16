// chat_list_item.dart
import 'package:flutter/material.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';

import '../../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../../../../core/utils/theme/decorations/decorations.dart';
import '../../domain/entities/chat_status.dart';

class ChatListItem extends StatelessWidget {
  final ChatEntity chat;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: Decorations.kDecorationBoxShadow(context: context, radius: 20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ListTile(
          leading: Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getStatusColor(chat.status).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    _getPetImage(chat.petBName),
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorManager.primaryColor.withOpacity(0.1),
                        ),
                        child: Icon(Icons.pets, color: ColorManager.primaryColor),
                      );
                    },
                  ),
                ),
              ),
              if (chat.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Row(
            children: [
              Text(
                chat.petBName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 6),
              _buildStatusIndicator(chat.status),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      chat.lastMessage,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (chat.unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        chat.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(chat.lastMessageTime),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (chat.status == ChatStatus.onMating)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, color: Colors.pink, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Mating',
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(ChatStatus status) {
    Color color;
    String emoji;

    switch (status) {
      case ChatStatus.active:
        color = Colors.blue;
        emoji = '💬';
        break;
      case ChatStatus.onMating:
        color = Colors.pink;
        emoji = '❤️';
        break;
      case ChatStatus.completed:
        color = Colors.purple;
        emoji = '✅';
        break;
      case ChatStatus.blocked:
        color = Colors.red;
        emoji = '🚫';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Color _getStatusColor(ChatStatus status) {
    switch (status) {
      case ChatStatus.active:
        return Colors.blue;
      case ChatStatus.onMating:
        return Colors.pink;
      case ChatStatus.completed:
        return Colors.purple;
      case ChatStatus.blocked:
        return Colors.red;
    }
  }

  String _getPetImage(String petName) {
    // Map pet names to image assets - you'll need to add these images to your assets
    final petImages = {
      'Buddy': 'assets/dog1.png',
      'Max': 'assets/dog2.png',
      'Bella': 'assets/dog3.png',
      'Luna': 'assets/cat1.png',
      'Charlie': 'assets/dog4.png',
      'Lucy': 'assets/cat2.png',
    };
    return petImages[petName] ?? 'assets/default_pet.png';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}