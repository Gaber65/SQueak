import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../../service/service_locator/service_locator.dart';

class FontStyleThame {
  static TextStyle textStyle({
    double fontSize = 20,
    Color? fontColor,
    FontWeight? fontWeight,
    required context,
  }) {
    return GoogleFonts.notoSans(
      color: fontColor ?? (MainCubit.get(context).isDark
              ? Colors.white
              : Colors.black),
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }
}
