import 'notifi_service.dart';

class FirebaseMessagingHandler {
  @pragma('vm:entry-point')
  static void handleNotification(
    String title,
    String body,
    String imageUrl,
    String targetTypeId,
    String targetType,
  ) {
    print(
        'function use to handetitle: $title, body: $body, imageUrl: $imageUrl, targetTypeId: $targetTypeId, targetType: $targetType');
    scheduleMarchNotification(
      title: title,
      body: body,
      id: targetTypeId,
      largeImageUrl: imageUrl,
      typeName: targetType,
    );
  }

  static NotificationType? getNotificationType(String typeName) {
    for (NotificationType type in NotificationType.values) {
      if (type.typeName == typeName) {
        return type;
      }
    }
    return null; // If no match is found
  }
}

enum NotificationType {
  NewAppointmentOrReservation,
  NewCommentOnPost,
  FollowRequest,
  RespondedToFollowRequest,
  VaccinationReminder,
  AppointmentCompleted,
  NewPetAdded,
  NewPostAdded,
  ReservationReminder,
  AcceptFriendRequest,
  Reward,
}

extension NotificationTypeExtension on NotificationType {
  String get typeName {
    switch (this) {
      case NotificationType.NewAppointmentOrReservation:
        return 'NewAppointmentOrReservation';
      case NotificationType.NewCommentOnPost:
        return 'NewCommentOnPost';
      case NotificationType.FollowRequest:
        return 'FollowRequest';
      case NotificationType.RespondedToFollowRequest:
        return 'RespondedToFollowRequest';
      case NotificationType.VaccinationReminder:
        return 'VaccinationReminder';
      case NotificationType.AppointmentCompleted:
        return 'AppointmentCompleted';
      case NotificationType.NewPetAdded:
        return 'NewPetAdded';
      case NotificationType.NewPostAdded:
        return 'NewPostAdded';
      case NotificationType.ReservationReminder:
        return 'ReservationReminder';
      case NotificationType.AcceptFriendRequest:
        return 'AcceptFriendRequest';
      case NotificationType.Reward:
        return 'Rewards';
    }
  }
}
