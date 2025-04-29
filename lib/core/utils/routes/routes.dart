import 'package:flutter/cupertino.dart';
import 'package:squeak/features/appointments/models/get_appointment_model.dart';
import 'package:squeak/features/appointments/view/appointments/rate_appointment.dart';
import 'package:squeak/features/authentication/view/forgot_password.dart';
import 'package:squeak/features/authentication/view/login_screen.dart';
import 'package:squeak/features/authentication/view/register_screen.dart';
import 'package:squeak/features/layout/layout/view/layout.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/presentation/screens/post_notfication.dart';

import '../../../features/pets/presentation/view/pet_screen.dart';
import '../../../features/vetcare/presenation/view/follow_request_screen.dart';
import '../../../features/vetcare/presenation/view/vetCareRegister.dart';

Map<String, WidgetBuilder> routes = {
  '/vetRegister': (context) {
    String invitationCode =
        ModalRoute.of(context)!.settings.arguments as String;
    return VetCareRegister(invitationCode: invitationCode);
  },
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/forgotPassword': (context) => ForgotPasswordScreen(),
  '/layout': (context) =>  LayoutScreen(),
  '/PetVacs': (context) => const PetScreen(),
  '/Rate': (context) => RateAppointment(
        model: ModalRoute.of(context)!.settings.arguments as AppointmentModel,
        isNav: true,
      ),
  '/followedClinic': (context) => FollowRequestScreen(
        clinicID: ModalRoute.of(context)!.settings.arguments as String,
      ),
  '/postNotification': (context) => PostNotification(
        id: ModalRoute.of(context)!.settings.arguments as String,
      ),
};
