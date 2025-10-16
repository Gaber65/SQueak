import 'message_status.dart';

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