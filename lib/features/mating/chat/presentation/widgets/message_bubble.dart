// message_bubble.dart
import 'package:flutter/material.dart';

import '../../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/message_status.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) _buildPetAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: message.isMe
                        ? LinearGradient(
                      colors: [ColorManager.primaryColor,ColorManager.primaryColor.withOpacity(0.4)],
                    )
                        : null,
                    color: message.isMe ? null : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.only(
                    left: message.isMe ? 0 : 12,
                    right: message.isMe ? 12 : 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatMessageTime(message.time),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      if (message.isMe) ...[
                        const SizedBox(width: 6),
                        Icon(
                          message.status == MessageStatus.read ? Icons.done_all : Icons.done,
                          size: 14,
                          color: message.status == MessageStatus.read
                              ? Colors.blue[200]
                              : Colors.grey[400],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (message.isMe) const SizedBox(width: 8),
          if (message.isMe) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildPetAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ColorManager.primaryColor.withOpacity(0.3), width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/pet_avatar.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.primaryColor.withOpacity(0.1),
              ),
              child: Icon(Icons.pets, size: 18, color: ColorManager.primaryColor),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/user_avatar.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[100],
              ),
              child: Icon(Icons.person, size: 18, color: Colors.blue),
            );
          },
        ),
      ),
    );
  }

  String _formatMessageTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}