import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/photos_tab.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/posts_tab.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/ratings_tab.dart';
import '../../../feeds/domain/entities/pet_mating_model.dart';
import 'history_tab.dart';


class PetTabsSection extends StatelessWidget {
  final PetMating pet;
  final bool isDarkMode;

  const PetTabsSection({
    super.key,
    required this.pet,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color textSecondaryColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
            Colors.grey.shade800,
            Colors.grey.shade900,
          ]
              : [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.shade700.withOpacity(0.5)
              : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.4)
                : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: textSecondaryColor,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryColor,
                      ColorManager.primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Posts'),
                  Tab(text: 'Photos'),
                  Tab(text: 'History'),
                  Tab(text: 'Ratings'),
                ],
              ),
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                children: [
                  PostsTab(pet: pet, isDarkMode: isDarkMode),
                  PhotosTab(isDarkMode: isDarkMode),
                  HistoryTab(isDarkMode: isDarkMode),
                  RatingsTab(pet: pet, isDarkMode: isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}