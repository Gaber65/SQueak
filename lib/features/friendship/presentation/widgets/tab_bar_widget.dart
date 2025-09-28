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
    return Container(
      color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.1) : Colors.white,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          _TabItem(
            icon: IconlyBold.user_3,
            label: isArabic() ? 'الأصدقاء' : 'Friends',
            count: friendsCount,
            isSelected: selectedTab == 0,
            onTap: () => context.read<PetFriendsCubit>().changeTab(0),
          ),
          _TabItem(
            icon: IconlyBold.add_user,
            label: isArabic() ? 'الأصدقاء المقترحون' : 'Suggested',
            count: suggestedCount,
            isSelected: selectedTab == 1,
            onTap: () => context.read<PetFriendsCubit>().changeTab(1),
          ),
          _TabItem(
            icon: IconlyBold.download,
            label: isArabic() ? 'الطلبات المعلقة' : 'Received',
            count: receivedCount,
            isSelected: selectedTab == 2,
            onTap: () => context.read<PetFriendsCubit>().changeTab(2),
          ),
          _TabItem(
            icon: IconlyBold.send,
            label: isArabic() ? 'الطلبات المرسلة' : 'Sent',
            count: sentCount,
            isSelected: selectedTab == 3,
            onTap: () => context.read<PetFriendsCubit>().changeTab(3),
          ),
        ],
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

  const _TabItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primaryColor: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
