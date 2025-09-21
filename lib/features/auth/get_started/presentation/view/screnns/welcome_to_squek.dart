import 'package:flutter/material.dart';
import 'package:squeak/core/utils/theme/navigation_helper/navigation.dart';
import 'package:squeak/features/auth/get_started/presentation/view/screnns/Quick_Tour_Screen.dart';

class WelcomeToSquek extends StatelessWidget {
  const WelcomeToSquek({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [Color(0xFF6A85F1), Color(0xFF8E72F1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 18),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.pets, color: Colors.white, size: 42),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome To Squeak',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              const SizedBox(
                width: 220,
                child: Text(
                  textAlign: TextAlign.center,
                  "Your pet's social network is ready. Let's get you started with a quick tour.",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ),
              const SizedBox(height: 18),

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 44,
                  vertical: 24,
                ),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureItem(Icons.add, "Add your first pet"),
                    const SizedBox(height: 12),
                    _buildFeatureItem(Icons.group, "Connect with pet friends"),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      Icons.calendar_today,
                      "Schedule appointments",
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(Icons.chat, "Start chatting"),
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    navigateToScreen(context, QuickTourScreen());
                  },
                  child: const Text(
                    "Let's Get Started!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Spacer(),
              Column(
                children: [
                  const Text(
                    "Step 1 of 4",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      bool isActive = index == 0;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 10 : 8,
                        height: isActive ? 10 : 8,
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 36),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}
