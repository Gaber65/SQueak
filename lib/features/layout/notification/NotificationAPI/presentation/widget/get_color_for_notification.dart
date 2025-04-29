import 'package:flutter/material.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../domain/entities/notification_entities.dart';

Color getColorForNotification(NotificationEntities notification) {
  NotificationType? notificationType = NotificationEntities.getNotificationType(
    notification.eventType,
  );
  switch (notificationType) {
    case NotificationType.NewAppointmentOrReservation:
      return Colors.blue.withOpacity(0.5);
    case NotificationType.NewCommentOnPost:
      return Colors.green.withOpacity(0.5);
    case NotificationType.FollowRequest:
      return Colors.orange.withOpacity(0.5);
    case NotificationType.RespondedToFollowRequest:
      return Colors.teal.withOpacity(0.5);
    case NotificationType.VaccinationReminder:
      return Colors.red.withOpacity(0.5);
    case NotificationType.AppointmentCompleted:
      return Colors.purple.withOpacity(0.5);
    case NotificationType.NewPetAdded:
      return Colors.brown.withOpacity(0.5);
    case NotificationType.NewPostAdded:
      return Colors.indigo.withOpacity(0.5);
    case NotificationType.ReservationReminder:
      return Colors.amber.withOpacity(0.5);
    default:
      return Colors.grey.withOpacity(0.5); // Fallback color
  }
}
