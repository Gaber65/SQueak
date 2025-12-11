import 'package:squeak/features/mating/chat/data/models/message_model.dart';
import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.isGroup,
    required super.isPetChat,
    required super.name,
    required super.image,
    required super.groupImage,
    required super.petId,
    required super.matingId,
    required super.completeMarriageStatues,
    required super.createdAt,
    required super.lastMessageSendDateTime,
    required super.isBlock,
    required super.isBlockedByMe,
    required super.isBlockedByOther,
    required super.isReadOnly,
    required super.unreadedCount,
    required super.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final model = ChatModel(
      id: json['id'] ?? '',
      isGroup: json['isGroup'] ?? false,
      isPetChat: json['isPetChat'] ?? false,
      name: json['name'] ?? 'Unknown',
      image: json['image'],
      groupImage: json['groupImage'],
      petId: json['petId'] ?? '',
      matingId: json['matingId'] ?? '',
      completeMarriageStatues: json['completeMarriageStatues'] ?? false,
      createdAt: json['createdAt'] ?? '',
      lastMessageSendDateTime: json['lastMessageSendDateTime'] ?? '',
      isBlock: json['isBlock'] ?? false,
      isBlockedByMe: json['isBlockedByMe'] ?? false,
      isBlockedByOther: json['isBlockedByOther'] ?? false,
      isReadOnly: json['isReadOnly'] ?? false,
      unreadedCount: json['unreadedCount'] ?? 0,
      lastMessage:
          json['lastMessage'] != null
              ? MessageModel.fromJson(json['lastMessage'])
              : MessageModel(
                id: '',
                description: '',
                fromUserId: '',
                toUserId: '',
                createdAt: DateTime.now(),
                toMe: false,
              ),
    );
    return model;
  }

  Map<String, dynamic> toJson() {
    final map = {
      'id': id,
      'isGroup': isGroup,
      'isPetChat': isPetChat,
      'name': name,
      'image': image,
      'groupImage': groupImage,
      'petId': petId,
      'matingId': matingId,
      'completeMarriageStatues': completeMarriageStatues,
      'createdAt': createdAt,
      'lastMessageSendDateTime': lastMessageSendDateTime,
      'isBlock': isBlock,
      'isBlockedByMe': isBlockedByMe,
      'isBlockedByOther': isBlockedByOther,
      'isReadOnly': isReadOnly,
    };
    return map;
  }

  static List<ChatModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => ChatModel.fromJson(item)).toList();
  }
}
