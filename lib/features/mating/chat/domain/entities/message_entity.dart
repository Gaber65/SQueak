import 'message_status.dart';

/// Represents a single attachment in a message
class Attachment {
  final String url;
  final String? description;
  final int attachmentType;
  final int? attachmentPlaceholder;

  const Attachment({
    required this.url,
    required this.attachmentType,
    this.description,
    this.attachmentPlaceholder,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      url: json['url'] ?? '',
      attachmentType: json['attachmentType'] ?? json['type'] ?? 0,
      description: json['description'],
      attachmentPlaceholder: json['attachmentPlaceholder'] ?? json['attachmentPlaceHolder'],
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'attachmentType': attachmentType,
    if (description != null) 'description': description,
    if (attachmentPlaceholder != null) 'attachmentPlaceholder': attachmentPlaceholder,
  };
}

class MessageEntity {
  final String? id;
  final String description;
  final String? image;
  final String? video;
  final String? audio;
  final String? file;
  final MessageStatus status;
  final String fromUserId;
  final String toUserId;
  final DateTime createdAt;
  final bool toMe;
  final List<Attachment> attachments;

  const MessageEntity({
    this.id,
    required this.description,
    this.image,
    this.video,
    this.audio,
    this.file,
    this.status = MessageStatus.sent,
    required this.fromUserId,
    required this.toUserId,
    required this.createdAt,
    required this.toMe,
    this.attachments = const [],
  });

  MessageEntity copyWith({
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
    return MessageEntity(
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


  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'image': image,
    'video': video,
    'audio': audio,
    'file': file,
    'status': status.index + 1,
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'createdAt': createdAt.toIso8601String(),
    'toMe': toMe,
    'attachments': attachments.map((a) => a.toJson()).toList(),
  };

}
