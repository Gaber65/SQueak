import 'package:squeak/features/mating/chat/domain/entities/chat_status.dart';

class GetChatsParameters {
  final ChatStatus? status;

  const GetChatsParameters({this.status});
}

class GetMessagesParameters {
  final String chatId;

  const GetMessagesParameters({required this.chatId});
}

class SendMessageParameters {
  final String chatId;
  final String text;
  final bool isMe;

  const SendMessageParameters({
    required this.chatId,
    required this.text,
    required this.isMe,
  });
}

class UpdateChatStatusParameters {
  final String chatId;
  final ChatStatus status;

  const UpdateChatStatusParameters({
    required this.chatId,
    required this.status,
  });
}

class MarkMessagesReadParameters {
  final String chatId;

  const MarkMessagesReadParameters({required this.chatId});
}