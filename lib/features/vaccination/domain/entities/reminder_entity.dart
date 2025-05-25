import 'package:equatable/equatable.dart';

class ReminderEntity extends Equatable {
  final int? id;
  final String reminderType;
  final String reminderFreq;
  final String date;
  final String time;
  final String timeAR;
  final String petId;
  final String petName;
  final String notificationID;
  final String? notes;
  final String? otherTitle;
  final String? subTypeFeed;

  const ReminderEntity({
    this.id,
    required this.reminderType,
    required this.reminderFreq,
    required this.date,
    required this.time,
    required this.timeAR,
    required this.petId,
    required this.petName,
    required this.notificationID,
    this.notes,
    this.otherTitle,
    this.subTypeFeed,
  });

  @override
  List<Object?> get props => [
    id,
    reminderType,
    reminderFreq,
    date,
    time,
    timeAR,
    petId,
    petName,
    notificationID,
    notes,
    otherTitle,
    subTypeFeed,
  ];
}
