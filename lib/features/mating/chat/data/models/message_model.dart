import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
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
        var tempDate = DateTime.parse(raw.toString());
        
        if (tempDate.isUtc) {
          parsedCreatedAt = tempDate.toLocal();
        } else {
          parsedCreatedAt = DateTime.parse('${raw}Z').toLocal();
        }
        
        if (parsedCreatedAt.year <= 1) parsedCreatedAt = DateTime.now();
      } catch (_) {
        try {
          parsedCreatedAt = DateTime.parse(raw.toString()).toLocal();
          if (parsedCreatedAt.year <= 1) parsedCreatedAt = DateTime.now();
        } catch (_) {
          parsedCreatedAt = DateTime.now();
        }
      }
    }

    return MessageModel(
      id: json['id'] ?? '',
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
      'id': id,
      'description': description,
      'image': image,
      'video': video,
      'audio': audio,
      'isRead': isRead,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'toMe': toMe,
    };
  }
//signalR object
  Map<String, dynamic> toSignalRCommand({
    String? conversationId,
    String? fromPetId,
    String? toPetId,
  }) {
    return {
      'description': description,
      'image': image,
      'video': video,
      'audio': audio,
      'fromUserId': fromUserId.isNotEmpty ? fromUserId : null,
      'toUserId': toUserId.isNotEmpty ? toUserId : null,
      'clinicId': null,
      'conversationId': conversationId,
      'fromPetId': fromPetId?.isNotEmpty == true ? fromPetId : null,
      'toPetId': toPetId?.isNotEmpty == true ? toPetId : null,
    };
  }

  static List<MessageModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => MessageModel.fromJson(item)).toList();
  }
}
