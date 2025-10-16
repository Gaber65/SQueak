import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';
import 'package:squeak/features/auth/login/domin/usecses/login_use_case.dart';


import 'package:squeak/core/utils/export_path/export_files.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  static LoginCubit get(BuildContext context) => BlocProvider.of(context);
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

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
    
    String emailOrPhone = email ?? emailController.text;
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
        .then((value) {
          // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
          // _performanceMonitor.endOperation('login_process', metadata: {
          //   'success': true,
          //   'user_role': value.role,
          //   'input_type': isEmail(emailOrPhone) ? 'email' : 'phone',
          // });
          
          CacheHelper.saveData('token', value.token);
          MainCubit.get(context).saveToken();
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
            
            emit(LoginError(ErrorMessageModel(
              message: errorMessage,
              statusCode: 0,
              errors: {},
              success: false,
            )));
          }
        });
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
