import 'package:squeak/core/service/global_function/format_utils.dart';

import '../../../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../../../../../../core/utils/theme/fonts/font_styles.dart';
import '../../../controller/clinic/appointment_cubit.dart';
import 'package:flutter/material.dart';

Widget buildSearchTextField(AppointmentCubit cubit, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: cubit.searchController,
      onChanged: cubit.filterSuppliers,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText:
            isArabic() ? 'ابحث بالاسم او الكود' : 'Search by name or code',
        contentPadding: const EdgeInsets.all(0),
        filled: true,
        counterStyle: FontStyleThame.textStyle(context: context, fontSize: 13),
        hintStyle: FontStyleThame.textStyle(
          context: context,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontColor:
              MainCubit.get(context).isDark
                  ? Colors.white54
                  : const Color.fromRGBO(0, 0, 0, .3),
        ),
        fillColor:
            MainCubit.get(context).isDark
                ? Colors.black26
                : Colors.grey.shade200,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
