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
final List<Story> dummyStories = [
  Story(
    id: "1",
    ownerId: "user_101",
    ownerName: "Ahmed Ali",
    ownerAvatarUrl: "https://picsum.photos/200/200?1",
    imageUrl: "https://picsum.photos/500/800?1",
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  Story(
    id: "2",
    ownerId: "user_102",
    ownerName: "Sara Mohamed",
    ownerAvatarUrl: "https://picsum.photos/200/200?2",
    imageUrl: "https://picsum.photos/500/800?2",
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Story(
    id: "3",
    ownerId: "user_103",
    ownerName: "Nour Hassan",
    ownerAvatarUrl: "https://picsum.photos/200/200?3",
    imageUrl: "https://picsum.photos/500/800?3",
    createdAt: DateTime.now().subtract(const Duration(hours: 20)),
  ),
  Story(
    id: "4",
    ownerId: "user_104",
    ownerName: "Khaled Ibrahim",
    ownerAvatarUrl: "https://picsum.photos/200/200?4",
    imageUrl: "https://picsum.photos/500/800?4",
    createdAt: DateTime.now().subtract(const Duration(hours: 23, minutes: 30)),
  ),
  Story(
    id: "5",
    ownerId: "user_105",
    ownerName: "Mona Adel",
    ownerAvatarUrl: "https://picsum.photos/200/200?5",
    imageUrl: "https://picsum.photos/500/800?5",
    createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
  ),
];
