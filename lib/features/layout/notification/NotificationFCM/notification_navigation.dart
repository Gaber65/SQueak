import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:squeak/features/appointments/boarding/domain/entities/boarding_entry_entity.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../../../pets/presentation/view/pet_screen.dart';
import '../../../vetcare/presenation/view/follow_request_screen.dart';
import '../NotificationAPI/presentation/screens/post_notfication.dart';
import '../NotificationAPI/presentation/widget/get_appoiment_function.dart';

class NotificationNavigation {
  /// Handle navigation based on notification payload
  static void handleNavigation(String payload) {
    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      final String id = data['id'] ?? '';
      final String typeName = data['typeName'] ?? '';

      final NotificationType? notificationType = _getNotificationType(typeName);
      final BuildContext? context = navigatorKey.currentContext;

      if (context == null || notificationType == null) {
        // print('Navigation failed: context or type is null');
        return;
      }


      switch (notificationType) {
        case NotificationType.VaccinationReminder:
        case NotificationType.NewPetAdded:
          navigateToScreen(context, PetScreen());
          break;

        case NotificationType.FollowRequest:
          navigateToScreen(context, FollowRequestScreen(clinicID: id));
          break;

        case NotificationType.NewCommentOnPost:
        case NotificationType.NewPostAdded:
        case NotificationType.NewCommentOnYourPost:
        case NotificationType.NewReactionOnPost:
        case NotificationType.NewPetCommentOnPost:
          navigateToScreen(context, PostNotification(postId: id));
          break;

        case NotificationType.NewAppointmentOrReservation:
        case NotificationType.AppointmentCompleted:
        case NotificationType.ReservationReminder:
          getAppointment(id: id, type: notificationType, context: context);
          break;

        case NotificationType.BoardingCheckOut:
        case NotificationType.BoardingPartialPaided:
        case NotificationType.BoardingPaided:
        case NotificationType.NewBoardingImage:
          getBaording(id: id, type: notificationType, context: context);
          break;

        default:
          break;
      }
    } catch (e) {
      // print('Error handling navigation: $e');
    }
  }

  /// Get notification type from string
  static NotificationType? _getNotificationType(String typeName) {
    for (NotificationType type in NotificationType.values) {
      if (type.typeName == typeName) {
        return type;
      }
    }
    return null;
  }

  /// Navigate to screen helper
  static void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
