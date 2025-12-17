// community_state.dart
part of 'community_cubit.dart';

@immutable
abstract class CommunityState {}

class FeedsInitial extends CommunityState {}

class GetUserDataLoading extends CommunityState {}

class GetUserDataSuccess extends CommunityState {}

class GetUserDataError extends CommunityState {}

class GetPostsLoading extends CommunityState {}

class GetPostsSuccess extends CommunityState {}

class GetPostsError extends CommunityState {}

class RequestLocationPermission extends CommunityState {}

class GetLocationSuccess extends CommunityState {}

class GetLocationError extends CommunityState {}

class NoImageSelectedState extends CommunityState {}

class ImageSelectedState extends CommunityState {
  final File file;

  ImageSelectedState(this.file);
}

// Multi-media states
class MultiMediaSelectedState extends CommunityState {
  final List<File> mediaFiles;
  final List<String> mediaTypes;

  MultiMediaSelectedState(this.mediaFiles, this.mediaTypes);
}

class MediaSelectionErrorState extends CommunityState {
  final String error;

  MediaSelectionErrorState(this.error);
}

class UploadImageToStateLoading extends CommunityState {}

class UploadImageToStateSuccess extends CommunityState {}

class UploadImageToStateError extends CommunityState {}

class SocialSuccessRemovePostState extends CommunityState {}

class SocialErrorRemovePostState extends CommunityState {}

class SocialLikePostStateSuccess extends CommunityState {}

class SocialLikePostStateError extends CommunityState {}

class CreateCommentLoadingState extends CommunityState {}

class CreateCommentSuccessState extends CommunityState {}

class CreateCommentErrorState extends CommunityState {}
