// lib/features/stories/domain/entities/story.dart
class Story {
  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerAvatarUrl;
  final String imageUrl; // local path or remote URL
  final DateTime createdAt;
  final Duration ttl;

  const Story({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.imageUrl,
    required this.createdAt,
    this.ttl = const Duration(hours: 24),
  });

  bool get isExpired => DateTime.now().isAfter(createdAt.add(ttl));
  DateTime get expiresAt => createdAt.add(ttl);
}
