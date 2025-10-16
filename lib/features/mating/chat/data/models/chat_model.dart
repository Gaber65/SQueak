import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_status.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.petAName,
    required super.petBName,
    required super.petBreed,
    required super.petImage,
    required super.lastMessage,
    required super.lastMessageTime,
    super.unreadCount = 0,
    super.isOnline = false,
    required super.status,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      petAName: json['petAName'],
      petBName: json['petBName'],
      petBreed: json['petBreed'],
      petImage: json['petImage'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      unreadCount: json['unreadCount'],
      isOnline: json['isOnline'],
      status: ChatStatus.values.firstWhere(
            (e) => e.name == json['status'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petAName': petAName,
      'petBName': petBName,
      'petBreed': petBreed,
      'petImage': petImage,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'status': status.name,
    };
  }
}