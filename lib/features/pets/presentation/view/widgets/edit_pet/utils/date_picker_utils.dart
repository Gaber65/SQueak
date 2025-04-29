import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../../controller/pet_cubit.dart';

Future<void> selectDate(BuildContext context, PetCubit cubit) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: ColorManager.primaryColor,
            onPrimary: Colors.white,
            onSurface: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: ColorManager.primaryColor,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate != null) {
    cubit.changeBirthdate(pickedDate.toString().substring(0, 10));
  }
}
