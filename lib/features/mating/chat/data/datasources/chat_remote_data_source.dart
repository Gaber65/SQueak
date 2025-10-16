
import 'package:squeak/features/mating/chat/domain/entities/message_status.dart';
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';

import '../../domain/entities/chat_status.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class BaseChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<List<MessageModel>> getMessages(String chatId);
  Future<MessageModel> sendMessage(SendMessageParameters parameters);
  Future<void> updateChatStatus(String chatId, ChatStatus status);
  Future<void> markMessagesAsRead(String chatId);
}

class ChatRemoteDataSource implements BaseChatRemoteDataSource {
  @override
  Future<List<ChatModel>> getChats() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      ChatModel(
        id: '1',
        petAName: 'You',
        petBName: 'Luna',
        petBreed: 'German Shepherd',
        petImage: 'assets/luna.jpg',
        lastMessage: 'Hello! Would you like to mate our pets?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        isOnline: true,
        status: ChatStatus.active,
      ),
      ChatModel(
        id: '2',
        petAName: 'You',
        petBName: 'Charlie',
        petBreed: 'Golden Retriever',
        petImage: 'assets/charlie.jpg',
        lastMessage: 'Mating process started successfully! 🎉',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
        isOnline: false,
        status: ChatStatus.onMating,
      ),
      ChatModel(
        id: '3',
        petAName: 'You',
        petBName: 'Bella',
        petBreed: 'Siberian Husky',
        petImage: 'assets/bella.jpg',
        lastMessage: 'Thank you for the wonderful experience!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: true,
        status: ChatStatus.completed,
      ),
      ChatModel(
        id: '3',
        petAName: 'You',
        petBName: 'Bella',
        petBreed: 'Siberian Husky',
        petImage: 'assets/bella.jpg',
        lastMessage: 'Thank you for the wonderful experience!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: true,
        status: ChatStatus.blocked,
      ),
    ];
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      MessageModel(
        id: '1',
        text: 'Hello! I saw your profile and I think our pets would be a great match!',
        isMe: false,
        time: DateTime.now().subtract(const Duration(hours: 2)),
        status: MessageStatus.delivered,
      ),
      MessageModel(
        id: '2',
        text: 'Hi! Yes, my German Shepherd is very gentle and well-trained. Would you like to schedule a meeting?',
        isMe: true,
        time: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        status: MessageStatus.read,
      ),
    ];
  }

  @override
  Future<MessageModel> sendMessage(SendMessageParameters parameters) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: parameters.text,
      isMe: parameters.isMe,
      time: DateTime.now(),
      status: MessageStatus.sent,
    );
  }

  @override
  Future<void> updateChatStatus(String chatId, ChatStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> markMessagesAsRead(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}