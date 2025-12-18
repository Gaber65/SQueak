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

  Future<void> fetchNotifications({bool isRefreshing = false}) async {
    final currentState = state;

    if (currentState is NotificationsStateData) {
      // Don't show loading for refresh, just show refreshing state
      if (!isRefreshing) {
        emit(currentState.copyWith(isLoading: true, errorMessage: null));
      } else {
        emit(currentState.copyWith(isRefreshing: true, errorMessage: null));
      }
    }

    final result = await getAllNotificationsUseCase(const NoParameters());

    result.fold(
      (failure) {
        if (state is NotificationsStateData) {
          final currentState = state as NotificationsStateData;
          emit(
            currentState.copyWith(
              isLoading: false,
              isRefreshing: false,
              errorMessage: 'Failed to load notifications',
            ),
          );
        }
      },
      (notificationsList) {
        final filteredNotifications =
            notificationsList.reversed.toList().where((element) {
              if (element.notificationEvents.isEmpty) {
                return false;
              }
              return element.notificationEvents.first.isRead == false;
            }).toList();

        CacheHelper.saveData('notificationsNum', filteredNotifications.length);

        if (state is NotificationsStateData) {
          final currentState = state as NotificationsStateData;
          emit(
            currentState.copyWith(
              notifications: filteredNotifications,
              isLoading: false,
              isRefreshing: false,
              errorMessage: null,
            ),
          );
        }
      },
    );
  }

  Future<void> updateNotification(String id) async {
    final currentState = state;

    if (currentState is NotificationsStateData) {
      emit(currentState.copyWith(isLoading: true, errorMessage: null));
    }

    final result = await updateNotificationStateUseCase(id);

    result.fold(
      (failure) {
        if (state is NotificationsStateData) {
          final currentState = state as NotificationsStateData;
          emit(
            currentState.copyWith(
              isLoading: false,
              errorMessage: 'Failed to update notification',
            ),
          );
        }
      },
      (_) async {
        await fetchNotifications();
      },
    );
  }

  Future<void> getPostNotification(String postId) async {
    final currentState = state;

    if (currentState is NotificationsStateData) {
      emit(
        currentState.copyWith(
          isLoadingPost: true,
          postFound: false,
          postModel: null,
          errorMessage: null,
        ),
      );
    }

    final result = await getPostNotificationUseCase(postId);

    result.fold(
      (failure) {
        if (state is NotificationsStateData) {
          final currentState = state as NotificationsStateData;
          emit(
            currentState.copyWith(
              isLoadingPost: false,
              errorMessage: 'Failed to load post',
            ),
          );
        }
      },
      (r) {
        try {
          final postModel = r.firstWhere((element) => element.postId == postId);

          if (state is NotificationsStateData) {
            final currentState = state as NotificationsStateData;
            emit(
              currentState.copyWith(
                posts: r,
                postModel: postModel,
                postFound: true,
                isLoadingPost: false,
                errorMessage: null,
              ),
            );
          }
        } catch (_) {
          // postId not found in the list
          if (state is NotificationsStateData) {
            updateNotification(postId);
            final currentState = state as NotificationsStateData;
            emit(
              currentState.copyWith(
                posts: r,
                postModel: null,
                postFound: false,
                isLoadingPost: false,
                errorMessage: 'Post not found',
              ),
            );
          }
        }
      },
    );
  }
}
