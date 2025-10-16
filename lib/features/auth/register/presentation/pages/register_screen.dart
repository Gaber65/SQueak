import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/auth/password/presentation/pages/verfiy_user_screen.dart';
import 'package:squeak/features/auth/register/data/datasources/register_remote_data_source.dart';
import 'package:squeak/features/auth/register/data/repositories/register_repository_impl.dart';
import 'package:squeak/features/auth/register/domin/usecses/get_countries_use_case.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_qr_use_case.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_use_case.dart';

import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:squeak/features/auth/register/presentation/widgets/enhanced_register_widget.dart';
import 'package:squeak/features/auth/register/presentation/widgets/enhanced_auth_header.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final remoteDataSource = RegisterRemoteDataSource();
        final repository = RegisterRepositoryImpl(remoteDataSource);
        final cubit = RegisterCubit(
          getCountriesUseCase: GetCountriesUseCase(repository),
          registerUseCase: RegisterUseCase(repository),
          registerQrUseCase: RegisterQrUseCase(repository),
        );

        // Initialize necessary data
        cubit.loadCountries().then((value) => cubit.detectCountryCode());

        return cubit;
      },
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegistrationErrorState) {
            errorToast(context, state.error);
          }
          if (state is RegistrationSuccessState) {
            navigateAndFinish(
              context,
              VerifyUser(
                emailController: RegisterCubit.get(context).emailController,
                clinicCode: RegisterCubit.get(context).followCodeController,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = RegisterCubit.get(context);

          return EnhancedAuthHeader(
            title: 'Join the Pack! 🐾',
            subtitle: 'Create your account to connect with pet care',
            child: EnhancedRegisterView(cubit: cubit),
          );
        },
      ),
    );
  }
}
