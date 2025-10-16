// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_cubit.dart';

class TabBarPetFriend extends StatelessWidget {
  final int selectedTab;
  final int friendsCount;
  final int suggestedCount;
  final int receivedCount;
  final int sentCount;

  const TabBarPetFriend({
    super.key,
    required this.selectedTab,
    required this.friendsCount,
    required this.suggestedCount,
    required this.receivedCount,
    required this.sentCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? Colors.black.withOpacity(0.1) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive scaling factor
          double width = constraints.maxWidth;
          double iconSize = width * 0.06; // scales with width
          double fontSize = width * 0.03;
          double countSize = width * 0.028;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TabItem(
                icon: IconlyBold.user_3,
                label: isArabic() ? 'الأصدقاء' : 'Friends',
                count: friendsCount,
                isSelected: selectedTab == 0,
                onTap: () => context.read<PetFriendsCubit>().changeTab(0),
                iconSize: iconSize,
                fontSize: fontSize,
                countSize: countSize,
              ),
              _TabItem(
                icon: IconlyBold.add_user,
                label: isArabic() ? 'الأصدقاء المقترحون' : 'Suggested',
                count: suggestedCount,
                isSelected: selectedTab == 1,
                onTap: () => context.read<PetFriendsCubit>().changeTab(1),
                iconSize: iconSize,
                fontSize: fontSize,
                countSize: countSize,
              ),
              _TabItem(
                icon: IconlyBold.download,
                label: isArabic() ? 'الطلبات المعلقة' : 'Received',
                count: receivedCount,
                isSelected: selectedTab == 2,
                onTap: () => context.read<PetFriendsCubit>().changeTab(2),
                iconSize: iconSize,
                fontSize: fontSize,
                countSize: countSize,
              ),
              _TabItem(
                icon: IconlyBold.send,
                label: isArabic() ? 'الطلبات المرسلة' : 'Sent',
                count: sentCount,
                isSelected: selectedTab == 3,
                onTap: () => context.read<PetFriendsCubit>().changeTab(3),
                iconSize: iconSize,
                fontSize: fontSize,
                countSize: countSize,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double countSize;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
    required this.countSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = Theme.of(context).colorScheme.primary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: selectedColor.withOpacity(0.2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor
                : (isDark ? Colors.grey[900] : Colors.grey[100]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.grey[700]),
                size: iconSize,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.grey[800]),
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.grey[700]),
                    fontSize: countSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
