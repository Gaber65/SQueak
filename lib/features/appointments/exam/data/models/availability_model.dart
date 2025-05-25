import 'package:squeak/core/utils/enums/dayOfWeek_enum.dart';
import 'package:squeak/features/appointments/exam/domain/entities/availability_entities.dart';

class AvailabilityModel extends Availability {
  const AvailabilityModel({
    required super.id,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    required super.note,
    required super.isActive,
    super.isDisabled = false,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      id: json['id'],
      dayOfWeek: DayOfWeekExtension.fromInt(json['dayOfWeek']),
      startTime: json['startTime'],
      note: json['note'] ?? '',
      isActive: json['isActive'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek.toInt(),
      'startTime': startTime,
      'note': note,
      'isActive': isActive,
      'endTime': endTime,
    };
  }
}