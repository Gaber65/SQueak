import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:squeak/features/auth/login/data/repositories/login_repository.dart';
import 'package:squeak/features/auth/login/domin/usecses/login_use_case.dart';
import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:squeak/features/auth/login/presentation/widgets/login_widget.dart';
import 'package:squeak/features/auth/register/presentation/widgets/authItem.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        LoginUseCase(
          LoginRepositoryImpl(
            remoteDataSource: LoginRemoteDataSource(),
          ),
        ),
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }
          if (state is LoginSuccess) {
            CacheHelper.saveData('role', state.userEntity.role);
            CacheHelper.saveData('clintId', state.userEntity.id);
            CacheHelper.saveData('phone', state.userEntity.phone);
            CacheHelper.saveData('name', state.userEntity.fullName);
            CacheHelper.saveData('clientName', state.userEntity.fullName);
            CacheHelper.saveData('username', state.userEntity.fullName);
            CacheHelper.saveData('email', state.userEntity.email);
            TokenManager.saveToken(state.userEntity.token, state.userEntity.expiresIn, state.userEntity.refreshToken);
            navigateAndFinish(context, LayoutScreen());
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return AuthItem(
            widget: LoginView(
              cubit: cubit,
            ),
          );
        },
      ),
    );
  }
}