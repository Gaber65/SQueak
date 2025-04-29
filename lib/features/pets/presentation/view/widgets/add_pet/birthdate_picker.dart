import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';

class BirthdatePicker extends StatelessWidget {
  const BirthdatePicker({
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
          isArabic() ? 'تاريخ الميلاد' : 'Date of birth',
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: MyTextForm(
            controller: cubit.birthdateController,
            enabled: false,
            prefixIcon: Icon(
              Icons.calendar_today,
              size: 20,
              color: isDark ? ColorManager.sWhite : ColorManager.black_87,
            ),
            enable: false,
            hintText:
                isArabic()
                    ? 'من فضلك ادخل تاريخ الميلاد'
                    : 'Please enter date of birth',
            validatorText:
                isArabic()
                    ? 'من فضلك ادخل تاريخ الميلاد'
                    : 'Please enter date of birth',
            obscureText: false,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      cubit.changeBirthdate(pickedDate.toString().substring(0, 10));
    }
  }
}
