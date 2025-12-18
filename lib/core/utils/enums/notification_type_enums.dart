// ignore_for_file: constant_identifier_names

enum NotificationType {
  NewAppointmentOrReservation,
  NewCommentOnYourPost,
  NewCommentOnPost,
  FollowRequest,
  RespondedToFollowRequest,
  VaccinationReminder,
  NewFollower,
  AppointmentCompleted,
  NewPetAdded,
  NewPostAdded,
  ReservationReminder,
  BoardingCheckOut,
  BoardingPartialPaided,
  BoardingPaided,
  NewFriendRequest,
  AcceptFriendRequest,
  CustomeMessage,
  NewReactionOnPost,
  AddWalletReward,
  AndroidCustomeNotification,
  IOSCustomeNotification,
  AndroidAndIOSCustomeNotification,
  QrCodeNotification,
  NewBoardingImage,
  NewPetFriendRequest,
  AcceptPetFriendShipRequest,
  MakePetAvaliable,
  AcceptMatingRequest,
  MatingRate,
  SendMatingRequest,
  PetMarriage,
  Discover,
  Pregenant,
  SetBaby,
  CheckPrepegant,
  NewStory,
  StoryViewed,
  StoryReaction,
  ReplyOnStory,
  NewPetCommentOnPost,
  Unknown,
}

extension NotificationTypeExtension on NotificationType {
  String get typeName {
    switch (this) {
      case NotificationType.NewPetFriendRequest:
        return 'NewPetFriendRequest';
      case NotificationType.AcceptPetFriendShipRequest:
        return 'AcceptPetFriendShipRequest';
      case NotificationType.MakePetAvaliable:
        return 'MakePetAvaliable';
      case NotificationType.AcceptMatingRequest:
        return 'AcceptMatingRequest';
      case NotificationType.MatingRate:
        return 'MatingRate';
      case NotificationType.SendMatingRequest:
        return 'SendMatingRequest';
      case NotificationType.PetMarriage:
        return 'PetMarriage';
      case NotificationType.Discover:
        return 'Discover';
      case NotificationType.Pregenant:
        return 'Pregenant';
      case NotificationType.SetBaby:
        return 'SetBaby';
      case NotificationType.CheckPrepegant:
        return 'CheckPrepegant';
      case NotificationType.NewStory:
        return 'NewStory';
      case NotificationType.StoryViewed:
        return 'StoryViewed';
      case NotificationType.StoryReaction:
        return 'StoryReaction';
      case NotificationType.ReplyOnStory:
        return 'ReplyOnStory';
      case NotificationType.NewPetCommentOnPost:
        return 'NewPetCommentOnPost';
      case NotificationType.NewAppointmentOrReservation:
        return 'NewAppointmentOrReservation';
      case NotificationType.NewCommentOnYourPost:
        return 'NewCommentOnYourPost';
      case NotificationType.NewCommentOnPost:
        return 'NewCommentOnPost';
      case NotificationType.FollowRequest:
        return 'FollowRequest';
      case NotificationType.RespondedToFollowRequest:
        return 'RespondedToFollowRequest';
      case NotificationType.VaccinationReminder:
        return 'VaccinationReminder';
      case NotificationType.NewFollower:
        return 'NewFollower';
      case NotificationType.AppointmentCompleted:
        return 'AppointmentCompleted';
      case NotificationType.NewPetAdded:
        return 'NewPetAdded';
      case NotificationType.NewPostAdded:
        return 'NewPostAdded';
      case NotificationType.ReservationReminder:
        return 'ReservationReminder';
      case NotificationType.BoardingCheckOut:
        return 'BoardingCheckOut';
      case NotificationType.BoardingPartialPaided:
        return 'BoardingPartialPaided';
      case NotificationType.BoardingPaided:
        return 'BoardingPaided';
      case NotificationType.NewFriendRequest:
        return 'NewFriendRequest';
      case NotificationType.AcceptFriendRequest:
        return 'AcceptFriendRequest';
      case NotificationType.CustomeMessage:
        return 'CustomeMessage';
      case NotificationType.NewReactionOnPost:
        return 'NewReactionOnPost';
      case NotificationType.AddWalletReward:
        return 'AddWalletReward';
      case NotificationType.AndroidCustomeNotification:
        return 'AndroidCustomeNotification';
      case NotificationType.IOSCustomeNotification:
        return 'IOSCustomeNotification';
      case NotificationType.AndroidAndIOSCustomeNotification:
        return 'AndroidAndIOSCustomeNotification';
      case NotificationType.QrCodeNotification:
        return 'QrCodeNotification';
      case NotificationType.NewBoardingImage:
        return 'NewBoardingImage';
      case NotificationType.Unknown:
        return 'Unknown';
    }
  }
}

NotificationType getNotificationType(String typeName) {
  for (var type in NotificationType.values) {
    if (type.typeName == typeName) {
      return type;
    }
  }
  return NotificationType.Unknown;
}
