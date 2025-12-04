class MessageEntity {
  final String? id;
  final String description;
  final String? image;
  final String? video;
  final String? audio;
  final bool isRead;
  final String fromUserId;
  final String toUserId;
  final DateTime createdAt;
  final bool toMe;

  const MessageEntity({
     this.id,
    required this.description,
    this.image,
    this.video,
    this.audio,
    required this.isRead,
    required this.fromUserId,
    required this.toUserId,
    required this.createdAt,
    required this.toMe,
  });

  MessageEntity copyWith({
    String? id,
    String? description,
    String? image,
    String? video,
    String? audio,
    bool? isRead,
    String? fromUserId,
    String? toUserId,
    DateTime? createdAt,
    bool? toMe,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      image: image ?? this.image,
      video: video ?? this.video,
      audio: audio ?? this.audio,
      isRead: isRead ?? this.isRead,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      createdAt: createdAt ?? this.createdAt,
      toMe: toMe ?? this.toMe,
    );
  }
}
