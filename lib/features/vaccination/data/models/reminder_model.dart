import '../../domain/entities/reminder_entity.dart';

class ReminderModel extends ReminderEntity {
  const ReminderModel({
    super.id,
    required super.reminderType,
    required super.reminderFreq,
    required super.date,
    required super.time,
    required super.timeAR,
    required super.petId,
    required super.petName,
    required super.notificationID,
    super.notes,
    super.otherTitle,
    super.vaccinationId,
    super.subTypeFeed,
  });

  factory ReminderModel.fromEntity(ReminderEntity entity) {
    return ReminderModel(
      id: entity.id,
      reminderType: entity.reminderType,
      reminderFreq: entity.reminderFreq,
      date: entity.date,
      time: entity.time,
      timeAR: entity.timeAR,
      petId: entity.petId,
      petName: entity.petName,
      notificationID: entity.notificationID,
      notes: entity.notes,
      otherTitle: entity.otherTitle,
      subTypeFeed: entity.subTypeFeed,
      vaccinationId: entity.vaccinationId,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reminderType': reminderType,
      'reminderFreq': reminderFreq,
      'date': date,
      'time': time,
      'timeAR': timeAR,
      'notes': notes,
      'subTypeFeed': subTypeFeed,
      'petId': petId,
      'notificationID': notificationID,
      'petName': petName,
      'otherTitle': otherTitle,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      reminderType: map['reminderType'],
      reminderFreq: map['reminderFreq'],
      date: map['date'],
      timeAR: map['timeAR'],
      time: map['time'],
      notes: map['notes'],
      otherTitle: map['otherTitle'],
      subTypeFeed: map['subTypeFeed'],
      petId: map['petId'],
      notificationID: map['notificationID'],
      petName: map['petName'],
    );
  }
}
