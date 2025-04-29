import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/authentication/controller/auth_cubit.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../generated/l10n.dart';
import 'contact_us.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({
    Key? key,
    required this.emailController,
  }) : super(key: key);
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RestPasswordErrorState) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }
          if (state is RestPasswordSuccessState) {
            successToast(
              context,

                state.error.message,

            );
            navigateAndFinish(context, LoginScreen());
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
                      FastCachedImage(
                        height: 300,
                        url:
                            'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/two-factor-authentication-concept-illustration.png?alt=media&token=1a1b2ffc-7a15-423b-b2c8-7e05eb213727',
                      ),
                      Text(
                        isArabic()
                            ? 'إنشاء كلمة مرور جديدة'
                            : 'Create New Password',
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
                            ? 'الرجاء إدخال الرمز الرقمي المرسل إلى بريدك الإلكتروني إلى ${cubit.emailController.text}'
                            : 'Please enter The Digit Code Sent To Your Email To ${cubit.emailController.text}',
                        textAlign: TextAlign.center,
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextForm(
                        controller: cubit.codeController,
                        prefixIcon: const Icon(
                          Icons.numbers,
                          size: 14,
                        ),
                        enable: false,
                        hintText: S.of(context).receiveCode,
                        validatorText:isArabic() ? 'من فضلك ادخل الرمز' : 'Please enter the code',
                        obscureText: false,
                      ),

                      /// password
                      SizedBox(
                        height: 20,
                      ),
                      MyTextForm(
                        controller: cubit.passwordController,
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 14,
                        ),
                        enable: true,
                        hintText: S.of(context).password_hint,
                        validatorText: S.of(context).password_validation,
                        obscureText: false,
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
                            backgroundColor: ColorManager.primaryColor,
                          ),
                          onPressed: cubit.isRestPassword
                              ? null
                              : () {
                                  if (cubit.formKey.currentState!.validate()) {
                                    cubit.restPassword(emailController.text);
                                  }
                                },
                          child: cubit.isRestPassword
                              ? CircularProgressIndicator()
                              : Text(S.of(context).save),
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
