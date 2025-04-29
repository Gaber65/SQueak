import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/generated/l10n.dart';

import '../../../controller/pet_cubit.dart';

class GenderSection extends StatelessWidget {
  const GenderSection({
    super.key,
    required this.cubit,
  });

  final PetCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          S.of(context).gender,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                context,
                S.of(context).male,
                1,
                cubit,
                cubit.gender == 1,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderOption(
                context,
                S.of(context).female,
                2,
                cubit,
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
    PetCubit cubit,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => cubit.changeGender(id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primaryColor
              : ColorManager.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? ColorManager.primaryColor
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : ColorManager.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
