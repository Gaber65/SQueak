// features/auth/password/presentation/cubit/password_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:squeak/features/auth/password/domin/entities/password_entity.dart';
import 'package:squeak/features/auth/password/domin/usecses/forget_password_usecase.dart';
import 'package:squeak/features/auth/password/domin/usecses/reset_password_usecase.dart';
import 'package:squeak/features/auth/password/domin/usecses/verify_user_usecase.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final VerifyUserUseCase verifyUserUseCase;

  PasswordCubit({
    required this.forgetPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.verifyUserUseCase,
  }) : super(PasswordInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();

  bool isForgetPassword = false;
  bool isRestPassword = false;
  bool isVerifyUser = false;

  Future<void> forgetPassword() async {
    isForgetPassword = true;
    emit(ForgetPasswordLoadingState());
    
    final result = await forgetPasswordUseCase(emailController.text.trim());
    
    result.fold(
      (failure) {
        isForgetPassword = false;
        emit(ForgetPasswordErrorState(failure.message));
      },
      (_) {
        isForgetPassword = false;
        emit(ForgetPasswordSuccessState());
      },
    );
  }

  Future<void> resetPassword(String email) async {
    isRestPassword = true;
    emit(RestPasswordLoadingState());
    
    final passwordEntity = PasswordEntity(
      email: email,
      token: codeController.text.trim(),
      newPassword: passwordController.text.trim(),
    );
    
    final result = await resetPasswordUseCase(passwordEntity);
    
    result.fold(
      (failure) {
        isRestPassword = false;
        emit(RestPasswordErrorState(failure.message));
      },
      (_) {
        isRestPassword = false;
        emit(RestPasswordSuccessState());
      },
    );
  }

  Future<void> verifyUser(String token, String email) async {
    isVerifyUser = true;
    emit(VerifyUserLoadingState());
    
    final result = await verifyUserUseCase(email, token);
    
    result.fold(
      (failure) {
        isVerifyUser = false;
        emit(VerifyUserErrorState(failure.message));
      },
      (_) {
        isVerifyUser = false;
        emit(VerifyUserSuccessState());
      },
    );
  }
 final TextEditingController followCodeController = TextEditingController();
  
  void initTheVerifyUser({required String? newOtp}) {
    followCodeController.text = newOtp ?? ""; // Initialize from cache
  }
  

  @override
  Future<void> close() {
        followCodeController.dispose(); // Clean up

    emailController.dispose();
    codeController.dispose();
    passwordController.dispose();
    return super.close();
  }
}