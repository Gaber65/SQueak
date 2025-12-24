import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/friendship/presentation/pages/pet_friend_layout.dart';

import 'package:squeak/features/layout/notification/NotificationAPI/presentation/controller/notifications_cubit.dart';
import 'package:squeak/features/mating/chat/presentation/screens/rating_pet_mating.dart';
import 'package:squeak/features/mating/layoutMating/presentation/screens/mating_layout.dart';
import 'package:squeak/features/vetcare/presenation/view/follow_request_screen.dart';

import '../../../../../mating/chat/presentation/controllers/chat_messages_cubit.dart';
import '../../../../../pets/presentation/view/pet_screen.dart';
import '../../domain/entities/notification_entities.dart';
import '../screens/custom_message_notification_screen.dart';
import '../screens/post_notfication.dart';
import 'get_appoiment_function.dart';

void navigateBasedOnNotification(
  NotificationEntities notification,
  BuildContext context,
) {
  final NotificationType notificationType = getNotificationType(
    notification.eventType.name,
  );

  switch (notificationType) {
    case NotificationType.VaccinationReminder:
    case NotificationType.NewPetAdded:
    case NotificationType.QrCodeNotification:
      navigateToScreen(context, PetScreen());
      break;

    case NotificationType.FollowRequest:
      NotificationsCubit.get(
        context,
      ).updateNotification(notification.notificationEvents[0].id);
      navigateToScreen(
        context,
        FollowRequestScreen(clinicID: notification.eventTypeId),
      );
      break;

    case NotificationType.NewCommentOnPost:
    case NotificationType.NewPostAdded:
    case NotificationType.NewCommentOnYourPost:
    case NotificationType.NewReactionOnPost:
    case NotificationType.NewPetCommentOnPost:
      navigateToScreen(
        context,
        PostNotification(postId: notification.eventTypeId),
      );
      break;

    case NotificationType.NewAppointmentOrReservation:
    case NotificationType.AppointmentCompleted:
    case NotificationType.ReservationReminder:
      getAppointment(
        id: notification.eventTypeId,
        type: notificationType,
        context: context,
      );
      break;
    case NotificationType.CustomeMessage:
      navigateToScreen(
        context,
        CustomMessageNotificationScreen(notification: notification),
      );
    case NotificationType.BoardingCheckOut:
    case NotificationType.BoardingPartialPaided:
    case NotificationType.BoardingPaided:
    case NotificationType.NewBoardingImage:
      getBaording(
        id: notification.eventTypeId,
        type: notificationType,
        context: context,
      );
      break;
    case NotificationType.StoryReaction:
    case NotificationType.StoryViewed:
    case NotificationType.ReplyOnStory:
    case NotificationType.NewStory:
      getStroy(
        id: notification.eventTypeId,
        type: notificationType,
        context: context,
      );
      break;
    case NotificationType.AcceptMatingRequest:
      navigateToScreen(context, MatingLayoutScreen(indexID: 2));
      break;
    case NotificationType.SendMatingRequest:
      navigateToScreen(context, MatingLayoutScreen(indexID: 2));
      break;
    case NotificationType.PetMarriage:
    case NotificationType.Discover:
    case NotificationType.Pregenant:
    case NotificationType.MakePetAvaliable:
    case NotificationType.SetBaby:
    case NotificationType.CheckPrepegant:
      navigateToScreen(context, MatingLayoutScreen(indexID: 3));
      break;
    case NotificationType.MatingRate:
      navigateToScreen(
        context,
        BlocProvider<ChatMessagesCubit>(
          create: (_) => sl<ChatMessagesCubit>(),
          child: PetMatingRatingScreen(
            matingId: notification.eventTypeId,
            cubit: sl<ChatMessagesCubit>(),
          ),
        ),
      );
      break;
    case NotificationType.NewFriendRequest:
    case NotificationType.AcceptFriendRequest:
    case NotificationType.AcceptPetFriendShipRequest:
    case NotificationType.NewPetFriendRequest:
      navigateToScreen(context, FriendsScreen());
      break;

    default:

      break;
  }
}
