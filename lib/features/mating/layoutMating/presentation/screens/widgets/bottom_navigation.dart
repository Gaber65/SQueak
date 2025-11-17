import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../../../../../core/utils/theme/color_mangment/color_manager.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      activeColor: ColorManager.primaryColor,
      backgroundColor:
          MainCubit.get(context).isDark
              ? ThemeData.dark().scaffoldBackgroundColor
              : Colors.white,
      inactiveColor: Colors.grey,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapLocation: GapLocation.none,

      onTap: onTap,
      icons: [IconlyLight.home, Icons.pets, IconlyLight.send, IconlyLight.chat],
      activeIndex: currentIndex,
    );
  }
}
