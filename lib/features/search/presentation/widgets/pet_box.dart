// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';

class PetBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final int index;
  final int selectedIndex;
  final bool isTablet;
  final Size screen;
  final bool isLoading;
  final String selectedSpeciesName;
  final VoidCallback onTap;

  const PetBox({
    super.key,
    required this.label,
    required this.icon,
    required this.index,
    required this.selectedIndex,
    required this.isTablet,
    required this.screen,
    this.isLoading = false,
    this.selectedSpeciesName = '',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mainCubit = context.read<MainCubit>();
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: isTablet ? 80 : screen.height * 0.08,
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primaryColor
              : (mainCubit.isDark ? Colors.grey[800] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: ColorManager.primaryColor, width: 2)
              : Border.all(
                  color: mainCubit.isDark ? Colors.grey[700]! : Colors.grey.withOpacity(0.3),
                  width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ColorManager.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label == "Others" && isLoading)
              SizedBox(
                width: isTablet ? 24 : 20,
                height: isTablet ? 24 : 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isSelected ? Colors.white : ColorManager.primaryColor,
                  ),
                ),
              )
            else if (label == "Others" && isSelected && selectedSpeciesName.isNotEmpty)
              Icon(
                Icons.check_circle,
                size: isTablet ? 28 : 24,
                color: isSelected ? Colors.white : ColorManager.primaryColor,
              )
            else
              Icon(
                icon,
                size: label == "Others" ? (isTablet ? 28 : 24) : (isTablet ? 26 : 22),
                color: isSelected
                    ? Colors.white
                    : (mainCubit.isDark ? Colors.white70 : Colors.black87),
              ),
            SizedBox(height: screen.height * 0.008),
            Flexible(
              child: Text(
                label == "Others" && isSelected && selectedSpeciesName.isNotEmpty
                    ? selectedSpeciesName
                    : label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (mainCubit.isDark ? Colors.white70 : Colors.black87),
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 14 : screen.width * 0.032,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}