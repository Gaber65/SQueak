import 'package:flutter/material.dart';

import '../../../../controller/pet_cubit.dart';

Future<void> selectDate(BuildContext context, PetCubit cubit) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
  );
  if (pickedDate != null) {
    cubit.changeBirthdate(pickedDate.toString().substring(0, 10));
  }
}
