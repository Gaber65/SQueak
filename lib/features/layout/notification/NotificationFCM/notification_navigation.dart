import 'dart:convert';
import 'package:flutter/material.dart';

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

      final NotificationType? type = _getNotificationType(typeName);
      final BuildContext? context = navigatorKey.currentContext;

      if (context == null || type == null) {
        print('Navigation failed: context or type is null');
        return;
      }

      print('Navigating for type: $typeName, id: $id');

      switch (type) {
        case NotificationType.NewAppointmentOrReservation:
        case NotificationType.AppointmentCompleted:
        case NotificationType.ReservationReminder:
          getAppointment(id: id, type: type, isNav: true, context: context);
          break;

        case NotificationType.NewPetAdded:
        case NotificationType.VaccinationReminder:
          _navigateToScreen(context, PetScreen());
          break;

        case NotificationType.NewPostAdded:
        case NotificationType.NewCommentOnPost:
          _navigateToScreen(context, PostNotification(id: id));
          break;

        case NotificationType.FollowRequest:
          _navigateToScreen(context, FollowRequestScreen(clinicID: id));
          break;

        default:
          print('Unknown notification type: $typeName');
          break;
      }
    } catch (e) {
      print('Error handling navigation: $e');
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}