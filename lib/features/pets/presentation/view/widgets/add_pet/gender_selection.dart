// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';

class GenderSelection extends StatelessWidget {
  const GenderSelection({super.key, required this.cubit, this.isDark});

  final PetCubit cubit;
  final bool? isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).gender,
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                context,
                isArabic() ? "ذكر" : 'Male',
                1,
                cubit.gender == 1,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderOption(
                context,
                isArabic() ? 'أنثى' : 'Female',
                2,
                cubit.gender == 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(
    BuildContext context,
    String title,
    int id,
    bool isSelected,
  ) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isSelected
            ? ColorManager.primaryColor
            : (dark ? Colors.black26 : ColorManager.white);
    final borderColor =
        isSelected ? ColorManager.primaryColor : Colors.grey.withOpacity(0.3);
    final textColor =
        isSelected
            ? Colors.white
            : (dark ? Colors.white70 : ColorManager.black_87);

    return InkWell(
      onTap: () => cubit.changeGender(id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
