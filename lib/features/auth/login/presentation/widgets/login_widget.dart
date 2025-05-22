import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:squeak/features/auth/password/presentation/pages/forgot_password.dart';
import 'package:squeak/features/auth/register/presentation/pages/register_screen.dart';
import 'package:squeak/features/auth/register/presentation/widgets/phone_or_email_form.dart';
import 'package:squeak/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.cubit});

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: cubit.formKey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).login,
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 13),
            EmailOrPhoneField(controller: cubit.emailController),
            SizedBox(height: 13),
            MyTextForm(
              controller: cubit.passwordController,
              prefixIcon: const Icon(Icons.lock, size: 14),
              enable: true,
              hintText: S.of(context).password_hint,
              validatorText: S.of(context).password_validation,
              obscureText: false,
            ),
            SizedBox(height: 13),
            InkWell(
              onTap: () {
                navigateToScreen(context, ForgotPasswordScreen());
              },
              child: Text(
                S.of(context).forgotPass,
                style: FontStyleThame.textStyle(
                  context: context,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 13),

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
                onPressed:
                    cubit.isLoggedIn
                        ? null
                        : () {
                          if (cubit.formKey.currentState!.validate()) {
                            cubit.login(context);
                          }
                        },
                child:
                    cubit.isLoggedIn
                        ? CircularProgressIndicator()
                        : Text(S.of(context).login),
              ),
            ),
            SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).haveNotAccount,
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 14,
                    fontColor: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    navigateToScreen(context, const RegisterScreen());
                  },
                  child: Text(
                    S.of(context).register,
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 14,
                      fontColor: ColorManager.secondColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToimageUrl(String imageUrl) async {
  if (await canLaunch(imageUrl)) {
    await launch(imageUrl);
  } else {
    throw 'Could not launch $imageUrl';
  }
}
