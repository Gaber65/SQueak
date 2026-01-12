// ignore_for_file: unrelated_type_equality_checks

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../NotificationFCM/notification_message.dart';

class NotificationEntities {
  final String message;
  final NotificationType eventType;
  final String eventTypeId;
  final String arMessage;
  final String arTitle;
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
    required this.arTitle,
    required this.arMessage,

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

  NotificationEntities copyWith({
    String? message,
    NotificationType? eventType,
    String? eventTypeId,
    String? title,
    String? logo,
    List<NotificationEventEntities>? notificationEvents,
    String? id,
    String? createdAt,
    String? arTitle,
    String? arMessage,
    bool? isActive,
    bool? isDeleted,
  }) {
    return NotificationEntities(
      message: message ?? this.message,
      eventType: eventType ?? this.eventType,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      title: title ?? this.title,
      logo: logo ?? this.logo,
      notificationEvents: notificationEvents ?? this.notificationEvents,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      arTitle: arTitle ?? this.arTitle,
      arMessage: arMessage ?? this.arMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'eventType': eventType.name.toString(),
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

NotificationEntities notificationMessageToEntity(NotificationMessage msg) {
  final data = msg.data;

  return NotificationEntities(
    message: data?.body ?? '',
    eventType: NotificationType.values.firstWhere(
      (e) =>
          e.toString().split('.').last.toLowerCase() ==
          (data?.targetType ?? '').toLowerCase(),
      orElse: () => NotificationType.NewPostAdded, // default لو تحب تغيّر
    ),
    eventTypeId: data?.targetTypeId ?? '',
    title: data?.title ?? '',
    logo: data?.imageUrl ?? '',
    notificationEvents: const [], // لو مش محتاجها للنافجيشن
    id: msg.messageId ?? '',
    createdAt: DateTime.now().toIso8601String(),
    isActive: true,
    isDeleted: false,
    arMessage: '',
    arTitle: '',
  );
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

  NotificationEventEntities copyWith({
    bool? isRead,
    bool? isView,
    DateTime? viewAt,
    String? id,
    DateTime? sendAt,
    DateTime? readedAt,
    int? notificationStatues,
    String? note,
  }) {
    return NotificationEventEntities(
      isRead: isRead ?? this.isRead,
      isView: isView ?? this.isView,
      viewAt: viewAt ?? this.viewAt,
      id: id ?? this.id,
      sendAt: sendAt ?? this.sendAt,
      readedAt: readedAt ?? this.readedAt,
      notificationStatues: notificationStatues ?? this.notificationStatues,
      note: note ?? this.note,
    );
  }

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
