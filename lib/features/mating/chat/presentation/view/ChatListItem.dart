import 'package:flutter/material.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';

import 'ChatConversationPage.dart';

class ChatListItemNew extends StatelessWidget {
  final ChatEntity chat;
  final bool isOnline;
  final bool isTyping;
  final int unreadCount;

  const ChatListItemNew({
    super.key,
    required this.chat,
    required this.isOnline,
    required this.isTyping,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: chat.image != null
                ? NetworkImage(chat.image!)
                : null,
            child: chat.image == null
                ? Text(chat.name[0].toUpperCase())
                : null,
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: isTyping
          ? const Text(
        'typing...',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.blue,
        ),
      )
          : Text(
        chat.lastMessage?.description ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: unreadCount > 0
          ? Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          unreadCount > 99 ? '99+' : unreadCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatConversationPage(chat: chat),
          ),
        );
      },
    );
  }
}
