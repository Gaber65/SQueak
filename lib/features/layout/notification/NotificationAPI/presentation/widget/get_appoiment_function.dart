import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/appointments/boarding/data/models/boarding_entry_model.dart';
import 'package:squeak/features/appointments/boarding/presentation/screens/boarding_rating.dart';
import 'package:squeak/features/appointments/exam/data/models/appointment_model.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/all_apointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/rate_appointment.dart';
import 'package:squeak/features/layout/stories/domain/entities/story.dart';
import 'package:squeak/features/layout/stories/presentation/pages/my_stories_viewer_page.dart';
import 'package:squeak/features/mating/chat/presentation/screens/chat_list_screen.dart';

import '../../../../../appointments/boarding/presentation/screens/share_image_pet_screen.dart';
import '../../../../stories/data/models/story_model.dart';
import '../../../../stories/presentation/controllers/story_cubit.dart';
import '../../../../stories/presentation/pages/friend_stories_viewer_page.dart';

Future<void> getAppointment({
  required String id,
  required NotificationType type,
  required BuildContext context,
}) async {
  try {
    final response = await DioFinalHelper.getData(
      method: createAndGetAppointmentsEndPoint(
        CacheHelper.getData('phone'),
        false,
      ),
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
        navigateToScreen(context, AllAppointment());
        break;
      case AppointmentNavigationAction.goToRate:
        navigateToScreen(context, RateAppointment(model: model));
        break;
    }
  } on DioException catch (e) {
    debugPrint('DioException: ${e.response}');
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

Future<void> getBaording({
  required String id,
  required NotificationType type,
  required BuildContext context,
}) async {
  try {
    final response = await DioFinalHelper.getData(
      method: getAllBoardingEndPoint(CacheHelper.getData('phone')),
      language: true,
    );

    final appointments =
        (response.data['data']['result'] as List)
            .map((e) => BoardingEntryModel.fromJson(e))
            .toList();

    final model = appointments.firstWhere((e) => e.id == id);

    final action = _determineNavigationActionBaording(type);

    switch (action) {
      case BoardingNavigationAction.goToHome:
        navigateToScreen(context, AllAppointment());
        break;
      case BoardingNavigationAction.goToRate:
        navigateToScreen(context, RateBoarding(boardingEntryEntity: model));
        break;
      case BoardingNavigationAction.goToPayment:
        navigateToScreen(context, AllAppointment());
      case BoardingNavigationAction.goToImage:
        _showImages(context, false, model);
    }
  } on DioException catch (e) {
    debugPrint('DioException: ${e.response}');
  }
}

BoardingNavigationAction _determineNavigationActionBaording(
  NotificationType type,
) {
  switch (type) {
    case NotificationType.BoardingCheckOut:
      return BoardingNavigationAction.goToRate;
    case NotificationType.BoardingPartialPaided:
    case NotificationType.BoardingPaided:
      return BoardingNavigationAction.goToPayment;
    case NotificationType.NewBoardingImage:
      return BoardingNavigationAction.goToImage;
    default:
      return BoardingNavigationAction.goToHome;
  }
}

void _showImages(context, isVideo, entry) {
  showDialog(
    context: context,
    builder:
        (_) => ImageCarouselWidget(
          open: true,
          isDarkMode: MainCubit.get(context).isDark,
          onOpenChange: (open) => Navigator.pop(context),
          boarding: entry,
          isVideo: isVideo,
          onShare: (imageUrl, platform) {
            BoardingRemoteDataSourceImpl().shareImage(
              ShareImageBoardingEntriesParams(
                imageUrl: imageUrl,
                platform: platform,
              ),
            );
          },
        ),
  );
}

Future<void> getStroy({
  required String id,
  required NotificationType type,
  required BuildContext context,
}) async {
  try {
   
    final response = await DioFinalHelper.getData(
      method: deleteStoryEndPoint + id,
      language: true,
    );

    final stories = StoryModel.fromJson(response.data['data']['userStory']);
    String? storyOwnerId = response.data['data']['storyOwnerId'];
    final res = stories.copyWith(
      petName: response.data['data']['userStory']['petOwner']['petName'],
      petImage: response.data['data']['userStory']['petOwner']['imageName'],
    );
    final action = _determineNavigationActionStory(type);

    switch (action) {
      case StoryNavigationAction.goToHome:
        navigateToScreen(context, LayoutScreen());
        break;
      case StoryNavigationAction.openChat:
        navigateToScreen(context, ChatListScreen());
        break;
      case StoryNavigationAction.goToMyFrindStory:

        /// wating Implement
        showStoryFrind(context, [res], storyOwnerId ?? '', res.petId);
        break;
      case StoryNavigationAction.goToMyStory:

        /// wating Implement
        showStoryMy(context, [res], storyOwnerId ?? '');
        break;
    }
  } on DioException catch (e) {
    debugPrint('DioException: ${e.response}');
  }
}

StoryNavigationAction _determineNavigationActionStory(NotificationType type) {
  switch (type) {
    case NotificationType.StoryReaction:
    case NotificationType.StoryViewed:
      return StoryNavigationAction.goToMyStory;
    case NotificationType.ReplyOnStory:
      return StoryNavigationAction.openChat;
    case NotificationType.NewStory:
      return StoryNavigationAction.goToMyFrindStory;
    default:
      return StoryNavigationAction.goToHome;
  }
}

void showStoryMy(context, List<StoryEntity> myStories, petID) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => BlocProvider(
          create: (context) => sl<StoryCubit>(),
          child: MyStoriesViewerPage(
            // Changed from StoryViewerPage
            storyCubit: sl<StoryCubit>(),
            stories: myStories,
            petID: petID,
            initialIndex: 0,
          ),
        ),
  );
}

void showStoryFrind(
  context,
  List<StoryEntity> myStories,
  petID,
  String friendPetId,
) {
  // Create a FrindStoryEntity object
  final friendStory = FrindStoryEntity(
    petId: friendPetId,
    petName: myStories.first.petName,
    petImage: myStories.first.petImage,
    userStories: myStories,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => BlocProvider(
          create: (context) => sl<StoryCubit>(),
          child: FriendStoriesViewerPage(
            storyCubit: sl<StoryCubit>(),
            friendsStories: friendStory, // Now passing the required parameter
            stories: myStories,
            petID: petID,
            initialIndex: 0,
          ),
        ),
  );
}
