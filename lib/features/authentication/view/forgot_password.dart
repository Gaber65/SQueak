import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/constant/global_widget/toast.dart';
import 'package:squeak/features/authentication/view/reset_password.dart';

import '../../../core/constant/global_function/custom_text_form_field.dart';
import '../../../core/thames/styles.dart';
import '../../../generated/l10n.dart';
import '../controller/auth_cubit.dart';
import 'contact_us.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgetPasswordErrorState) {
            errorToast(
              context,

                state.error.errors.isNotEmpty
                    ? state.error.errors.values.first.first
                    : state.error.message,

            );
          }

          if (state is ForgetPasswordSuccessState) {
            navigateToScreen(
              context,
              ResetPasswordScreen(
                emailController: AuthCubit.get(context).emailController,
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
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
                      child: Icon(
                        Icons.help,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(
                  24,
                ),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
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
                      const SizedBox(
                        height: 20,
                      ),
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
                      const SizedBox(
                        height: 10,
                      ),
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
                                fontColor: ColorTheme.secondColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: ColorTheme.primaryColor,
                          ),
                          onPressed: cubit.isForgetPassword
                              ? null
                              : () {
                                  if (cubit.formKey.currentState!.validate()) {
                                    cubit.forgetPassword();
                                  }
                                },
                          child: cubit.isForgetPassword
                              ? CircularProgressIndicator()
                              : Text(S.of(context).send),
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
