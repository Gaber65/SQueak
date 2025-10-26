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
    super.isBlockedByMe,
    super.isBlockedByOther,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      isGroup: json['isGroup'],
      isPetChat: json['isPetChat'],
      name: json['name'],
      image: json['image'],
      groupImage: json['groupImage'],
      petId: json['petId'],
      matingId: json['matingId'],
      completeMarriageStatues: json['completeMarriageStatues'],
      createdAt:json['createdAt'],
      lastMessageSendDateTime:json['lastMessageSendDateTime'],
      isBlock: json['isBlock'],
      isBlockedByMe: json['isBlockedByMe'] ?? false,
      isBlockedByOther: json['isBlockedByOther'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  static List<ChatModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => ChatModel.fromJson(item)).toList();
  }
}
