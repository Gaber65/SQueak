import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/domain/entities/notification_entities.dart';

class NotificationModel extends NotificationEntities {
  NotificationModel({
    required super.message,
    required super.eventType,
    required super.eventTypeId,
    required super.title,
    required super.logo,
    required super.notificationEvents,
    required super.id,
    required super.createdAt,
    required super.isActive,
    required super.isDeleted,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      message: json['message'],
      eventType: getNotificationType(json['eventType']),
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
}

class NotificationEvent extends NotificationEventEntities {
  NotificationEvent({
    required super.isRead,
    required super.isView,
    required super.viewAt,
    required super.id,
    required super.sendAt,
    required super.readedAt,
    required super.notificationStatues,
    required super.note,
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
