import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../../../../core/utils/export_path/export_files.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../domain/entities/notification_entities.dart';
import '../../domain/usecase/get_all_notifications_use_case.dart';
import '../../domain/usecase/get_post_notification_use_case.dart';
import '../../domain/usecase/update_notification_state_use_case.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  GetAllNotificationsUseCase getAllNotificationsUseCase;
  UpdateNotificationStateUseCase updateNotificationStateUseCase;
  GetPostNotificationUseCase getPostNotificationUseCase;

  NotificationsCubit(
    this.getAllNotificationsUseCase,
    this.updateNotificationStateUseCase,
    this.getPostNotificationUseCase,
  ) : super(NotificationsInitial());

  static NotificationsCubit get(context) => BlocProvider.of(context);

  List<NotificationEntities> notifications = [];

  Future<void> fetchNotifications() async {
    emit(NotificationsLoadingState());
    final result = await getAllNotificationsUseCase(const NoParameters());

    result.fold(
      (failure) {
        emit(NotificationsErrorState());
      },
      (notificationsList) {
        notifications = notificationsList.reversed.toList();
        CacheHelper.saveData('notificationsNum', notifications.length);
        emit(NotificationsSuccessState());
      },
    );
  }

  Future<void> updateNotification(String id) async {
    emit(NotificationsLoadingState());
    final result = await updateNotificationStateUseCase(id);

    result.fold(
      (failure) {
        emit(NotificationsErrorState());
      },
      (_) async {
        await fetchNotifications();
      },
    );
  }

  List<PostEntity> post = [];
  PostEntity? postModel;
  bool isLoadingPost = false;
  Future<void> getPostNotification(String postId) async {
    emit(NotificationsLoadingState());
    final result = await getPostNotificationUseCase(postId);

    result.fold(
      (failure) {
        emit(NotificationsErrorState());
      },
      (r) async {
        post = r;
        if (post.any((element) => element.postId == postId)) {
          postModel = post.firstWhere((element) => element.postId == postId);
          print('Post found: $postModel');
        } else {
          emit(GetPostError());
        }
        emit(NotificationsSuccessState());
      },
    );
  }
}
