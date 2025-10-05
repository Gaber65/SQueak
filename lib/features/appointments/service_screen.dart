import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/all_apointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/supplier/get_supplier.dart';

class CareHubScreen extends StatelessWidget {
  const CareHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == "ar";

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final textScale = width / 375;
    final paddingScale = width / 400;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            isArabic ? "الرعاية" : "Care",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 24 * textScale.clamp(0.9, 1.3),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0 * paddingScale.clamp(0.8, 1.2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? "مركز رعاية صديقك" : "Your Friend's Care Hub",
                style: TextStyle(
                  fontSize: 22 * textScale.clamp(0.9, 1.4),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 8 * paddingScale),
              Text(
                isArabic
                    ? "مرحبًا! من هنا يمكنك إدارة المواعيد، عرض السجلات الصحية، وإيجاد عيادات VetICare الموثوقة لصديقك. اختر خيارًا أدناه للبدء."
                    : "Welcome! From here, you can manage appointments, view health records, and find trusted VetICare clinics for your friend. Select an option below to get started.",
                style: TextStyle(
                  fontSize: 14 * textScale.clamp(0.9, 1.3),
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              SizedBox(height: 28 * paddingScale),

              _buildFeatureCard(
                context: context,
                isDark: isDark,
                height: height * 0.32,
                width: width,
                title: isArabic ? "العيادات" : "Clinics",
                description:
                    isArabic
                        ? "اعثر بسهولة واحجز مواعيد في العيادات البيطرية الموثوقة عبر VetICare لصديقك"
                        : "Easily find and book appointments at trusted veterinary clinics through VetICare for your friend",
                icon: Icons.health_and_safety,
                onTap: () {
                  navigateToScreen(
                    context,
                    MySupplierScreen(petSelectFromIcon: null),
                  );
                },
              ),

              SizedBox(height: 16 * paddingScale),

              _buildFeatureCard(
                context: context,
                isDark: isDark,
                height: height * 0.32,
                width: width,
                title: isArabic ? "المواعيد" : "Appointments",
                description:
                    isArabic
                        ? "عرض وإدارة مواعيد صديقك القادمة."
                        : "View and manage your friend's upcoming appointments.",
                icon: IconlyBold.calendar,
                onTap: () {
                  navigateToScreen(context, AllAppointment());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    required double width,
    double? height,
  }) {
    final textScale = width / 375;
    final paddingScale = width / 400;

    return Card(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(30 * paddingScale.clamp(0.7, 1.3)),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(59, 130, 246, 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Icon(
                icon,
                color: ColorManager.primaryColor,
                size: 60 * textScale.clamp(0.8, 1.4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16 * textScale.clamp(0.9, 1.4),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4 * paddingScale.clamp(0.8, 1.2),
              ),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 13 * textScale.clamp(0.9, 1.3),
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 12 * paddingScale),
          ],
        ),
      ),
    );
  }
}
