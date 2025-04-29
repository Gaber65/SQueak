import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';

class PetNameField extends StatelessWidget {
  const PetNameField({
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
          S.of(context).petName,
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        MyTextForm(
          controller: cubit.petNameController,
          prefixIcon: Icon(
            Icons.pets,
            size: 20,
            color: isDark ? ColorManager.sWhite : ColorManager.black_87,
          ),
          enable: false,
          hintText: isArabic() ? 'ادخل الاسم الاليف' : 'Enter pet name',
          validatorText:
              isArabic()
                  ? "من فضلك ادخل الاسم الاليف"
                  : "Please enter pet name",
          obscureText: false,
        ),
      ],
    );
  }
}
