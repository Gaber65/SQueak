import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';

import '../../../auth/login/data/datasources/login_remote_data_source.dart';
import '../../../auth/login/data/repositories/login_repository.dart';
import '../../../auth/login/domin/usecses/login_use_case.dart';
import '../../../auth/register/data/datasources/register_remote_data_source.dart';
import '../../../auth/register/data/repositories/register_repository_impl.dart';
import '../../../auth/register/domin/usecses/get_countries_use_case.dart';
import '../../../auth/register/domin/usecses/register_qr_use_case.dart';
import '../../../auth/register/domin/usecses/register_use_case.dart';
import '../../../auth/register/presentation/widgets/authItem.dart';
import '../controllers/qr_register/qr_cubit.dart';
import 'widgets/register_view.dart';
import 'handlers/login_handler.dart';

class RegisterQrScreen extends StatelessWidget {
  const RegisterQrScreen({
    super.key,
    required this.clinicCode,
    required this.clinicName,
    required this.clinicLogo,
  });

  final String clinicCode;
  final String clinicName;
  final String clinicLogo;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
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
        ),
        BlocProvider(create: (context) => sl<QRCubit>()),
        BlocProvider(
          create:
              (context) => LoginCubit(
                LoginUseCase(
                  LoginRepositoryImpl(
                    remoteDataSource: LoginRemoteDataSource(),
                  ),
                ),
              ),
        ),
      ],
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegistrationErrorState) {
            _showError(context, state.error);
          }
        },
        builder: (context, state) {
          final authCubit = context.read<RegisterCubit>();
          return BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                LoginHandler.handleSuccessfulLogin(
                  context: context,
                  state: state,
                  clinicCode: clinicCode,
                );
              }
            },
            builder: (context, state) {
              return AuthItem(
                logo: imageUrl + clinicLogo,
                widget: RegisterView(
                  cubit: authCubit,
                  clinicCode: clinicCode,
                  clinicName: clinicName,
                  clinicLogo: clinicLogo,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showError(BuildContext context, String errorMessage) {
    errorToast(context, errorMessage);
  }
}
