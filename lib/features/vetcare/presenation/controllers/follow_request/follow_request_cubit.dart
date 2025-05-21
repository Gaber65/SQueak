import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_case/follow_request_usecase.dart';


part 'follow_request_state.dart';

class FollowRequestCubit extends Cubit<FollowRequestState> {
  final AcceptInvitationUseCase acceptInvitationUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;
  final UpdateNotificationToVetStateUseCase updateNotificationStateUseCase;

  FollowRequestCubit({
    required this.acceptInvitationUseCase,
    required this.getNotificationsUseCase,
    required this.updateNotificationStateUseCase,
  }) : super(FollowRequestInitial());

  static FollowRequestCubit get(context) => BlocProvider.of(context);

  // State variables
  bool isAccept = false;
  bool isFollowBefore = false;
  final List<dynamic> notifications = [];

  Future<void> acceptInvitation({
    required String clinicCode,
    required String clientId,
    required String squeakUserId,
  }) async {
    isAccept = true;
    emit(LoadingAcceptIvationState());

    final params = AcceptInvitationParams(
      clinicCode: clinicCode,
      clientId: clientId,
      squeakUserId: squeakUserId,
    );

    final result = await acceptInvitationUseCase(params);

    result.fold(
      (failure) {
        isAccept = false;
        emit(ErrorAcceptIvationState(failure.error));
      },
      (hasValidPets) {
        isAccept = false;
        emit(SuccessAcceptIvationState(hasValidPets));
      },
    );
  }

  Future<void> getNotifications(String id) async {
    emit(NotificationsLoadingState());

    final result = await getNotificationsUseCase(id);

    result.fold(
      (failure) {
        emit(NotificationsErrorState());
      },
      (notificationsList) {
        notifications.clear();
        notifications.addAll(notificationsList);
        
        // Check if we need to update a specific notification
        for (final element in notifications) {
          if (element['notificationEvents'] != null && 
              element['notificationEvents'].isNotEmpty &&
              element['notificationEvents'][0]['id'] == id) {
            updateNotificationState(id);
            break;
          }
        }
        
        emit(NotificationsSuccessState());
      },
    );
  }

  Future<void> updateNotificationState(String id) async {
    emit(NotificationsLoadingState());

    final result = await updateNotificationStateUseCase(id);

    result.fold(
      (failure) {
        emit(NotificationsErrorState());
      },
      (_) {
        emit(NotificationsSuccessState());
      },
    );
  }
}