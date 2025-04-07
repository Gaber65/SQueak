import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';

import '../../../../core/helper/remotely/dio.dart';
import '../../../../core/helper/remotely/end-points.dart';
import '../../models/Notification_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  static NotificationsCubit get(context) => BlocProvider.of(context);
  List<NotificationModel> notifications = [];

  Future getNotifications() async {
    emit(NotificationsLoadingState());
    try {
      Response response = await DioFinalHelper.getData(
        method: '$version/notifications',
        language: true,
      );

      notifications = (response.data['data']['notificationDtos'] != null)
          ? (response.data['data']['notificationDtos'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList()
          : [];
      notifications = notifications.reversed.toList();
      CacheHelper.saveData('notificationsNum', notifications.length);
      emit(NotificationsSuccessState());
    } on DioException catch (e) {
      print(e.response!.data);
      emit(NotificationsErrorState());
    }
  }

  Future updateState(id) async {
    print('UpdateState');
    emit(NotificationsLoadingState());
    try {
      Response response = await DioFinalHelper.putData(
        method: '$version/notifications/$id',
        data: {},
      );
      getNotifications();
      print(response.data);
      emit(NotificationsSuccessState());
    } on DioException catch (e) {
      print(e.response!.data);
      emit(NotificationsErrorState());
    }
  }
}
