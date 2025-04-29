import 'package:flutter/material.dart';
import 'package:squeak/features/authentication/view/login_screen.dart';
import 'package:squeak/features/layout/layout.dart';
import 'package:squeak/features/vetcare/view/pet_merge_screen.dart';

import '../../../../../features/layout/controller/layout_cubit.dart';
import '../../../cache/shared_preferences/cache_helper.dart';

Future<Widget> determineStartPoint(BuildContext context) async {
  final String? token = CacheHelper.getData('token');
  final String? codeForce = CacheHelper.getData('CodeForce');

  if (token == null) {
    return LoginScreen();
  } else if (codeForce != null) {
    LayoutCubit.get(context).getOwnerPet();
    return PetMergeScreen(Code: codeForce, isNavigation: false);
  } else {
    return LayoutScreen();
  }
}
