// lib/utils/notification_helpers.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/utils/enums/notification_type_enums.dart';
import '../../domain/entities/notification_entities.dart';

// Map NotificationType to Material Icons
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
    default:
      return Icons.notifications; // Fallback icon
  }
}

// Map NotificationType to Flutter Colors
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
    default:
      return Colors.grey; // Fallback color
  }
}

// Utility to format time (e.g., "5 minutes ago")
String formatTimeAgo(DateTime dateTime) {
  final Duration diff = DateTime.now().difference(dateTime);

  if (diff.inSeconds < 60) {
    return '${diff.inSeconds} seconds ago';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} minutes ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} hours ago';
  } else if (diff.inDays < 30) {
    return '${diff.inDays} days ago';
  } else if (diff.inDays < 365) {
    return '${(diff.inDays / 30).floor()} months ago';
  } else {
    return '${(diff.inDays / 365).floor()} years ago';
  }
}
