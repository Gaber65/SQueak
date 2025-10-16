import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';

class GeneralInformationSection extends StatelessWidget {
  const GeneralInformationSection({
    super.key,
    required this.cubit,
    required this.isDark,
  });

  final PetCubit cubit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).generalInformation,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  cubit.spayed ? Icons.health_and_safety : Icons.pets,
                  color: ColorManager.primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  cubit.spayed ? S.of(context).spayed : S.of(context).notSpayed,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Switch(
                  value: cubit.spayed,
                  activeColor: ColorManager.primaryColor,
                  onChanged: (_) => cubit.changeSpayed(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          S.of(context).petName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        MyTextForm(
          controller: cubit.petNameController,
          prefixIcon: Icon(Icons.pets, size: 20),
          enable: false,
          hintText: S.of(context).enterPetName,
          validatorText: S.of(context).enterPetNameValidation,
          obscureText: false,
        ),
      ],
    );
  }
}
