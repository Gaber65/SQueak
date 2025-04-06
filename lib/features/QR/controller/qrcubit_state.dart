
abstract class QRState {}

class QRInitial extends QRState {}

class QRLoading extends QRState {}

class QRLoaded extends QRState {
  final bool isAlreadyFollow;
  QRLoaded({required this.isAlreadyFollow});
}

class QRFollowing extends QRState {}

class QRFollowed extends QRState {}

class QRError extends QRState {
  final String error;
  QRError(this.error);
}
class FollowSuccess extends QRState {
  final isHavePet;

  FollowSuccess(this.isHavePet);
}
