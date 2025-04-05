import 'package:flutter/material.dart';


import '../../../cache/shared_preferences/cache_helper.dart';

class RouteGenerator {
  static Route? generateRoute(RouteSettings settings) {
    CacheHelper.saveData('invitationCode', '');
    final uri = Uri.parse(settings.name!);
    final invitationCode = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
    CacheHelper.saveData('invitationCode', invitationCode);

    if (CacheHelper.getData('invitationCode') != '') {
      // return MaterialPageRoute(builder: (context) => VetCareRegister(invitationCode: invitationCode));
    } else {
      // return MaterialPageRoute(builder: (context) => appStartPoint);
    }
  }

 static void navigateToNextScreen() async {
    // // await Future.delayed(const Duration(seconds: 1));
    //
    // final bool isForceRate = CacheHelper.getBool('IsForceRate');
    // final String? token = CacheHelper.getData('token');
    // final String? codeForce = CacheHelper.getData('CodeForce');
    // final String? rateModelData = CacheHelper.getData('RateModel');
    //
    // if (token == null) {
    //   // _navigateAndReplace(LoginScreen());
    //   appStartPoint = LoginScreen();
    // } else if (codeForce != null) {
    //   LayoutCubit.get(context).getOwnerPet();
    //   // _navigateAndReplace(
    //   //   PetMergeScreen(Code: codeForce, isNavigation: false),
    //   // );
    //   appStartPoint = PetMergeScreen(Code: codeForce, isNavigation: false);
    // }
    // // else if (isForceRate && rateModelData != null) {
    // //   final AppointmentModel model =
    // //   AppointmentModel.fromJson(jsonDecode(rateModelData));
    // //   // _navigateAndReplace(
    // //   //   RateAppointment(model: model, isNav: false),
    // //   // );
    // //   appStartPoint = RateAppointment(model: model, isNav: false);
    // // }
    // else {
    //   // _navigateAndReplace(LayoutScreen());
    //   appStartPoint = LayoutScreen();
    // }
  }

}
