import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.description,
    super.image,
    super.video,
    super.audio,
    required super.isRead,
    required super.fromUserId,
    required super.toUserId,
    required super.createdAt,
    required super.toMe,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedCreatedAt;
    final raw = json['createdAt'];
    if (raw == null) {
      parsedCreatedAt = DateTime.now();
    } else {
      try {
        parsedCreatedAt = DateTime.parse(raw.toString()).toLocal();
        if (parsedCreatedAt.year <= 1) parsedCreatedAt = DateTime.now();
      } catch (_) {
        parsedCreatedAt = DateTime.now();
      }
    }

    return MessageModel(
      description: json['description'] ?? '',
      image: json['image'],
      video: json['video'],
      audio: json['audio'],
      isRead: json['isRead'] ?? false,
      fromUserId: json['fromUserId'] ?? '',
      toUserId: json['toUserId'] ?? '',
      createdAt: parsedCreatedAt,
      toMe: json['toMe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': image,
      'video': video,
      'audio': audio,
      'isRead': isRead,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'createdAt': createdAt.toIso8601String(),
      'toMe': toMe,
    };
  }

  static List<MessageModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => MessageModel.fromJson(item)).toList();
  }
}
