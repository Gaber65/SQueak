import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
    isLoggedIn = true;
    emit(LoginLoading());
    String emailOrPhone = email ?? emailController.text;
    if (!isEmail(emailOrPhone)) {
      emailOrPhone = normalizePhoneNumber(emailOrPhone);
    }

    await loginUseCase(
          emailOrPhoneNumber: emailOrPhone,
          password: password ?? passwordController.text,
        )
        .then((value) {
          CacheHelper.saveData('token', value.token);
          MainCubit.get(context).saveToken();
          clearFields();
          isLoggedIn = false;
          emit(LoginSuccess(value));
        })
        .catchError((error) {
          isLoggedIn = false;
          ServerException failure = error;
          emit(LoginError(failure.errorMessageModel));
        });
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
