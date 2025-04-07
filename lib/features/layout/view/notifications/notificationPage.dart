import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/helper/remotely/dio.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/appointments/models/get_appointment_model.dart';
import 'package:squeak/features/appointments/view/appointments/rate_appointment.dart';
import 'package:squeak/features/appointments/view/component/whatsAppBar.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/layout/controller/notificationsCubit/notifications_cubit.dart';
import 'package:squeak/features/layout/layout.dart';
import 'package:squeak/features/layout/models/Notification_model.dart';
import 'package:squeak/features/layout/view/feeds/post_notfication.dart';
import 'package:squeak/features/pets/view/pet_screen.dart';
import 'package:squeak/features/vetcare/view/follow_request_screen.dart';

import 'package:squeak/generated/l10n.dart';
import '../../../../core/helper/build_service/firebase_messaging_handler.dart';
import '../../../../core/helper/build_service/main_cubit/main_cubit.dart';
import '../../../../core/helper/cache/cache_helper.dart';
import '../../../../core/helper/remotely/end-points.dart';
import '../../../../core/utils/enums/notification_type_enums.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..getNotifications(),
      child: BlocConsumer<NotificationsCubit, NotificationsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = NotificationsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                S.of(context).notifications,
              ),
              centerTitle: true,
            ),
            body: (state is NotificationsLoadingState)
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade700,
                    highlightColor: Colors.grey.shade600,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          height: 60,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: !MainCubit.get(context).isDark
                                ? Colors.blue.shade50
                                : Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                      itemCount: 10,
                    ),
                  )
                : (cubit.notifications.isNotEmpty)
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          return _buildContent(
                            cubit.notifications[index],
                            context,
                          );
                        },
                        itemCount: cubit.notifications.length,
                      )
                    : Center(
                        child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/rb_1220.png?alt=media&token=8c71b107-7849-475e-91d8-feab8b7a4f27'),
                      ),
          );
        },
      ),
    );
  }

  IconData getNotificationIcon(NotificationModel notification) {
    NotificationType? notificationType =
        NotificationModel.getNotificationType(notification.eventType);
    switch (notificationType) {
      case NotificationType.NewAppointmentOrReservation:
        return Icons.event_note; // Use a calendar or event-related icon
      case NotificationType.NewCommentOnPost:
        return Icons.comment; // Use a comment-related icon
      case NotificationType.FollowRequest:
        return Icons.person_add; // Use an icon for follow requests
      case NotificationType.RespondedToFollowRequest:
        return Icons.person; // Use a person icon for follow responses
      case NotificationType.VaccinationReminder:
        return Icons.vaccines; // Use an icon related to health or vaccines
      case NotificationType.AppointmentCompleted:
        return Icons.check_circle; // Use a checkmark icon for completion
      case NotificationType.NewPetAdded:
        return Icons.pets; // Use a pet-related icon
      case NotificationType.NewPostAdded:
        return Icons.post_add; // Use a post-related icon
      case NotificationType.ReservationReminder:
        return Icons.alarm; // Use an alarm or reminder icon
      default:
        return Icons.notifications; // Fallback to default notification icon
    }
  }

  Color _getColorForNotification(NotificationModel notification) {
    NotificationType? notificationType =
        NotificationModel.getNotificationType(notification.eventType);
    switch (notificationType) {
      case NotificationType.NewAppointmentOrReservation:
        return Colors.blue.withOpacity(0.5);
      case NotificationType.NewCommentOnPost:
        return Colors.green.withOpacity(0.5);
      case NotificationType.FollowRequest:
        return Colors.orange.withOpacity(0.5);
      case NotificationType.RespondedToFollowRequest:
        return Colors.teal.withOpacity(0.5);
      case NotificationType.VaccinationReminder:
        return Colors.red.withOpacity(0.5);
      case NotificationType.AppointmentCompleted:
        return Colors.purple.withOpacity(0.5);
      case NotificationType.NewPetAdded:
        return Colors.brown.withOpacity(0.5);
      case NotificationType.NewPostAdded:
        return Colors.indigo.withOpacity(0.5);
      case NotificationType.ReservationReminder:
        return Colors.amber.withOpacity(0.5);
      default:
        return Colors.grey.withOpacity(0.5); // Fallback color
    }
  }

  void showNotificationDialog(BuildContext context, NotificationModel model) {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/dog_bark.mp3')); // Play pet sound

    // Retrieve username from cache
    String userName = CacheHelper.getData('name') ?? "Pet Lover";

    // Extract clinic name from the notification title (assuming "Clinic XYZ: Message")
    String extractedClinicName = model.title.split(":").first.trim();
// Remove the word "Notification" if it appears
    extractedClinicName =
        extractedClinicName.replaceAll("Notification", "").trim();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FadeInDown(
          duration: Duration(milliseconds: 300),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25), // Light theme
                    image: DecorationImage(
                      image: AssetImage('assets/paw_background_modified.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.7),
                        BlendMode.lighten,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BounceInDown(
                          duration: Duration(milliseconds: 500),
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 360),
                            duration: Duration(seconds: 1),
                            builder: (context, double angle, child) {
                              return Transform.rotate(
                                angle: angle * 3.1416 / 180,
                                child: child,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/vtl_logo.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        // Personalized Greeting with extracted clinic name
                        Text(
                          "Hey, $userName! 🐾 Here's a message from $extractedClinicName!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF5C469C), // Soft Purple
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15),

                        // Message Container
                        FadeIn(
                          duration: Duration(milliseconds: 500),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  model.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Color(0xFF5C469C), // Same Soft Purple
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 100,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      model.message,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Fun Fact about Pets
                        FadeInUp(
                          duration: Duration(milliseconds: 500),
                          child: Text(
                            "🐾 Did you know? Dogs’ noses are as unique as human fingerprints! 🐶",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 15),

                        // "Got it!" Button
                        SlideInUp(
                          duration: Duration(milliseconds: 500),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color(0xFF5C469C), // Soft Purple
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Future.delayed(Duration(milliseconds: 300), () {
                                  navigateBasedOnNotification(model, context);
                                });
                              },
                              child: Text(
                                "Got it! 🐾",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Widget _buildContent(NotificationModel model, context) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //     height: 65,
  //     decoration: BoxDecoration(
  //       color:
  //           !MainCubit.get(context).isDark ? Colors.blue.shade50 : Colors.black,
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: InkWell(
  //       onTap: () {
  //         handleNotification(model, context);
  //       },
  //       child: Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.all(10),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               height: 40,
  //               width: 40,
  //               decoration: BoxDecoration(
  //                   color: _getColorForNotification(model),
  //                   borderRadius: BorderRadius.circular(10)),
  //               child: Center(
  //                 child: Icon(
  //                   getNotificationIcon(
  //                     model,
  //                   ), // Use the icon based on NotificationType
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             Expanded(
  //               flex: 3,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     model.title,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: const TextStyle(
  //                         fontFamily: 'bold',
  //                         fontSize: 15,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     model.message,
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 1,
  //                     style: const TextStyle(
  //                       color: Colors.grey,
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             Expanded(
  //               child: Text(
  //                 formatFacebookTimePost(
  //                   model.createdAt,
  //                 ),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildContent(NotificationModel model, context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 65,
      decoration: BoxDecoration(
        color:
            !MainCubit.get(context).isDark ? Colors.blue.shade50 : Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          showNotificationDialog(context, model);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: _getColorForNotification(model),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Icon(
                    getNotificationIcon(model),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: 'bold',
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      model.message,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  formatFacebookTimePost(model.createdAt),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//   void handleNotification(
//       NotificationModel notification, BuildContext context) {
//     NotificationType? notificationType =
//         NotificationModel.getNotificationType(notification.eventType);

//     switch (notificationType) {
//       case NotificationType.VaccinationReminder:
//       case NotificationType.NewPetAdded:
//         navigateToScreen(context, PetScreen());
//         break;

//       case NotificationType.FollowRequest:
//         NotificationsCubit.get(context)
//             .updateState(notification.notificationEvents[0].id);
//         navigateToScreen(
//           context,
//           FollowRequestScreen(ClinicID: notification.eventTypeId),
//         );
//         break;

//       case NotificationType.NewCommentOnPost:
//       case NotificationType.NewPostAdded:
//         navigateToScreen(
//           context,
//           PostNotification(id: notification.eventTypeId),
//         );
//         break;

//       case NotificationType.NewAppointmentOrReservation:
//       case NotificationType.AppointmentCompleted:
//       case NotificationType.ReservationReminder:
//         print('Handling appointment/reservation: ${notification.eventType}');
//         getAppointment(
//           id: notification.eventTypeId,
//           type: notificationType!,
//           isNav: true,
//           context: context,
//           notification: notification,
//         );
//         break;

//       default:
//         print('Unhandled notification type: ${notification.eventType}');
//         break;
//     }
//   }
// }
  // Add this package for animations

  void handleNotification(
      NotificationModel notification, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FadeInDown(
          // Smooth animation effect
          duration: Duration(milliseconds: 300),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Professional Pet Doctor Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/petdoctor.png', // Use a sleek doctor image
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),

                // Title with refined styling
                Text(
                  "Message from Your Pet Doctor 🩺",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Message Body
                Text(
                  notification.message,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Done Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Future.delayed(Duration(milliseconds: 300), () {
                        navigateBasedOnNotification(notification, context);
                      });
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// void navigateBasedOnNotification(
//     NotificationModel notification, BuildContext context) {
//   NotificationType? notificationType =
//       NotificationModel.getNotificationType(notification.eventType);

//   switch (notificationType) {
//     case NotificationType.VaccinationReminder:
//     case NotificationType.NewPetAdded:
//       navigateToScreen(context, PetScreen());
//       break;

//     case NotificationType.FollowRequest:
//       NotificationsCubit.get(context)
//           .updateState(notification.notificationEvents[0].id);
//       navigateToScreen(
//           context, FollowRequestScreen(ClinicID: notification.eventTypeId));
//       break;
void navigateBasedOnNotification(
    NotificationModel notification, BuildContext context) {
  NotificationType? notificationType =
      NotificationModel.getNotificationType(notification.eventType);

  switch (notificationType) {
    case NotificationType.VaccinationReminder:
    case NotificationType.NewPetAdded:
      navigateToScreen(context, PetScreen());
      break;

    case NotificationType.FollowRequest:
      NotificationsCubit.get(context)
          .updateState(notification.notificationEvents[0].id);
      navigateToScreen(
          context, FollowRequestScreen(ClinicID: notification.eventTypeId));
      break;

    case NotificationType.NewCommentOnPost:
    case NotificationType.NewPostAdded:
      navigateToScreen(context, PostNotification(id: notification.eventTypeId));
      break;

    case NotificationType.NewAppointmentOrReservation:
    case NotificationType.AppointmentCompleted:
    case NotificationType.ReservationReminder:
      getAppointment(
        id: notification.eventTypeId,
        type: notificationType!,
        isNav: true,
        context: context,
        notification: notification,
      );
      break;
    case NotificationType.NewCommentOnPost:
    case NotificationType.NewPostAdded:
      navigateToScreen(context, PostNotification(id: notification.eventTypeId));
      break;

    case NotificationType.NewAppointmentOrReservation:
    case NotificationType.AppointmentCompleted:
    case NotificationType.ReservationReminder:
      getAppointment(
        id: notification.eventTypeId,
        type: notificationType!,
        isNav: true,
        context: context,
        notification: notification,
      );
      break;

    default:
      print('Unhandled notification type: ${notification.eventType}');
      break;
  }
}

Future<void> getAppointment({
  required String id,
  required NotificationType type,
  required BuildContext context,
  required bool isNav,
  NotificationModel? notification,
  bool? isMainRunning,
}) async {
  print('Handling appointment/reservation: ${notification?.eventType}');
  List<AppointmentModel> appointments = [];
  try {
    Response response = await DioFinalHelper.getData(
      method: createAndGetAppointmentsEndPoint(CacheHelper.getData('phone')),
      language: true,
    );

    appointments = (response.data['data']['result'] as List)
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
      navigateToScreen(
          context,
          RateAppointment(
            model: model!,
            isNav: isNav,
          ));
      CacheHelper.saveData('RateModel', model!.toMap());
      NotificationsCubit.get(context)
          .updateState(notification!.notificationEvents[0].id);
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

Future<AppointmentModel?> getAppointmentWithoutNav({
  required String id,
  required NotificationType type,
  required bool isNav,
  NotificationModel? notification,
}) async {
  List<AppointmentModel> appointments = [];
  AppointmentModel? model;
  await DioFinalHelper.init();

  try {
    Response response = await DioFinalHelper.getData(
      method: createAndGetAppointmentsEndPoint(CacheHelper.getData('phone')),
      language: true,
    );

    appointments = (response.data['data']['result'] as List)
        .map((e) => AppointmentModel.fromJson(e))
        .toList();

    // Print the IDs for debugging purposes
    for (var element in appointments) {
      if (element.id == id) {
        model = element;
        break;
      }
    }

    CacheHelper.saveData('RateModel', model!.toMap());

    return model; // Return the found AppointmentModel
  } on DioException catch (e) {
    print(e);
    // Handle DioError, perhaps return null or an error state.
    return null;
  }
}
