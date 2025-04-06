import 'package:flutter/material.dart';

class ReminderModel {
  int? id;
  String reminderType;/// qqqqqqqqqqqqqqqqqqqqqqqq
  String reminderFreq;/// qqqqqqqqqqqqqqqqqqqqqqqq
  String date;/// qqqqqqqqqqqqqqqqqqqqqqqq
  String time;/// qqqqqqqqqqqqqqqqqqqqqqqq
  String timeAR;/// qqqqqqqqqqqqqqqqqqqqqqqq
  String petId;///
  String petName;
  String notificationID;
  String? notes;///qqqqqqqqqqqqqqqqqqqqqqqq
  String? otherTitle;///qqqqqqqqqqqqqqqqqqqqqqqq
  String? subTypeFeed;///qqqqqqqqqqqqqqqqqqqqqqqq

  ReminderModel({
    this.id,
    required this.reminderType,
    required this.reminderFreq,
    required this.date,
    required this.time,
    required this.petId,
    required this.notificationID,
    required this.timeAR,
    required this.petName,
    this.notes,
    this.otherTitle,
    this.subTypeFeed,
  });

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
