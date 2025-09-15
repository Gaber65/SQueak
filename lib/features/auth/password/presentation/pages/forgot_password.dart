// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/service/global_widget/vc_loading_widget.dart';
import 'package:squeak/features/auth/password/data/datasources/password_remote_data_source.dart';
import 'package:squeak/features/auth/password/data/repositories/password_repo.dart';
import 'package:squeak/features/auth/password/domin/usecses/forget_password_usecase.dart';
import 'package:squeak/features/auth/password/domin/usecses/reset_password_usecase.dart';
import 'package:squeak/features/auth/password/domin/usecses/verify_user_usecase.dart';
import 'package:squeak/features/auth/password/presentation/cubit/password_cubit.dart';
import 'package:squeak/features/auth/password/presentation/pages/reset_password.dart';
import '../../../contactus/presentation/pages/contact_us.dart';
import '../../../login/presentation/pages/login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => PasswordCubit(
            forgetPasswordUseCase: ForgetPasswordUseCase(
              PasswordRepoImpl(remoteDataSource: PasswordRemoteDataSource()),
            ),
            resetPasswordUseCase: ResetPasswordUseCase(
              PasswordRepoImpl(remoteDataSource: PasswordRemoteDataSource()),
            ),
            verifyUserUseCase: VerifyUserUseCase(
              PasswordRepoImpl(remoteDataSource: PasswordRemoteDataSource()),
            ),
          ),
      child: BlocConsumer<PasswordCubit, PasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordErrorState) {
            errorToast(context, state.error);
          }
          if (state is ForgetPasswordSuccessState) {
            navigateToScreen(
              context,
              ResetPasswordScreen(
                emailController: context.read<PasswordCubit>().emailController,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<PasswordCubit>();
          return Scaffold(
            backgroundColor: const Color(0xFFF8F6FF),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                InkWell(
                  onTap: () => navigateToScreen(context, ContactScreen()),
                  borderRadius: BorderRadius.circular(100),
                  child: Card(
                    color: const Color(0xFF7B5CE6).withOpacity(0.15),
                    shape: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.help, color: Color(0xFF7B5CE6)),
                    ),
                  ),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth > 600;
                final fontScale = isTablet ? 1.4 : 1.0;
                final double headerHeight =
                    isTablet
                        ? constraints.maxHeight * 0.4
                        : constraints.maxHeight * 0.38;

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: headerHeight,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7B5CE6),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 30,
                            child: Icon(
                              Icons.pets,
                              color: Colors.white24,
                              size: 50,
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            right: 40,
                            child: Icon(
                              Icons.pets,
                              color: Colors.white24,
                              size: 70,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 80,
                            child: Icon(
                              Icons.pets,
                              color: Colors.white24,
                              size: 50,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 80,
                            child: Icon(
                              Icons.pets,
                              color: Colors.white24,
                              size: 40,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.pets,
                                  color: Colors.white,
                                  size: 60,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Welcome Back!',
                                  style: TextStyle(
                                    fontSize: 28 * fontScale,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    'Your furry friends are waiting for you! 🐾',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16 * fontScale,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 40 : 24,
                          vertical: isTablet ? 30 : 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Forgot Your Password ? 🐾',
                                  style: TextStyle(
                                    fontSize: 20 * fontScale,
                                    fontWeight: FontWeight.bold,
                                    color: ColorManager.secondColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Enter your registered email below to receive a reset code and return to your pet paradise!',
                                  style: TextStyle(
                                    fontSize: 14 * fontScale,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            MyTextForm(
                              controller: cubit.emailController,
                              prefixIcon: const Icon(
                                Icons.alternate_email_sharp,
                                color: ColorManager.secondColor,
                              ),
                              enable: true,
                              hintText: S.of(context).enterUrEmail,
                              validatorText: S.of(context).email_valid,
                              obscureText: false,
                            ),
                            VcLoadingButton(
                              onPressed: () {
                                if (cubit.formKey.currentState!.validate()) {
                                  cubit.forgetPassword();
                                }
                              },
                              isLoading: cubit.isForgetPassword,
                              backgroundColor: ColorManager.secondColor,
                              borderRadius: 14,
                              height: isTablet ? 60 : 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).send,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18 * fontScale,
                                    ),
                                  ),
                                  SizedBox(width: 8 * fontScale),
                                  Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                    size: 22 * fontScale,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Remembered your password ?',
                                  style: TextStyle(
                                    fontSize: 14 * fontScale,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () => navigateToScreen(
                                        context,
                                        LoginScreen(),
                                      ),
                                  child: Text(
                                    S.of(context).login,
                                    style: TextStyle(
                                      fontSize: 14 * fontScale,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.secondColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 8,
                              alignment: WrapAlignment.center,
                              children: List.generate(
                                6,
                                (index) => Icon(
                                  Icons.pets,
                                  size: isTablet ? 40 : 28,
                                  color: const Color(
                                    0xFF7B5CE6,
                                  ).withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
