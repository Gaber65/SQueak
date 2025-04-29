import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../../../pets/view/pet_screen.dart';
import '../../../vetcare/view/follow_request_screen.dart';
import '../NotificationAPI/presentation/screens/post_notfication.dart';
import '../NotificationAPI/presentation/widget/get_appoiment_function.dart';


void handleNavigation(String payload) {
  final Map<String, dynamic> data = jsonDecode(payload);
  final String id = data['id'] ?? '';
  final String typeName = data['typeName'] ?? '';

  final NotificationType? type = getNotificationType(typeName);
  final BuildContext? context = navigatorKey.currentContext;

  if (context == null || type == null) return;

  switch (type) {
    case NotificationType.NewAppointmentOrReservation:
    case NotificationType.AppointmentCompleted:
    case NotificationType.ReservationReminder:
      getAppointment(id: id, type: type, isNav: true, context: context);
      break;
    case NotificationType.NewPetAdded:
    case NotificationType.VaccinationReminder:
      navigateToScreen(context, PetScreen());
      break;
    case NotificationType.NewPostAdded:
    case NotificationType.NewCommentOnPost:
      navigateToScreen(context, PostNotification(id: id));
      break;
    case NotificationType.FollowRequest:
      navigateToScreen(context, FollowRequestScreen(ClinicID: id));
      break;
    default:
      break;
  }
}
