import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/models/get_appointment_model.dart';
import 'package:squeak/features/appointments/view/appointments/rate_appointment.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/presentation/controller/notifications_cubit.dart';
import 'package:squeak/features/layout/layout/view/layout.dart';

import '../../../../layout/controller/layout_cubit.dart';
import '../../domain/entities/notification_entities.dart';

Future<void> getAppointment({
  required String id,
  required NotificationType type,
  required BuildContext context,
  required bool isNav,
  NotificationEntities? notification,
  bool? isMainRunning,
}) async {
  print('Handling appointment/reservation: ${notification?.eventType}');
  List<AppointmentModel> appointments = [];
  try {
    Response response = await DioFinalHelper.getData(
      method: createAndGetAppointmentsEndPoint(CacheHelper.getData('phone')),
      language: true,
    );

    appointments =
        (response.data['data']['result'] as List)
            .map((e) => AppointmentModel.fromJson(e))
            .toList();

    AppointmentModel? model;

    // Print the IDs for debugging purposes
    appointments.forEach((element) {
      if (element.id == id) {
        model = element;
        return;
      }
    });

    if (type == NotificationType.NewAppointmentOrReservation ||
        type == NotificationType.ReservationReminder) {
      LayoutCubit.get(context).changeBottomNav(2);
      navigateAndFinish(context, LayoutScreen());
    } else if (type == NotificationType.AppointmentCompleted) {
      navigateToScreen(context, RateAppointment(model: model!, isNav: isNav));
      CacheHelper.saveData('RateModel', model!.toMap());
      NotificationsCubit.get(
        context,
      ).updateNotification(notification!.notificationEvents[0].id);
    }
  } on DioException catch (e) {
    // Handle DioError
    if (isMainRunning == true) {
      navigateAndFinish(context, LayoutScreen());
    }
    print('DioError: ${e.response}');
    // You might want to show an error message to the user or handle it accordingly
  }
}
