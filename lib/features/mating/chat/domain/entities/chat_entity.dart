class ChatEntity {
  final String id;
  final String petAName;
  final String petBName;
  final String petBreed;
  final String petImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final ChatStatus status;

  ChatEntity({
    required this.id,
    required this.petAName,
    required this.petBName,
    required this.petBreed,
    required this.petImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.status,
  });
}

class MessageEntity {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final MessageStatus status;
  final String? chatId;

  MessageEntity({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    required this.status,
    this.chatId,
  });
}