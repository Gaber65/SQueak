// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/core/utils/theme/navigation_helper/navigation.dart';
import 'package:squeak/features/auth/get_started/presentation/screnns/quick_tour_screen.dart';

class WelcomeToSquek extends StatelessWidget {
  const WelcomeToSquek({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

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
          child: SingleChildScrollView(
            // prevents overflow on small devices
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06, // 6% of screen width
                vertical: height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.02),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.02),
                      child: Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: width * 0.12,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    isArabic() ? 'مرحبًا بك في سكويك' : 'Welcome To Squeak',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.065, // dynamic font
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: width * 0.65,
                    child: Text(
                      textAlign: TextAlign.center,
                      isArabic()
                          ? 'شبكة التواصل الاجتماعي لصغيرك الأليف جاهزة. لنبدأ بجولة سريعة.'
                          : "Your pet's social network is ready. Let's get you started with a quick tour.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: width * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  // Features Box
                  Container(
                    margin: EdgeInsets.symmetric(vertical: height * 0.03),
                    padding: EdgeInsets.all(width * 0.07),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeatureItem(
                          Icons.add,
                          isArabic()
                              ? 'أضف صغيرك الأليف الأول'
                              : "Add your first pet",
                          width,
                        ),
                        SizedBox(height: height * 0.015),
                        _buildFeatureItem(
                          Icons.group,
                          isArabic()
                              ? 'تواصل مع أصدقاء الصغار الأليفة'
                              : "Connect with pet friends",
                          width,
                        ),
                        SizedBox(height: height * 0.015),
                        _buildFeatureItem(
                          Icons.calendar_today,
                          isArabic()
                              ? 'احجز المواعيد'
                              : "Schedule appointments",
                          width,
                        ),
                        SizedBox(height: height * 0.015),
                        _buildFeatureItem(
                          Icons.chat,
                          isArabic() ? 'ابدأ الدردشة' : "Start chatting",
                          width,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: width * 0.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: height * 0.018),
                      ),
                      onPressed: () {
                        navigateAndFinish(context, QuickTourScreen());
                      },
                      child: Text(
                        isArabic()? 'هيا بنا نبدأ': 
                        "Let's Get Started!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.045,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),
                  Column(
                    children: [
                      Text(
                        isArabic() ?"الخطوة 1 من 4" :
                        "Step 1 of 4",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.035,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          bool isActive = index == 0;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? width * 0.025 : width * 0.02,
                            height: isActive ? width * 0.025 : width * 0.02,
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
                      SizedBox(height: height * 0.05),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text, double width) {
    return Row(
      children: [
        CircleAvatar(
          radius: width * 0.05,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white, size: width * 0.045),
        ),
        SizedBox(width: width * 0.03),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: width * 0.045),
        ),
      ],
    );
  }
}
