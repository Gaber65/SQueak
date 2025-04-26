import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../domain/entities/notification_entities.dart';

IconData getNotificationIcon(NotificationEntities notification) {
  NotificationType? notificationType = NotificationEntities.getNotificationType(
    notification.eventType,
  );
  switch (notificationType) {
    case NotificationType.NewAppointmentOrReservation:
      return Icons.event_note; // Use a calendar or event-related icon
    case NotificationType.NewCommentOnPost:
      return Icons.comment; // Use a comment-related icon
    case NotificationType.FollowRequest:
      return Icons.person_add; // Use an icon for follow requests
    case NotificationType.RespondedToFollowRequest:
      return Icons.person; // Use a person icon for follow responses
    case NotificationType.VaccinationReminder:
      return Icons.vaccines; // Use an icon related to health or vaccines
    case NotificationType.AppointmentCompleted:
      return Icons.check_circle; // Use a checkmark icon for completion
    case NotificationType.NewPetAdded:
      return Icons.pets; // Use a pet-related icon
    case NotificationType.NewPostAdded:
      return Icons.post_add; // Use a post-related icon
    case NotificationType.ReservationReminder:
      return Icons.alarm; // Use an alarm or reminder icon
    default:
      return Icons.notifications; // Fallback to default notification icon
  }
}
