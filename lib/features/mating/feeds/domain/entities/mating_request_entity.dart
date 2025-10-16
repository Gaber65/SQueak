import 'package:equatable/equatable.dart';

class MatingRequestEntity extends Equatable {
  final String id;
  final String senderPetId;
  final String receiverPetId;
  final String status; // e.g., 'pending', 'accepted', 'rejected'
  final DateTime requestDate;
  final String? message;

  const MatingRequestEntity({
    required this.id,
    required this.senderPetId,
    required this.receiverPetId,
    required this.status,
    required this.requestDate,
    this.message,
  });

  @override
  List<Object?> get props => [id, senderPetId, receiverPetId, status, requestDate, message];
}
