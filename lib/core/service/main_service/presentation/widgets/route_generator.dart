import 'package:flutter/material.dart';
import 'package:squeak/features/authentication/view/login_screen.dart';
import 'package:squeak/features/layout/layout/view/layout.dart';
import '../../../../../features/vetcare/presenation/view/pet_merge_screen.dart';
import '../../../cache/shared_preferences/cache_helper.dart';

Future<Widget> determineStartPoint(BuildContext context) async {
  final String? token = CacheHelper.getData('token');
  final String? codeForce = CacheHelper.getData('CodeForce');

  if (token == null) {
    return LoginScreen();
  } else if (codeForce != null) {
    return PetMergeScreen(code: codeForce, isNavigation: false);
  } else {
    return LayoutScreen();
  }
}
