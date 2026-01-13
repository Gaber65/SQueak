import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';
import 'package:squeak/features/auth/login/domin/usecses/login_use_case.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domin/usecses/login_with_facebook.dart';
import '../../domin/usecses/login_with_google.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  static LoginCubit get(BuildContext context) => BlocProvider.of(context);
  final LoginUseCase loginUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LoginWithFacebookUseCase loginWithFacebookUseCase;

  LoginCubit(
    this.loginUseCase,
    this.loginWithGoogleUseCase,
    this.loginWithFacebookUseCase,
  ) : super(LoginInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoggedIn = false;

  Future<void> login(
    BuildContext context, {
    String? email,
    String? password,
  }) async {
    // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
    // _performanceMonitor.startOperation('login_process');

    isLoggedIn = true;
    emit(LoginLoading());

    String emailOrPhone = (email ?? emailController.text).trim();
    // If we trimmed the controller's text, update the controller so the UI reflects
    // the trimmed value while preserving the cursor at the end.
    if (email == null) {
      final current = emailController.text;
      final trimmed = current.trim();
      if (current != trimmed) {
        emailController.text = trimmed;
        emailController.selection = TextSelection.fromPosition(
          TextPosition(offset: trimmed.length),
        );
      }
    }
    if (!isEmail(emailOrPhone)) {
      emailOrPhone = normalizePhoneNumber(emailOrPhone);
    }

    // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
    // _performanceMonitor.trackNetworkRequest(
    //   'login_request',
    //   0, // Will be updated when response comes
    // );

    await loginUseCase(
          emailOrPhoneNumber: emailOrPhone,
          password: password ?? passwordController.text,
        )
        .then((value) async {
          // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
          // _performanceMonitor.endOperation('login_process', metadata: {
          //   'success': true,
          //   'user_role': value.role,
          //   'input_type': isEmail(emailOrPhone) ? 'email' : 'phone',
          // });

          try {
            // حفظ بيانات المستخدم في التخزين المحلي
            // Clear any existing data first
            await CacheHelper.clearData();

            // Save new user data
            await Future.wait([
              CacheHelper.saveData('token', value.token),
              CacheHelper.saveData('role', value.role),
              CacheHelper.saveData('clintId', value.id),
              CacheHelper.saveData('phone', value.phone),
              CacheHelper.saveData('name', value.fullName),
              CacheHelper.saveData('clientName', value.fullName),
              CacheHelper.saveData('username', value.fullName),
              CacheHelper.saveData('email', value.email),
            ]);

            // حفظ التوكن مع وقت انتهاء الصلاحية
            await TokenManager.saveToken(
              value.token,
              value.expiresIn,
              value.refreshToken,
            );

            // إعادة تهيئة حالة التطبيق
            // ignore: use_build_context_synchronously
            MainCubit.get(context).resetState();

            // Reset MainCubit state first
            // ignore: use_build_context_synchronously
            MainCubit.get(context).resetState();

            // Set up notifications after state reset
            // ignore: use_build_context_synchronously
            await MainCubit.get(context).requestNotificationPermissions();
            // ignore: use_build_context_synchronously
            await MainCubit.get(context).saveToken();
          } catch (e) {
            // إذا فشل حفظ البيانات، نقوم بمسح كل شيء ونرمي خطأ
            await CacheHelper.clearData();
            throw Exception('Failed to save login data');
          }

          clearFields();
          isLoggedIn = false;
          emit(LoginSuccess(value));
        })
        .catchError((error) {
          // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
          // _performanceMonitor.recordException(error, StackTrace.current);
          // _performanceMonitor.endOperation('login_process', metadata: {
          //   'success': false,
          //   'error_type': error.runtimeType.toString(),
          //   'input_type': isEmail(emailOrPhone) ? 'email' : 'phone',
          // });

          isLoggedIn = false;
          if (error is ServerException) {
            emit(LoginError(error.errorMessageModel));
          } else {
            // Handle any other type of exception (including FirebaseException)
            String errorMessage = 'An unexpected error occurred';

            // Try to extract message from different exception types
            if (error.toString().contains('Firebase')) {
              errorMessage = 'Firebase authentication failed';
            } else if (error.toString().contains('network')) {
              errorMessage = 'Network connection failed';
            }

            // Check if error has a message property
            try {
              if (error.message != null) {
                errorMessage = error.message.toString();
              }
            } catch (_) {
              // If no message property, use default
            }

            emit(
              LoginError(
                ErrorMessageModel(
                  message: errorMessage,
                  statusCode: 0,
                  errors: {},
                  success: false,
                ),
              ),
            );
          }
        });
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  Future<void> loginWithFacebook() async {
    await FacebookAuth.instance.logOut().then((value) async {
      
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],

      );
      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken!.tokenString;

        final resultRepo = await loginWithFacebookUseCase(
          LoginWithFacebookPrames(
            facebookAccessToken: accessToken,
            isIos: Platform.isIOS,
            isAndroid: Platform.isAndroid,
            fbToken: await FirebaseMessaging.instance.getToken() ?? '',
          ),
        );

        resultRepo.fold(
          (l) => emit(LoginError(l.error)),
          (r) => emit(LoginSuccess(r)),
        );
      }
    });
  }

  Future<void> loginWithGoogle() async {
    GoogleSignIn().signOut().then((value) async {
      final googleUser =
          await GoogleSignIn(
            serverClientId: ConfigModel.serverClientIdGoogle,
          ).signIn();
      if (googleUser == null) return;

      final auth = await googleUser.authentication;
      final resultRepo = await loginWithGoogleUseCase(
        LoginWithFacebookPrames(
          facebookAccessToken: auth.idToken!,
          isIos: Platform.isIOS,
          isAndroid: Platform.isAndroid,
          fbToken: await FirebaseMessaging.instance.getToken() ?? '',
        ),
      );
      resultRepo.fold(
        (l) => emit(LoginError(l.error)),
        (r) => emit(LoginSuccess(r)),
      );
    });
  }

  @override
  Future<void> close() {
    // Dispose controllers when cubit is closed to avoid memory leaks
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
