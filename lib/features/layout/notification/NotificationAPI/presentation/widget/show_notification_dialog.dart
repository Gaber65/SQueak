import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../domain/entities/notification_entities.dart';
import 'navigate_based_on_notification.dart';

void showNotificationDialog(
  BuildContext contextNav,
  NotificationEntities model,
) {
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
    context: contextNav,
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
                    image: AssetImage('assets/paw_background_modified.webp'),
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
                              child: Image.network(
                                model.logo,
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
                        "Hey, $userName! Here's a message from $extractedClinicName!",
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
                                  color: Color(0xFF5C469C), // Same Soft Purple
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                model.message,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
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
                          style: TextStyle(fontSize: 14, color: Colors.black54),
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
                              backgroundColor: Color(0xFF5C469C), // Soft Purple
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              navigateBasedOnNotification(model, contextNav);
                            },
                            child: Text(
                              "Got it!",
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
