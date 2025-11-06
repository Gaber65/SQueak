class SendFriendPetMessageParameters {
  final String description;
  final String? image;
  final String? video;
  final String? audio;
  final bool isRead;
  final String? toUserId;
  final String? clinicId;
  final String? conversationId;
  final String fromPetId;
  final String toPetId;

  const SendFriendPetMessageParameters({
    required this.description,
    this.image,
    this.video,
    this.audio,
    this.isRead = true,
    this.toUserId,
    this.clinicId,
    this.conversationId,
    required this.fromPetId,
    required this.toPetId,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': image,
      'video': video,
      'audio': audio,
      'isRead': isRead,
      'toUserId': toUserId,
      'clinicId': clinicId,
      'conversationId': conversationId,
      'fromPetId': fromPetId,
      'toPetId': toPetId,
    };
  }
}
