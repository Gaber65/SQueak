import '../../domain/entities/message_entity.dart';
import '../../domain/entities/message_status.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.description,
    super.image,
    super.video,
    super.audio,
    super.file,
    super.status = MessageStatus.sent,
    required super.fromUserId,
    required super.toUserId,
    required super.createdAt,
    required super.toMe,
    super.attachments = const [],
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

    // تحديد حالة الرسالة من الـ API مباشرة
    // Determine message status from API directly
    // Backend values: 1=sent, 2=delivered, 3=seen
    // Enum indices:   0=sent, 1=delivered, 2=seen
    MessageStatus parsedStatus = MessageStatus.sent;
    if (json['messageStatus'] != null) {
      final statusValue = json['messageStatus'] as int;
      // Backend sends 1-based values, enum is 0-based
      switch (statusValue) {
        case 1:
          parsedStatus = MessageStatus.sent;
          break;
        case 2:
          parsedStatus = MessageStatus.delivered;
          break;
        case 3:
          parsedStatus = MessageStatus.seen;
          break;
        default:
          parsedStatus = MessageStatus.sent;
      }
    }

    // Parse attachments from the attachments array
    List<Attachment> attachments = [];
    if (json['attachments'] != null && json['attachments'] is List) {
      attachments = (json['attachments'] as List)
          .map((item) => Attachment.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return MessageModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      video: json['video'],
      audio: json['audio'],
      file: json['file'],
      status: parsedStatus,
      fromUserId: json['fromUserId'] ?? '',
      toUserId: json['toUserId'] ?? '',
      createdAt: parsedCreatedAt,
      toMe: json['toMe'] ?? false,
      attachments: attachments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'video': video,
      'audio': audio,
      'file': file,
      'status': status.index + 1,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'toMe': toMe,
    };
  }

  static List<MessageModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => MessageModel.fromJson(item)).toList();
  }

  @override
  MessageModel copyWith({
    String? id,
    String? description,
    String? image,
    String? video,
    String? audio,
    String? file,
    MessageStatus? status,
    String? fromUserId,
    String? toUserId,
    DateTime? createdAt,
    bool? toMe,
    List<Attachment>? attachments,
  }) {
    return MessageModel(
      id: id ?? this.id,
      description: description ?? this.description,
      image: image ?? this.image,
      video: video ?? this.video,
      audio: audio ?? this.audio,
      file: file ?? this.file,
      status: status ?? this.status,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      createdAt: createdAt ?? this.createdAt,
      toMe: toMe ?? this.toMe,
      attachments: attachments ?? this.attachments,
    );
  }
}
