part of 'notifications_cubit.dart';

@immutable
sealed class NotificationsState {}

class NotificationsStateData extends NotificationsState {
  final List<NotificationEntities> notifications;
  final List<PostEntity> posts;
  final PostEntity? postModel;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingPost;
  final bool postFound;
  final String? errorMessage;

  NotificationsStateData({
    required this.notifications,
    this.posts = const [],
    this.postModel,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingPost = false,
    this.postFound = false,
    this.errorMessage,
  });

  NotificationsStateData copyWith({
    List<NotificationEntities>? notifications,
    List<PostEntity>? posts,
    PostEntity? postModel,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingPost,
    bool? postFound,
    String? errorMessage,
  }) {
    return NotificationsStateData(
      notifications: notifications ?? this.notifications,
      posts: posts ?? this.posts,
      postModel: postModel ?? this.postModel,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingPost: isLoadingPost ?? this.isLoadingPost,
      postFound: postFound ?? this.postFound,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationsStateData &&
        other.notifications == notifications &&
        other.posts == posts &&
        other.postModel == postModel &&
        other.isLoading == isLoading &&
        other.isRefreshing == isRefreshing &&
        other.isLoadingPost == isLoadingPost &&
        other.postFound == postFound &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return notifications.hashCode ^
    posts.hashCode ^
    postModel.hashCode ^
    isLoading.hashCode ^
    isRefreshing.hashCode ^
    isLoadingPost.hashCode ^
    postFound.hashCode ^
    errorMessage.hashCode;
  }
}

final class NotificationsInitial extends NotificationsStateData {
  NotificationsInitial() : super(notifications: []);
}