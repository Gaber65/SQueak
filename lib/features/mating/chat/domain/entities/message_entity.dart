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
}
