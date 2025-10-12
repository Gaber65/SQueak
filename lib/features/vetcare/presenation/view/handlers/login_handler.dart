// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:squeak/features/vetcare/presenation/view/pet_merge_screen.dart';

import '../../controllers/qr_register/qr_cubit.dart';

class LoginHandler {
  static void handleSuccessfulLogin({
    required BuildContext context,
    required LoginSuccess state,
    required String clinicCode,
  }) {
    // Save user data
    _saveUserData(state.userEntity);

    final authCubit = context.read<RegisterCubit>();
    final qrCubit = context.read<QRCubit>();

    if (authCubit.isAccept) {
      _handleDataSharingAccepted(context, qrCubit, clinicCode);
    } else {
      _navigateToLayout(context);
    }
  }

  static void _saveUserData(dynamic userData) {
    CacheHelper.saveData('token', userData.token);
    CacheHelper.saveData('role', userData.role);
    CacheHelper.saveData('clintId', userData.id);
    CacheHelper.saveData('refreshToken', userData.refreshToken);
    CacheHelper.saveData('phone', userData.phone);
    CacheHelper.saveData('name', userData.fullName);
    CacheHelper.saveData('clientName', userData.fullName);
    TokenManager.saveToken(userData.token, userData.expiresIn, userData.refreshToken);
  }

  static void _handleDataSharingAccepted(
      BuildContext context,
      QRCubit qrCubit,
      String clinicCode,
      ) {
    qrCubit
        .getVetClients(clinicCode, false)
        .then((_) {
      final clients = qrCubit.vetClientModel;
      if (clients.isNotEmpty && !clients.first.id.contains('0000')) {
        navigateAndFinish(
          context,
          PetMergeScreen(code: clinicCode, isNavigation: false),
        );
      } else {
        _navigateToLayout(context);
      }
    })
        .catchError((_) {
      _navigateToLayout(context);
    });
  }

  static void _navigateToLayout(BuildContext context) {
    navigateAndFinish(context, LayoutScreen());
  }
}