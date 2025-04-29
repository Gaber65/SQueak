
import '../../pets/data/models/pet_model.dart';

class Reminder {
  final String type;
  final DateTime date;
  final String frequency;
  final String status;
  final String time;
  final String? note;
  final PetData petModel;

  Reminder({
    required this.type,
    required this.date,
    required this.status,
    required this.petModel,
    required this.time,
    required this.frequency,
    this.note,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      type: json['type'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      time: json['time'],
      frequency: json['frequency'],
      note: json['note'],
      petModel: PetData.fromJson(json['petModel']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'date': date.toIso8601String(),
      'status': status,
      'time': time,
      'frequency': frequency,
      'note': note,
      'petModel': petModel,
    };
  }
}

