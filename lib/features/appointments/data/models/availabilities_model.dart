import 'package:flutter/material.dart';

class AvailabilityModel {
  AvailabilityModel({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.note,
    required this.isActive,
    required this.endTime,
    this.isDisabled = false,
  });

  final String id;
  final DayOfWeek dayOfWeek;
  final String startTime;
  final String endTime;
  final String note;
  bool isActive;
  bool isDisabled = false;

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

enum DayOfWeek {
  sunday, // 0
  monday, // 1
  tuesday, // 2
  wednesday, // 3
  thursday, // 4
  friday, // 5
  saturday, // 6
}

extension DayOfWeekExtension on DayOfWeek {
  static DayOfWeek fromInt(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0:
        return DayOfWeek.sunday;
      case 1:
        return DayOfWeek.monday;
      case 2:
        return DayOfWeek.tuesday;
      case 3:
        return DayOfWeek.wednesday;
      case 4:
        return DayOfWeek.thursday;
      case 5:
        return DayOfWeek.friday;
      case 6:
        return DayOfWeek.saturday;
      default:
        throw Exception('Invalid day of week');
    }
  }

  int toInt() {
    switch (this) {
      case DayOfWeek.sunday:
        return 0;
      case DayOfWeek.monday:
        return 1;
      case DayOfWeek.tuesday:
        return 2;
      case DayOfWeek.wednesday:
        return 3;
      case DayOfWeek.thursday:
        return 4;
      case DayOfWeek.friday:
        return 5;
      case DayOfWeek.saturday:
        return 6;
    }
  }
}

List<TimeOfDay> generateTimeSlots(TimeOfDay startTime, TimeOfDay endTime) {
  List<TimeOfDay> timeSlots = [];

  // Initialize variables for looping through time range
  int startHour = startTime.hour;
  int startMinute = startTime.minute;
  int endHour = endTime.hour;
  int endMinute = endTime.minute;

  // Loop through time range and generate time slots
  int currentHour = startHour;
  int currentMinute = startMinute;

  while (currentHour < endHour ||
      (currentHour == endHour && currentMinute <= endMinute)) {
    timeSlots.add(TimeOfDay(hour: currentHour, minute: currentMinute));

    // Increment time by 1 hour
    currentHour++;
  }

  return timeSlots;
}
