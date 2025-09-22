// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';

class GenderSelection extends StatelessWidget {
  const GenderSelection({super.key, required this.cubit});

  final PetCubit cubit;

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
    return InkWell(
      onTap: () => cubit.changeGender(id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.primaryColor : ColorManager.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? ColorManager.primaryColor
                    : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : ColorManager.black_87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
