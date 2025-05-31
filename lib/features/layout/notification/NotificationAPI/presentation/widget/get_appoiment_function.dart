import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/data/models/appointment_model.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/rate_appointment.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/presentation/controller/notifications_cubit.dart';

import '../../domain/entities/notification_entities.dart';

Future<void> getAppointment({
  required String id,
  required NotificationType type,
  required BuildContext context,
  required bool isNav,
  NotificationEntities? notification,
  bool? isMainRunning,
}) async {
  try {
    final response = await DioFinalHelper.getData(
      method: createAndGetAppointmentsEndPoint(CacheHelper.getData('phone'),false),
      language: true,
    );

    final appointments =
        (response.data['data']['result'] as List)
            .map((e) => AppointmentModel.fromJson(e))
            .toList();

    final model = appointments.firstWhere((e) => e.id == id);

    final action = _determineNavigationAction(type);

    switch (action) {
      case AppointmentNavigationAction.goToHome:
        LayoutCubit.get(context).changeBottomNav(2);
        navigateAndFinish(context, LayoutScreen());
        break;

      case AppointmentNavigationAction.goToRate:
        if (model.id == null) {
          throw Exception('Appointment model not found for rating.');
        }
        navigateToScreen(context, RateAppointment(model: model, isNav: isNav));
        CacheHelper.saveData('RateModel', model.toMap());
        if (notification != null) {
          final notificationId = notification.notificationEvents.first.id;
          NotificationsCubit.get(context).updateNotification(notificationId);
        }
        break;
    }
  } on DioException catch (e) {
    if (isMainRunning == true) {
      navigateAndFinish(context, LayoutScreen());
    }
    debugPrint('DioException: ${e.response}');
  } catch (e) {
    debugPrint('Unexpected error: $e');
  }
}

AppointmentNavigationAction _determineNavigationAction(NotificationType type) {
  switch (type) {
    case NotificationType.NewAppointmentOrReservation:
    case NotificationType.ReservationReminder:
      return AppointmentNavigationAction.goToHome;
    case NotificationType.AppointmentCompleted:
      return AppointmentNavigationAction.goToRate;
    default:
      return AppointmentNavigationAction.goToHome;
  }
}
