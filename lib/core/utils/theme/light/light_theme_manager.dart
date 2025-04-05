import 'package:flutter/material.dart';

import '../fonts/font_styles.dart';

ThemeData buildThemeDataLight(BuildContext context) {
  return ThemeData(
    useMaterial3: false,

    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 3,
      backgroundColor: Colors.white,
      unselectedItemColor: Color.fromRGBO(207, 207, 206, 1),
      selectedIconTheme: IconThemeData(size: 18),
      unselectedIconTheme: IconThemeData(size: 18),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: FontStyleThame.textStyle(
        context: context,
        fontColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
  );
}

