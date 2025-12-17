import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/auth/get_started/presentation/screnns/add_pet_screen.dart';

class QuickTourScreen extends StatelessWidget {
  const QuickTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isArabicLang = isArabic();

    return Scaffold(
      backgroundColor: ColorManager.editScreenTextFieldBaseColor.withValues(
        alpha: .5,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorManager.editScreenTextFieldBaseColor.withOpacity(
          .5,
        ),
        leading: null,
        elevation: 0,
        title: Text(
          isArabicLang ? "جولة سريعة" : "Quick Tour",
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
            isArabicLang ? "اكتشف الميزات الرئيسية" : "Discover Key Features",
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
              isArabicLang
                  ? "إليك ما يمكنك فعله باستخدام Squeak للحفاظ على سعادة وصحة صغيرك الأليف!"
                  : "Here's what you can do with Squeak to keep your pet happy and healthy!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: width * 0.035),
            ),
          ),
          SizedBox(height: height * 0.03),

          /// Grid of features
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount =
                      width < 600 ? 2 : (width < 900 ? 3 : 4);

                  return GridView.builder(
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: width * 0.03,
                      mainAxisSpacing: height * 0.02,
                      childAspectRatio: width < 600 ? 0.75 : 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final features = _getFeatures(isArabicLang);
                      final f = features[index];

                      return _buildFeatureCard(
                        icon: f["icon"] as IconData,
                        color: f["color"] as Color,
                        title: f["title"] as String,
                        description: f["description"] as String,
                        tryIt: f["tryIt"] as String,
                        width: width,
                        isArabic: isArabicLang,
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
                  isArabicLang
                      ? "متابعة لإضافة صغيرأليف"
                      : "Continue to Add Pet",
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

  List<Map<String, dynamic>> _getFeatures(bool isArabic) {
    return [
      {
        "icon": Icons.pets,
        "color": Colors.redAccent,
        "title": isArabic ? "صغاري الأليفة" : "My Pets",
        "description":
            isArabic
                ? "إدارة عدة صغار أليفة، وتتبع سجلاتها الصحية، ومشاركة لحظاتها الجميلة"
                : "Manage multiple pets, track their health records, and share their adorable moments.",
        "tryIt":
            isArabic
                ? "أضف صورًا، واضبط التذكيرات، وتابع الوزن والمزاج"
                : "Add photos, set reminders, track weight & mood",
      },
      {
        "icon": Icons.chat,
        "color": Colors.teal,
        "title": isArabic ? "محادثة الصغار" : "Pet Chat",
        "description":
            isArabic
                ? "تواصل مع أصحاب الحيوانات الأليفة الآخرين، وشارك التجارب، واحصل على نصائح من المجتمع"
                : "Connect with other pet parents, share experiences, and get advice from the community.",
        "tryIt":
            isArabic
                ? "انضم لمجموعات السلالات، اطرح أسئلة، شارك نصائح"
                : "Join breed groups, ask questions, share tips",
      },
      {
        "icon": Icons.calendar_today,
        "color": Colors.green,
        "title": isArabic ? "المواعيد" : "Appointments",
        "description":
            isArabic
                ? "جدولة زيارات الطبيب البيطري والعناية والتدريب. لا تفوت أي موعد مهم!"
                : "Schedule vet visits, grooming, and training sessions. Never miss important dates!",
        "tryIt":
            isArabic
                ? "احجز عند أطباء بيطريين قريبين، اضبط التذكيرات، تابع السجل"
                : "Book nearby vets, set reminders, track history",
      },
      {
        "icon": Icons.favorite,
        "color": Colors.pinkAccent,
        "title": isArabic ? "تتبع الصحة" : "Health Tracking",
        "description":
            isArabic
                ? "راقب التطعيمات والأدوية والصحة العامة باستخدام أدوات تتبع سهلة"
                : "Monitor vaccinations, medications, and overall wellness with easy tracking tools.",
        "tryIt":
            isArabic
                ? "سجل الأعراض، تابع الأدوية، تنبيهات التطعيم"
                : "Log symptoms, track medications, vaccination alerts",
      },
    ];
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String tryIt,
    required double width,
    required bool isArabic,
  }) {
    final cardPadding = width < 600 ? width * 0.03 : width * 0.04;
    final iconSize = width < 600 ? width * 0.05 : width * 0.045;
    final titleFontSize = width < 600 ? width * 0.038 : width * 0.035;
    final descriptionFontSize = width < 600 ? width * 0.028 : width * 0.026;
    final tryItFontSize = width < 600 ? width * 0.026 : width * 0.024;

    return Container(
      padding: EdgeInsets.all(cardPadding),
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
                radius: iconSize,
                child: Icon(icon, color: Colors.white, size: iconSize),
              ),
              SizedBox(width: width * 0.02),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: cardPadding * 0.7),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: descriptionFontSize,
                height: 1.3,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: cardPadding * 0.5),
          Container(
            padding: EdgeInsets.all(cardPadding * 0.7),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(width * 0.02),
            ),
            child: Text(
              "${isArabic ? 'جربها: ' : 'Try It: '}$tryIt",
              style: TextStyle(color: Colors.white, fontSize: tryItFontSize),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
