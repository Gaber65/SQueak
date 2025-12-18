// ignore_for_file: unrelated_type_equality_checks

import 'package:squeak/core/utils/export_path/export_files.dart';

class NotificationEntities {
  final String message;
  final NotificationType eventType;
  final String eventTypeId;
  final String title;
  final String logo;
  final List<NotificationEventEntities> notificationEvents;
  final String id;
  final String createdAt;
  final bool isActive;
  final bool isDeleted;

  NotificationEntities({
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

  static NotificationType? getNotificationType(NotificationType typeName) {
    try {
      return NotificationType.values.firstWhere(
        (type) => type.toString().split('.').last == typeName,
      );
    } catch (e) {
      return null;
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'eventType': eventType.toString(),
      'eventTypeId': eventTypeId,
      'title': title,
      'logo': logo,
      'notificationEvents': notificationEvents.map((e) => e.toJson()).toList(),
      'id': id,
      'createdAt': createdAt,
      'isActive': isActive,
      'isDeleted': isDeleted,
    };
  }

}

class NotificationEventEntities {
  final bool isRead;
  final String id;
  final bool isView;
  final DateTime viewAt;
  final DateTime sendAt;
  final DateTime readedAt;
  final int notificationStatues;
  final String note;

  NotificationEventEntities({
    required this.isRead,
    required this.isView,
    required this.viewAt,
    required this.id,
    required this.sendAt,
    required this.readedAt,
    required this.notificationStatues,
    required this.note,
  });


  Map<String, dynamic> toJson() {
    return {
      'isRead': isRead,
      'isView': isView,
      'viewAt': viewAt.toIso8601String(),
      'id': id,
      'sendAt': sendAt.toIso8601String(),
      'readedAt': readedAt.toIso8601String(),
      'notificationStatues': notificationStatues,
      'note': note,
    };
  }
}
