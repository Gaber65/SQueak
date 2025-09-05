import 'package:fast_cached_network_image/fast_cached_network_image.dart';
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
          var cubit = context.read<PasswordCubit>();
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                InkWell(
                  onTap: () {
                    navigateToScreen(context, ContactScreen());
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Card(
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.help, size: 25),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        isArabic()
                            ? 'نسيت كلمة السر؟'
                            : 'Forgot your password ?',
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isArabic()
                            ? 'أدخل بريدك الإلكتروني المسجل أدناه لتلقي رمز لإعادة تعيين كلمة المرور الخاصة بك'
                            : 'Enter your registered email below to receive a code to reset your password.',
                        textAlign: TextAlign.center,
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontColor: Colors.grey,
                        ),
                      ),
                      FastCachedImage(
                        height: 300,
                        url:
                            'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/two-factor-authentication-concept-illustration.png?alt=media&token=1a1b2ffc-7a15-423b-b2c8-7e05eb213727',
                      ),
                      MyTextForm(
                        controller: cubit.emailController,
                        prefixIcon: const Icon(
                          Icons.alternate_email_sharp,
                          size: 14,
                        ),
                        enable: false,
                        hintText: S.of(context).enterUrEmail,
                        validatorText: S.of(context).email_valid,
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic()
                                ? 'تذكرت كلمة المرور؟'
                                : 'Remember password ?',
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontSize: 16,
                              fontColor: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              navigateToScreen(context, LoginScreen());
                            },
                            child: Text(
                              S.of(context).login,
                              style: FontStyleThame.textStyle(
                                context: context,
                                fontSize: 16,
                                fontColor: ColorManager.secondColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      VcLoadingButton(
                        onPressed: () {
                          if (cubit.formKey.currentState!.validate()) {
                            cubit.forgetPassword();
                          }
                        },
                        isLoading: cubit.isForgetPassword,
                        child: Text(
                          S.of(context).send,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
