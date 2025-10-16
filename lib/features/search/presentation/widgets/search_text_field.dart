import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
import 'package:squeak/core/utils/theme/fonts/font_styles.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isTablet;
  final Size screen;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.isTablet,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final mainCubit = context.read<MainCubit>();
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: isTablet ? 24 : screen.width * 0.05,
            color: mainCubit.isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          hintText: isArabic() ? 'ابحث بالاسم او الرقم' : 'Search by name or phone',
          contentPadding: EdgeInsets.symmetric(
            vertical: screen.height * 0.018,
            horizontal: screen.width * 0.04,
          ),
          filled: true,
          hintStyle: FontStyleThame.textStyle(
            context: context,
            fontSize: isTablet ? 16 : screen.width * 0.038,
            fontWeight: FontWeight.w500,
            fontColor: mainCubit.isDark ? Colors.white54 : const Color.fromRGBO(0, 0, 0, .4),
          ),
          fillColor: mainCubit.isDark ? Colors.grey[800] : Colors.grey[100],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: mainCubit.isDark ? Colors.grey[700]! : Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ColorManager.primaryColor,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: mainCubit.isDark ? Colors.grey[700]! : Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}