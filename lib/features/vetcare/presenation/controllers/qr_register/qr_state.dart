import 'package:equatable/equatable.dart';

import '../../../domain/entities/vet_client.dart';

abstract class QRState extends Equatable {
  const QRState();

  @override
  List<Object> get props => [];
}

class QRInitial extends QRState {}

class QRLoading extends QRState {}

class QRLoaded extends QRState {
  final bool isAlreadyFollow;

  const QRLoaded({required this.isAlreadyFollow});

  @override
  List<Object> get props => [isAlreadyFollow];
}

class QRFollowing extends QRState {}

class QRFollowed extends QRState {}

class QRVetClientsLoaded extends QRState {
  final List<VetClient> clients;

  const QRVetClientsLoaded({required this.clients});

  @override
  List<Object> get props => [clients];
}

class QRFollowSuccess extends QRState {
  final bool success;

  const QRFollowSuccess(this.success);

  @override
  List<Object> get props => [success];
}

class QRError extends QRState {
  final String message;

  const QRError(this.message);

  @override
  List<Object> get props => [message];
}
