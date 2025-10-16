import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/presentation/view/widgets/edit_pet/utils/date_picker_utils.dart';

import '../../../controller/pet_cubit.dart';


class BirthdateSection extends StatelessWidget {
  const BirthdateSection({
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
        const SizedBox(height: 20),
        Text(
          S.of(context).birthdate,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => selectDate(context, cubit),
          child: MyTextForm(
            controller: cubit.birthdateController,
            enabled: true,
            prefixIcon: Icon(Icons.calendar_today, size: 20),
            enable: false,
            hintText: S.of(context).birthdateValidation,
            validatorText: S.of(context).birthdateValidation,
            obscureText: false,
            onTap: () => selectDate(context, cubit),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
