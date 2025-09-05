// features/auth/password/presentation/cubit/password_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:squeak/features/auth/password/domin/entities/password_entity.dart';
import 'package:squeak/features/auth/password/domin/usecses/forget_password_usecase.dart';
import 'package:squeak/features/auth/password/domin/usecses/reset_password_usecase.dart';
import 'package:squeak/features/auth/password/domin/usecses/verify_user_usecase.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/network/dio.dart';

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
  static get(context) => BlocProvider.of<PasswordCubit>(context);
  bool isForgetPassword = false;
  bool isRestPassword = false;
  bool isVerifyUser = false;

  Future<void> forgetPassword() async {
    isForgetPassword = true;
    emit(ForgetPasswordLoadingState());

    await forgetPasswordUseCase
        .call(emailController.text.trim())
        .then((value) {
          isForgetPassword = false;
          emit(ForgetPasswordSuccessState());
        })
        .catchError((error) {
          isForgetPassword = false;
          ServerException failure = error;
          emit(
            ForgetPasswordErrorState(
              extractFirstErrorAuth(failure.errorMessageModel),
            ),
          );
        });
  }

  Future<void> resetPassword(String email) async {
    isRestPassword = true;
    emit(RestPasswordLoadingState());

    final passwordEntity = PasswordEntity(
      email: email,
      token: codeController.text.trim(),
      newPassword: passwordController.text.trim(),
    );

    await resetPasswordUseCase
        .call(passwordEntity)
        .then((value) {
          isRestPassword = false;

          emit(RestPasswordSuccessState());
        })
        .catchError((error) {
          isRestPassword = false;
          ServerException failure = error;
          emit(
            RestPasswordErrorState(
              extractFirstErrorAuth(failure.errorMessageModel),
            ),
          );
        });
  }

  Future<void> verifyUser(String token, String email, String clinic) async {
    isVerifyUser = true;
    emit(VerifyUserLoadingState());

    await verifyUserUseCase(email, token, clinic)
        .then((value) {
          isVerifyUser = false;
          emit(VerifyUserSuccessState());
        })
        .catchError((error) {
          isVerifyUser = false;
          ServerException failure = error;
          emit(
            VerifyUserErrorState(
              extractFirstErrorAuth(failure.errorMessageModel),
            ),
          );
        });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    codeController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
