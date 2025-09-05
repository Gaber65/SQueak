import 'package:flutter/material.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/layout/notification/NotificationAPI/presentation/controller/notifications_cubit.dart';
import 'package:squeak/features/vetcare/presenation/view/follow_request_screen.dart';

import '../../../../../pets/presentation/view/pet_screen.dart';
import '../../domain/entities/notification_entities.dart';
import '../screens/post_notfication.dart';
import 'get_appoiment_function.dart';

void navigateBasedOnNotification(
    NotificationEntities notification,
    BuildContext context,
    ) {
  final NotificationType notificationType =
      getNotificationType(notification.eventType.name);

  if (notificationType == null) {
    print('Unknown notification type: ${notification.eventType}');
    return;
  }

  switch (notificationType) {
    case NotificationType.VaccinationReminder:
    case NotificationType.NewPetAdded:
      navigateToScreen(context, PetScreen());
      break;

    case NotificationType.FollowRequest:
      NotificationsCubit.get(context)
          .updateNotification(notification.notificationEvents[0].id);
      navigateToScreen(
        context,
        FollowRequestScreen(clinicID: notification.eventTypeId),
      );
      break;

    case NotificationType.NewCommentOnPost:
    case NotificationType.NewPostAdded:
      navigateToScreen(
        context,
        PostNotification(id: notification.eventTypeId),
      );
      break;

    case NotificationType.NewAppointmentOrReservation:
    case NotificationType.AppointmentCompleted:
    case NotificationType.ReservationReminder:
      getAppointment(
        id: notification.eventTypeId,
        type: notificationType,
        isNav: true,
        context: context,
        notification: notification,
      );
      break;

    default:
      print('Unhandled notification type (should not reach here): $notificationType');
      break;
  }
}
