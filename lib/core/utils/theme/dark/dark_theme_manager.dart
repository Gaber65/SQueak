import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


ThemeData buildThemeData() {
  return ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
    ),
    scaffoldBackgroundColor: ThemeData.dark().scaffoldBackgroundColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 3,
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      unselectedItemColor: Color.fromRGBO(207, 207, 206, 1),
      selectedIconTheme: IconThemeData(size: 18),
      unselectedIconTheme: IconThemeData(size: 18),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black26,
        statusBarIconBrightness: Brightness.light,
      ),
      elevation: 0,
    ),
  );
}