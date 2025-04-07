

import '../../../core/helper/build_service/firebase_messaging_handler.dart';

class NotificationModel {
  final String message;
  final String eventType;
  final String eventTypeId;
  final String title;
  final String logo;
  final List<NotificationEvent> notificationEvents;
  final String id;
  final String createdAt;
  final bool isActive;
  final bool isDeleted;

  NotificationModel({
    required this.message,
    required this.eventType,
    required this.eventTypeId,
    required this.title,
    required this.logo,
    required this.notificationEvents,
    required this.id,
    required this.createdAt,
    required this.isActive,
    required this.isDeleted,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      message: json['message'],
      eventType: json['eventType'],
      eventTypeId: json['eventTypeId'],
      title: json['title'],
      logo: json['logo'] ?? '',
      notificationEvents: List<NotificationEvent>.from(
        json['notificationEvents'].map((x) => NotificationEvent.fromJson(x)),
      ),
      id: json['id'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
    );
  }

  // Helper method to map event type name to enum
  static NotificationType? getNotificationType(String typeName) {
    try {
      return NotificationType.values.firstWhere(
            (type) => type.toString().split('.').last == typeName,
      );
    } catch (e) {
      return null; // ✅ Ensures safe handling if no match is found
    }
  }
}

class NotificationEvent {
  final bool isRead;
  final String id;
  final bool isView;
  final DateTime viewAt;
  final DateTime sendAt;
  final DateTime readedAt;
  final int notificationStatues;
  final String note;

  NotificationEvent({
    required this.isRead,
    required this.isView,
    required this.viewAt,
    required this.id,
    required this.sendAt,
    required this.readedAt,
    required this.notificationStatues,
    required this.note,
  });

  factory NotificationEvent.fromJson(Map<String, dynamic> json) {
    return NotificationEvent(
      isRead: json['isRead'],
      isView: json['isView'],
      id: json['id'],
      viewAt: DateTime.parse(json['viewAt']),
      sendAt: DateTime.parse(json['sendAt']),
      readedAt: DateTime.parse(json['readedAt']),
      notificationStatues: json['notificationStatues'],
      note: json['note'],
    );
  }
}