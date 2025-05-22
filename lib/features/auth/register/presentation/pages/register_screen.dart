import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/auth/login/presentation/pages/login_screen.dart';
import 'package:squeak/features/auth/password/presentation/pages/verfiy_user_screen.dart';
import 'package:squeak/features/auth/register/data/datasources/register_remote_data_source.dart';
import 'package:squeak/features/auth/register/data/repositories/register_repository_impl.dart';
import 'package:squeak/features/auth/register/domin/usecses/get_countries_use_case.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_qr_use_case.dart';
import 'package:squeak/features/auth/register/domin/usecses/register_use_case.dart';

import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:squeak/features/auth/register/presentation/widgets/authItem.dart';
import 'package:squeak/features/auth/register/presentation/widgets/register_widget.dart';

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
        cubit.loadCountries();
        cubit.detectCountryCode();

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
              ),
            );
          }
          
          // Handle country loading errors
          if (state is CountriesErrorState) {
            debugPrint('Failed to load countries: ${state.error}');
          }
          
          // Handle country code detection errors
          if (state is CountryCodeDetectionErrorState) {
            debugPrint('Country code detection failed: ${state.error}');
          }
        },
        builder: (context, state) {
          final cubit = RegisterCubit.get(context);
          
          // Show loading indicator when initializing
          if (state is CountriesLoadingState || 
              state is CountryCodeDetectionLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          return AuthItem(
            widget: RegisterView(cubit: cubit),
          );
        },
      ),
    );
  }
}