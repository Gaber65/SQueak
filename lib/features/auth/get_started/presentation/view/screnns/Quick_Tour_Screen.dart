import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/auth/get_started/presentation/view/screnns/Add_Pet_Screen.dart';

class QuickTourScreen extends StatelessWidget {
  const QuickTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.editScreenTextFieldBaseColor.withValues(
        alpha: .5,
      ),
      appBar: AppBar(
        backgroundColor: ColorManager.editScreenTextFieldBaseColor.withOpacity(
          .5,
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Quick Tour", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 0.5,
            minHeight: 2,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 16,
            backgroundColor: ColorManager.primaryColor,
            child: const Text(
              "2",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Discover Key Features",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              "Here's what you can do with Squeak to keep your pet happy and healthy!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: .8,
                children: [
                  _buildFeatureCard(
                    icon: Icons.pets,
                    color: Colors.redAccent,
                    title: "My Pets",
                    description:
                        "Manage multiple pets, track their health records, and share their adorable moments.",
                    tryIt: "Add photos, set reminders, track weight & mood",
                  ),
                  _buildFeatureCard(
                    icon: Icons.chat,
                    color: Colors.teal,
                    title: "Pet Chat",
                    description:
                        "Connect with other pet parents, share experiences, and get advice from the community.",
                    tryIt: "Join breed groups, ask questions, share tips",
                  ),
                  _buildFeatureCard(
                    icon: Icons.calendar_today,
                    color: Colors.green,
                    title: "Appointments",
                    description:
                        "Schedule vet visits, grooming, and training sessions. Never miss important dates!",
                    tryIt: "Book nearby vets, set reminders, track history",
                  ),
                  _buildFeatureCard(
                    icon: Icons.favorite,
                    color: Colors.pinkAccent,
                    title: "Health Tracking",
                    description:
                        "Monitor vaccinations, medications, and overall wellness with easy tracking tools.",
                    tryIt:
                        "Log symptoms, track medications, vaccination alerts",
                  ),
                ],
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              bool isActive = index == 1; // Step 2
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                width: isActive ? 10 : 8,
                height: isActive ? 10 : 8,
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

          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // main.dart أو المكان الذي تنادي فيه الشاشة
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (_) =>
                                    sl<PetCubit>()
                                      ..getAllSpecies()
                                      ..getBreedsBySpecies(
                                        'bca48207-f05d-4e9f-a631-06f34eb5af39',
                                      ),
                            child: const GetStartedAddPetScreen(),
                          ),
                    ),
                  );
                },
                child: const Text(
                  "Continue to Add Pet",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 8),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "Try It: $tryIt",
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
