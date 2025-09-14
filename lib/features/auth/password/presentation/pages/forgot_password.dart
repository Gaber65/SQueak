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
          (BuildContext context) => PasswordCubit(
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
              actions: [
                InkWell(
                  onTap: () {
                    navigateToScreen(context, ContactScreen());
                  },
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
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                final isTablet = width > 600;
                final double fontScale = isTablet ? 1.4 : 1.0;
                final double padding = isTablet ? 32.0 : 20.0;
                final double imageHeight =
                    isTablet ? height * 0.45 : height * 0.38;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: padding / 2,
                  ),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: -imageHeight * 0.1,
                              left: -imageHeight * 0.05,
                              child: Transform.scale(
                                scale: 0.8,
                                child: Icon(
                                  Icons.star,
                                  size: imageHeight * 0.15,
                                  color: const Color(
                                    0xFF7B5CE6,
                                  ).withOpacity(0.2),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -imageHeight * 0.05,
                              right: -imageHeight * 0.1,
                              child: Transform.scale(
                                scale: 1.2,
                                child: Icon(
                                  Icons.heart_broken,
                                  size: imageHeight * 0.2,
                                  color: Colors.red.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Container(
                              height: imageHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF7B5CE6,
                                    ).withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/forgetpassord_new.jpg',
                                  height: imageHeight,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isArabic()
                              ? 'نسيت كلمة المرور؟'
                              : 'Forgot Your Password ? 🐾',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.secondColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isArabic()
                              ? 'أدخل بريدك الإلكتروني المسجل أدناه لاستلام رمز لإعادة التعيين.'
                              : 'Enter your registered email below to receive a reset code and return to your pet paradise!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14 * fontScale,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 30),
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
                        const SizedBox(height: 25),
                        VcLoadingButton(
                          onPressed: () {
                            if (cubit.formKey.currentState!.validate()) {
                              cubit.forgetPassword();
                            }
                          },
                          isLoading: cubit.isForgetPassword,
                          backgroundColor: ColorManager.secondColor,
                          borderRadius: 30,
                          height: isTablet ? 60 : 50,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).send,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16 * fontScale,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(Icons.pets),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isArabic()
                                  ? 'تذكرت كلمة المرور؟'
                                  : 'Remembered your password ?',
                              style: TextStyle(
                                fontSize: 14 * fontScale,
                                color: Colors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                navigateToScreen(context, LoginScreen());
                              },
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
                        const SizedBox(height: 30),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            6,
                            (index) => Icon(
                              Icons.pets,
                              size: isTablet ? 40 : 28,
                              color: const Color(0xFF7B5CE6).withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
