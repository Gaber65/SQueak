import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:squeak/features/appointments/models/get_appointment_model.dart';
import 'package:squeak/features/vetcare/view/pet_merge_screen.dart';

import '../appointments/view/appointments/rate_appointment.dart';
import '../authentication/view/login_screen.dart';
import '../vetcare/view/vetCareRegister.dart';
import 'controller/layout_cubit.dart';
import 'layout.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

/// SplashScreen Widget
class SplashScreen extends StatefulWidget {
  final String invitationCode;

  const SplashScreen({Key? key, required this.invitationCode})
      : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _navigateToNextScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: Center(
        //   child: Padding(
        //     padding: const EdgeInsets.all(32.0),
        //     child: Image.asset(
        //       'assets/Logo.png',
        //       // width: double.infinity,
        //       // fit: BoxFit.cover,
        //       // height: MediaQuery.of(context).size.height,
        //     ),
        //   ),
        // ),
        );
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(microseconds: 1));

    final bool isForceRate = CacheHelper.getBool('IsForceRate');
    final String? token = CacheHelper.getData('token');
    final String? codeForce = CacheHelper.getData('CodeForce');
    final String? rateModelData = CacheHelper.getData('RateModel');

    if (widget.invitationCode.isNotEmpty) {
      _navigateAndReplace(
        VetCareRegister(invitationCode: widget.invitationCode),
      );
    } else {
      if (token == null) {
        _navigateAndReplace(LoginScreen());
      } else if (codeForce != null) {
        LayoutCubit.get(context).getOwnerPet();
        _navigateAndReplace(
          PetMergeScreen(Code: codeForce, isNavigation: false),
        );
      } else if (isForceRate && rateModelData != null) {
        final AppointmentModel model =
            AppointmentModel.fromJson(jsonDecode(rateModelData));
        _navigateAndReplace(
          RateAppointment(model: model, isNav: false),
        );
      } else {
        _navigateAndReplace(LayoutScreen());
      }
    }
  }

  // Helper method to navigate and replace the current screen
  void _navigateAndReplace(Widget nextScreen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }
}
