import 'package:flutter/cupertino.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/rate_appointment.dart';
import 'package:squeak/features/layout/layout/presentation/screens/layout_screen.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/presentation/screens/post_notfication.dart';
import '../../../features/auth/login/presentation/pages/login_screen.dart';
import '../../../features/auth/password/presentation/pages/forgot_password.dart';
import '../../../features/auth/register/presentation/pages/register_screen.dart';
import '../../../features/pets/presentation/view/pet_screen.dart';
import '../../../features/vetcare/presenation/view/follow_request_screen.dart';
import '../../../features/vetcare/presenation/view/vet_care_register.dart';

Map<String, WidgetBuilder> routes = {
  '/vetRegister': (context) {
    String invitationCode =
        ModalRoute.of(context)!.settings.arguments as String;
    return VetCareRegister(invitationCode: invitationCode);
  },
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/forgotPassword': (context) => ForgotPasswordScreen(),
  '/layout': (context) => LayoutScreen(),
  '/PetVacs': (context) => const PetScreen(),
  '/Rate':
      (context) => RateAppointment(
        model: ModalRoute.of(context)!.settings.arguments as AppointmentEntity,
        isNav: true,
      ),
  '/followedClinic':
      (context) => FollowRequestScreen(
        clinicID: ModalRoute.of(context)!.settings.arguments as String,
      ),
  '/postNotification':
      (context) => PostNotification(
        id: ModalRoute.of(context)!.settings.arguments as String,
      ),
};
