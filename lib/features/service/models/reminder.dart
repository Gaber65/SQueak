import '../../pets/models/pet_model.dart';

class Reminder {
  final String type;
  final DateTime date;
  final String frequency;
  final String status;
  final String time;
  final String? note;
  final PetsData petModel;

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
      petModel: PetsData.fromJson(json['petModel']),
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
      'petModel': petModel.toMap(),
    };
  }
}

List<Reminder> reminders = [
  Reminder(
    type: "Flea Treatment",
    date: DateTime.parse("2024-03-01T11:00:00"),
    status: "Scheduled",
    time: "11:00",
    frequency: "Monthly",
    note: "Monthly flea treatment reminder.",
    petModel: PetsData(
      petId: 4,
      petName: "Max",
      breedId: "Golden Retriever",
      isSpayed: false,
      gender: 0,
      isSelected: false,
      specieId: "dog",
      imageName: "max.jpg",
      birthdate: "2020-09-05",
    ),
  ),
  Reminder(
    type: "Vaccination",
    date: DateTime.parse("2024-01-15T08:00:00"),
    status: "Pending",
    time: "08:00",
    frequency: "Once",
    note: "Check for any adverse reactions after vaccination.",
    petModel: PetsData(
      petId: 1,
      petName: "Bella",
      breedId: "Labrador",
      isSpayed: true,
      gender: 1,
      isSelected: false,
      specieId: "dog",
      imageName: "bella.jpg",
      birthdate: "2020-05-15",
    ),
  ),
  Reminder(
    type: "Grooming",
    date: DateTime.parse("2024-01-20T09:00:00"),
    status: "Scheduled",
    time: "09:00",
    frequency: "Every 3 months",
    note: "Ensure proper coat care for optimal health.",
    petModel: PetsData(
      petId: 2,
      petName: "Milo",
      breedId: "Bulldog",
      isSpayed: false,
      gender: 0,
      isSelected: false,
      specieId: "dog",
      imageName: "milo.jpg",
      birthdate: "2021-08-20",
    ),
  ),
];
