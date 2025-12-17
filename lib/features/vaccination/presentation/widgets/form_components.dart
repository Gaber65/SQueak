import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../../domain/entities/vaccination_entity.dart';
import '../cubit/ui/vaccination_ui_cubit.dart';

Widget buildDropDownBreed(
  List<VaccinationNameEntity> vacEntitiesData,
  BuildContext context,
) {
  final cubit = context.read<VaccinationUiCubit>();
  final isDark = MainCubit.get(context).isDark;

  return DropdownButtonFormField<VaccinationNameEntity>(
    decoration: buildInputDecoration(context),
    isExpanded: true,
    iconSize: 18,
    menuMaxHeight: 200,
    validator: (value) {
      if (value == null || value.vacName == '') {
        return isArabic()
            ? 'الرجاء اختيار نوع التلقيح'
            : 'Please select vaccination type';
      }
      return null;
    },
    iconEnabledColor: isDark ? Colors.white : Colors.black,
    autovalidateMode: AutovalidateMode.onUserInteraction,

    // Ensures the dropdown menu background follows dark mode
    dropdownColor: isDark ? Colors.black : Colors.white,

    // Affects the selected item text shown inside the field after selection
    style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16),

    // Hint when nothing is selected
    hint: Text(
      cubit.valueVacItem,
      style: TextStyle(
        color: isDark ? Colors.white54 : Colors.grey,
        fontSize: 16,
      ),
    ),

    // What happens when the user selects an item
    onChanged: (newValue) {
      if (newValue != null) {
        cubit.changeSelect(vacName: newValue.vacName, vacId: newValue.vacID);
      }
    },

    // The list of dropdown menu items
    items:
        vacEntitiesData.map((VaccinationNameEntity value) {
          return DropdownMenuItem<VaccinationNameEntity>(
            value: value,
            child: Text(
              value.vacName,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
  );
}

Widget buildDropDownFeedSubType(
  List<String> feedSubTypeList,
  BuildContext context,
) {
  final cubit = context.read<VaccinationUiCubit>();

  return DropdownButtonFormField<String>(
    decoration: buildInputDecoration(context),
    isExpanded: true,
    iconSize: 18,
    menuMaxHeight: 200,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return isArabic()
            ? 'الرجاء اختيار نوع معين الطعام'
            : 'Please select feed sub type';
      }
      return null;
    },
    iconEnabledColor: Colors.black,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    hint: Text(cubit.feedSubTypeValue),
    onChanged: (newValue) {
      cubit.feedSubTypeValue = newValue.toString();
    },
    items:
        feedSubTypeList.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
  );
}

Widget buildDropDownFreq(List<String> freq, BuildContext context) {
  final cubit = context.read<VaccinationUiCubit>();

  return DropdownButtonFormField<String>(
    decoration: buildInputDecoration(context),
    isExpanded: true,
    iconSize: 18,
    menuMaxHeight: 200,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return isArabic()
            ? 'الرجاء اختيار عدد مرات التكرار'
            : 'Please select frequency';
      }
      return null;
    },
    iconEnabledColor: Colors.black,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    hint: Text(
      cubit.currentFreq,
      style: FontStyleThame.textStyle(
        context: context,
        fontColor:
            MainCubit.get(context).isDark
                ? ColorManager.sWhite
                : ColorManager.black_87,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
    ),

    onChanged: (newValue) {
      cubit.currentFreq = newValue.toString();
    },
    items:
        freq.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
  );
}

Widget buildSelectDateVac(BuildContext context, VaccinationUiCubit cubit) {
  return InkWell(
    onTap: () {
      cubit.selectDate(context);
    },
    child: IgnorePointer(
      child: MyTextForm(
        controller: TextEditingController(
          text:
              // ignore: unrelated_type_equality_checks
              cubit.currentDateItem == ''
                  ? isArabic()
                      ? 'من فضلك ادخل تاريخ الميلاد'
                      : 'Please enter data of birth'
                  : cubit.currentDateItem.toString().substring(0, 10),
        ),
        enabled: false,
        prefixIcon: const Icon(Icons.calendar_month, size: 14),
        enable: false,
        hintText:
            isArabic()
                ? 'من فضلك ادخل تاريخ الميلاد'
                : 'Please enter data of birth',
        validatorText:
            isArabic()
                ? 'من فضلك ادخل تاريخ الميلاد'
                : 'Please enter data of birth',
        obscureText: false,
      ),
    ),
  );
}

Widget buildDropDownFreqForEdit(
  List<String> freq,
  BuildContext context,
  String initFreValue,
  VaccinationUiCubit cubit,
) {
  return DropdownButtonFormField<String>(
    decoration: buildInputDecoration(context),
    isExpanded: true,
    iconSize: 18,
    menuMaxHeight: 200,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return isArabic()
            ? 'الرجاء اختيار عدد مرات التكرار'
            : 'Please select frequency';
      }
      return null;
    },
    iconEnabledColor: Colors.black,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    hint: Text(initFreValue),
    onChanged: (newValue) {
      cubit.updateTheFrequency(newValue.toString());
    },
    items:
        freq.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
  );
}

InputDecoration buildInputDecoration(BuildContext context) {
  final isDark = MainCubit.get(context).isDark;

  return InputDecoration(
    contentPadding: const EdgeInsets.only(right: 10, left: 10),
    filled: true,
    fillColor: isDark ? Colors.black26 : Colors.grey.shade200, // ✅ Key change

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),

    labelStyle: FontStyleThame.textStyle(
      context: context,
      fontColor: isDark ? ColorManager.sWhite : ColorManager.black_87,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
  );
}
