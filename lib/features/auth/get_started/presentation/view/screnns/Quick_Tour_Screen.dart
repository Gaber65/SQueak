// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/auth/get_started/presentation/view/screnns/Add_Pet_Screen.dart';

class QuickTourScreen extends StatelessWidget {
  const QuickTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: ColorManager.editScreenTextFieldBaseColor.withValues(
        alpha: .5,
      ),
      appBar: AppBar(
        backgroundColor: ColorManager.editScreenTextFieldBaseColor.withOpacity(
          .5,
        ),
        elevation: 0,

        title: Text(
          "Quick Tour",
          style: TextStyle(
            color: Colors.white,
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 0.5,
            minHeight: height * 0.003,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: height * 0.03),

          /// Step Circle
          CircleAvatar(
            radius: width * 0.06,
            backgroundColor: ColorManager.primaryColor,
            child: Text(
              "2",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.045,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),

          /// Title
          Text(
            "Discover Key Features",
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.055,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.01),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Text(
              "Here's what you can do with Squeak to keep your pet happy and healthy!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: width * 0.035),
            ),
          ),
          SizedBox(height: height * 0.03),

          /// Grid of features
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width < 600 ? 2 : 3,
                      crossAxisSpacing: width * 0.04,
                      mainAxisSpacing: height * 0.02,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final features = [
                        {
                          "icon": Icons.pets,
                          "color": Colors.redAccent,
                          "title": "My Pets",
                          "description":
                              "Manage multiple pets, track their health records, and share their adorable moments.",
                          "tryIt":
                              "Add photos, set reminders, track weight & mood",
                        },
                        {
                          "icon": Icons.chat,
                          "color": Colors.teal,
                          "title": "Pet Chat",
                          "description":
                              "Connect with other pet parents, share experiences, and get advice from the community.",
                          "tryIt":
                              "Join breed groups, ask questions, share tips",
                        },
                        {
                          "icon": Icons.calendar_today,
                          "color": Colors.green,
                          "title": "Appointments",
                          "description":
                              "Schedule vet visits, grooming, and training sessions. Never miss important dates!",
                          "tryIt":
                              "Book nearby vets, set reminders, track history",
                        },
                        {
                          "icon": Icons.favorite,
                          "color": Colors.pinkAccent,
                          "title": "Health Tracking",
                          "description":
                              "Monitor vaccinations, medications, and overall wellness with easy tracking tools.",
                          "tryIt":
                              "Log symptoms, track medications, vaccination alerts",
                        },
                      ];

                      final f = features[index];
                      return _buildFeatureCard(
                        icon: f["icon"] as IconData,
                        color: f["color"] as Color,
                        title: f["title"] as String,
                        description: f["description"] as String,
                        tryIt: f["tryIt"] as String,
                        width: width,
                      );
                    },
                  );
                },
              ),
            ),
          ),

          /// Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              bool isActive = index == 1;
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.01,
                  vertical: height * 0.015,
                ),
                width: isActive ? width * 0.025 : width * 0.02,
                height: isActive ? width * 0.025 : width * 0.02,
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? ColorManager.primaryColor
                          : Colors.white.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),

          /// Continue button
          SafeArea(
            child: Container(
              margin: EdgeInsets.all(width * 0.04),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (_) =>
                                    sl<PetCubit>()
                                      ..getAllSpecies()
                                      ..getBreedsBySpecies(
                                        "bca48207-f05d-4e9f-a631-06f34eb5af39",
                                      ),
                            child: const GetStartedAddPetScreen(),
                          ),
                    ),
                  );
                },
                child: Text(
                  "Continue to Add Pet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.045,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String tryIt,
    required double width,
  }) {
    return Container(
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(width * 0.03),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: width * 0.05,
                child: Icon(icon, color: Colors.white, size: width * 0.05),
              ),
              SizedBox(width: width * 0.02),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.02),
          Expanded(
            child: Text(
              description,
              style: TextStyle(color: Colors.white70, fontSize: width * 0.03),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.all(width * 0.02),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(width * 0.02),
            ),
            child: Text(
              "Try It: $tryIt",
              style: TextStyle(color: Colors.white, fontSize: width * 0.03),
            ),
          ),
        ],
      ),
    );
  }
}
