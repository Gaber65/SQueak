// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';

import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../domain/entities/boarding_entry_entity.dart';
import '../../../domain/entities/boarding_status.dart';
import '../../../domain/usecases/share_image_usecase.dart';
import '../../cubit/boarding_cubit.dart';
import '../boarding_rating.dart';
import '../share_image_pet_screen.dart';


// Helper function to check if the current language is Arabic
bool isArabic() {
  return MainCubit.get(navigatorKey.currentContext!).language == 'ar';
}

class BoardingCard extends StatelessWidget {
  final BoardingEntryEntity entry;
  final BoardingCubit cubit;
  final bool isDarkMode;

  const BoardingCard({
    super.key,
    required this.entry,
    required this.cubit,
    this.isDarkMode = false,
  });

  // Simple color getters
  Color get _cardColor => isDarkMode ? Colors.grey.shade900 : Colors.white;
  Color get _textColor => isDarkMode ? Colors.white : Colors.black87;
  Color get _subtitleColor =>
      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
  Color get _borderColor =>
      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [_buildHeader(), _buildContent(), _buildFooter()],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.grey.shade800.withOpacity(0.5)
                : Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          // Simple avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorManager.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FastCachedImage(
                url: imageUrlWithVetICare + (entry.clinicLogo ?? ''),
                fit: BoxFit.cover,
                errorBuilder:
                    (context, exception, stacktrace) => Container(
                      color: ColorManager.primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.local_hospital,
                        color: ColorManager.primaryColor,
                        size: 24,
                      ),
                    ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Pet and clinic info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.pet.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.clinicName,
                  style: TextStyle(fontSize: 14, color: _subtitleColor),
                ),
              ],
            ),
          ),

          // Simple status chip
          _buildSimpleStatusChip(),

          _buildSimpleMenu(),
        ],
      ),
    );
  }

  Widget _buildSimpleStatusChip() {
    final status = BoardingStatusExtension.fromInt(entry.status ?? 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.getChipColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.getDisplayText(isArabic()),
        style: TextStyle(
          color: status.getTextColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSimpleMenu() {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: _subtitleColor, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _cardColor,
      itemBuilder:
          (context) => [
            if (entry.status == BoardingStatusEnums.paid.index)
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      isArabic() ? 'تقييم' : 'Rate',
                      style: TextStyle(color: _textColor),
                    ),
                  ],
                ),
                onTap: () {
                  Future.delayed(Duration.zero, () {
                    navigateToScreen(
                      context,
                      RateBoarding(boardingEntryEntity: entry, isNav: true),
                    );
                  });
                },
              ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(Icons.image, color: ColorManager.primaryColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    isArabic() ? 'الصور' : 'Images',
                    style: TextStyle(color: _textColor),
                  ),
                ],
              ),
              onTap: () {
                Future.delayed(Duration.zero, () => _showImages(context,false));
              },
            ),
           
            PopupMenuItem(
              value: 3, // قيمة فريدة لخيار "الفيديوهات"
              child: Row(
                children: [
                  Icon(
                    Icons.videocam,
                    color: ColorManager.primaryColor,
                    size: 18,
                  ), // أيقونة الفيديو
                  const SizedBox(width: 8),
                  Text(
                    isArabic() ? 'الفيديوهات' : 'Videos', // نص الخيار حسب اللغة
                    style: TextStyle(color: _textColor),
                  ),
                ],
              ),
              onTap: () {
                Future.delayed(Duration.zero, () => _showImages(context,true));
              },
            ),
          ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Simple info rows
          _buildInfoRow(
            Icons.login,
            isArabic() ? 'دخول' : 'Check-in',
            formatBoarding(entry.entryDate.toString()),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.logout,
            isArabic() ? 'خروج' : 'Check-out',
            formatBoarding(entry.existDate.toString()),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.schedule,
            isArabic() ? 'المدة' : 'Duration',
            '${entry.period} ${entry.period == 1 ? (isArabic() ? 'يوم' : 'day') : (isArabic() ? 'أيام' : 'days')}',
          ),

          // Doctor rating if available
          if (entry.status == 3 && entry.doctorServiceRate != 0)
            _buildDoctorRating(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: ColorManager.primaryColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: _subtitleColor,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(color: _textColor, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildDoctorRating() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.medical_services, color: Colors.amber, size: 16),
          const SizedBox(width: 8),
          Text(
            isArabic() ? 'تقييم الطبيب:' : 'Doctor rating:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < entry.doctorServiceRate
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.grey.shade800.withOpacity(0.3)
                : Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          // Boarding type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorManager.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pets, size: 16, color: ColorManager.primaryColor),
                const SizedBox(width: 6),
                Text(
                  entry.boardingType.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorManager.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Call button
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  launchUrl(Uri.parse('tel:${entry.clinicPhone}'));
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Call',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImages(context ,isVideo) {
    showDialog(
      context: context,
      builder:
          (_) => ImageCarouselWidget(
            open: true,
            isDarkMode: isDarkMode,
            onOpenChange: (open) => Navigator.pop(context),
            boarding: entry,
            isVideo: isVideo,
            onShare: (imageUrl, platform) {
              cubit.shareImageEntries(
                ShareImageBoardingEntriesParams(
                  imageUrl: imageUrl,
                  platform: platform,
                ),
              );
            },
          ),
    );
  }



}

// Simple usage function
Widget buildSimpleBoardingCard(
  BoardingEntryEntity entry,
  BoardingCubit cubit, {
  bool isDarkMode = false,
}) {
  return BoardingCard(entry: entry, cubit: cubit, isDarkMode: isDarkMode);
}

// Auto-detect theme version
Widget buildSimpleThemeAwareBoardingCard(
  BuildContext context,
  BoardingEntryEntity entry,
  BoardingCubit cubit,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return BoardingCard(entry: entry, cubit: cubit, isDarkMode: isDark);
}
