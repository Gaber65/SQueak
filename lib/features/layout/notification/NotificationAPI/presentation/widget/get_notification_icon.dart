import 'package:flutter/material.dart';

import '../../../../../../core/utils/enums/notification_type_enums.dart';
import '../../domain/entities/notification_entities.dart';

IconData getNotificationIcon(NotificationEntities notification) {
  switch (notification.eventType) {
    case NotificationType.NewAppointmentOrReservation:
      return Icons.event_note;
    case NotificationType.NewCommentOnYourPost:
    case NotificationType.NewCommentOnPost:
      return Icons.comment;
    case NotificationType.FollowRequest:
    case NotificationType.NewFriendRequest:
      return Icons.person_add;
    case NotificationType.RespondedToFollowRequest:
    case NotificationType.AcceptFriendRequest:
      return Icons.person;
    case NotificationType.VaccinationReminder:
      return Icons.vaccines;
    case NotificationType.AppointmentCompleted:
      return Icons.check_circle;
    case NotificationType.NewPetAdded:
      return Icons.pets;
    case NotificationType.NewPostAdded:
      return Icons.post_add;
    case NotificationType.ReservationReminder:
      return Icons.alarm;
    case NotificationType.BoardingCheckOut:
      return Icons.logout;
    case NotificationType.BoardingPartialPaided:
    case NotificationType.BoardingPaided:
      return Icons.credit_card;
    case NotificationType.NewFollower:
      return Icons.group_add;
    case NotificationType.CustomeMessage:
      return Icons.message;
    case NotificationType.NewReactionOnPost:
      return Icons.favorite;
    case NotificationType.AddWalletReward:
      return Icons.card_giftcard;
    case NotificationType.AndroidCustomeNotification:
    case NotificationType.IOSCustomeNotification:
    case NotificationType.AndroidAndIOSCustomeNotification:
      return Icons.smartphone;
    case NotificationType.QrCodeNotification:
      return Icons.qr_code;
    case NotificationType.NewBoardingImage:
      return Icons.image;
    case NotificationType.Unknown:
    default:
      return Icons.notifications;
  }
}

Color getNotificationColor(NotificationEntities notification) {
  switch (notification.eventType) {
    case NotificationType.NewBoardingImage:
      return Colors.deepPurple;
    case NotificationType.NewAppointmentOrReservation:
      return Colors.blue;
    case NotificationType.NewCommentOnYourPost:
    case NotificationType.NewCommentOnPost:
      return Colors.green;
    case NotificationType.FollowRequest:
    case NotificationType.NewFriendRequest:
      return Colors.orange;
    case NotificationType.RespondedToFollowRequest:
    case NotificationType.AcceptFriendRequest:
      return Colors.teal;
    case NotificationType.VaccinationReminder:
      return Colors.red;
    case NotificationType.AppointmentCompleted:
      return Colors.purple;
    case NotificationType.NewPetAdded:
      return Colors.brown;
    case NotificationType.NewPostAdded:
      return Colors.indigo;
    case NotificationType.ReservationReminder:
      return Colors.amber;
    case NotificationType.BoardingCheckOut:
      return Colors.pink;
    case NotificationType.BoardingPartialPaided:
    case NotificationType.BoardingPaided:
      return Colors.lime;
    case NotificationType.NewFollower:
      return Colors.cyan;
    case NotificationType.CustomeMessage:
      return Colors.deepOrange;
    case NotificationType.NewReactionOnPost:
      return Colors.pinkAccent;
    case NotificationType.AddWalletReward:
      return Colors.green;
    case NotificationType.AndroidCustomeNotification:
    case NotificationType.IOSCustomeNotification:
    case NotificationType.AndroidAndIOSCustomeNotification:
      return Colors.grey;
    case NotificationType.QrCodeNotification:
      return Colors.blueGrey;
    case NotificationType.Unknown:
    default:
      return Colors.grey;
  }
}
