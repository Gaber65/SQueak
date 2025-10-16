import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/service/global_widget/vc_loading_widget.dart';
import 'package:squeak/features/auth/login/presentation/pages/login_screen.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key, required this.cubit});

  final RegisterCubit cubit;

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
              S.of(context).register,
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// name
            SizedBox(height: 10),
            MyTextForm(
              controller: cubit.nameController,
              prefixIcon: const Icon(Icons.person, size: 14),
              enable: false,
              hintText: S.of(context).enterName,
              validatorText: S.of(context).enterName,
              obscureText: false,
            ),

            /// email
            SizedBox(height: 20),
            MyTextForm(
              controller: cubit.emailController,
              prefixIcon: const Icon(Icons.alternate_email_sharp, size: 14),
              enable: false,
              hintText: S.of(context).enterUrEmail,
              validatorText: S.of(context).enterUrEmail,
              obscureText: false,
            ),

            /// phone
            SizedBox(height: 20),
            PhoneTextField(
              controller: cubit.phoneController,
              countries: RegisterCubit.get(context).countries,
              registerCubit: cubit,
            ),

            /// password
            SizedBox(height: 20),
            MyTextForm(
              controller: cubit.passwordController,
              prefixIcon: const Icon(Icons.lock, size: 14),
              enable: true,
              hintText: S.of(context).enterUrPassword,
              validatorText: S.of(context).enterUrPassword,
              obscureText: false,
            ),

            /// Clinic Code
            SizedBox(height: 10),
            MyTextForm(
              controller: cubit.followCodeController,
              prefixIcon: const Icon(Icons.person, size: 14),
              enable: false,
              hintText: S.of(context).followCode,
              obscureText: false,
              keyboardType: TextInputType.text,
            ),

            /// Register
            SizedBox(height: 20),
            VcLoadingButton(
              onPressed: () {
                if (cubit.formKey.currentState!.validate()) {
                  if (cubit.countryCode.isEmpty) {
                    infoToast(
                      context,
                      isArabic()
                          ? 'يرجى اختيار دولتك قبل متابعة التسجيل.'
                          : 'Please select your country before proceeding with registration.',
                    );
                  } else {
                    cubit.register();
                  }
                }
              },
              isLoading: cubit.isRegister,
              child: Text(
                S.of(context).register,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).alreadyHaveAccount,
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 14,
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
