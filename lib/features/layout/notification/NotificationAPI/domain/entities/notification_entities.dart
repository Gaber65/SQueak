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
}
