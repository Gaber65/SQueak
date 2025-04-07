import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/constant/global_widget/national_phone.dart';
import 'package:squeak/features/authentication/controller/auth_cubit.dart';
import 'package:squeak/features/authentication/view/verfiy_user_screen.dart';
import 'package:squeak/features/authentication/view/widgets/authItem.dart';

import '../../../core/constant/global_function/custom_text_form_field.dart';
import '../../../core/constant/global_widget/toast.dart';
import '../../../core/thames/styles.dart';
import '../../../generated/l10n.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()
        ..getCountry('')
        ..getCountryCode(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ErrorRegisterState) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }
          if (state is SuccessRegisterState) {
            navigateAndFinish(
              context,
              VerifyUser(
                emailController: AuthCubit.get(context).emailController,
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return AuthItem(
            widget: RegisterView(
              cubit: cubit,
            ),
          );
        },
      ),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({
    super.key,
    required this.cubit,
  });

  final AuthCubit cubit;

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
            SizedBox(
              height: 10,
            ),
            MyTextForm(
              controller: cubit.nameController,
              prefixIcon: const Icon(
                Icons.person,
                size: 14,
              ),
              enable: false,
              hintText: S.of(context).enterName,
              validatorText: S.of(context).enterName,
              obscureText: false,
            ),

            /// email
            SizedBox(
              height: 20,
            ),
            MyTextForm(
              controller: cubit.emailController,
              prefixIcon: const Icon(
                Icons.alternate_email_sharp,
                size: 14,
              ),
              enable: false,
              hintText: S.of(context).enterUrEmail,
              validatorText: S.of(context).enterUrEmail,
              obscureText: false,
            ),

            /// phone
            SizedBox(
              height: 20,
            ),
            PhoneTextField(
              controller: cubit.phoneController,
              countries: cubit.countries,
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
              hintText: S.of(context).enterUrPassword,
              validatorText: S.of(context).enterUrPassword,
              obscureText: false,
            ),

            /// Clinic Code
            SizedBox(
              height: 10,
            ),
            MyTextForm(
              controller: cubit.followCodeController,
              prefixIcon: const Icon(
                Icons.person,
                size: 14,
              ),
              enable: false,
              hintText: S.of(context).followCode,
              obscureText: false,
              keyboardType: TextInputType.text,
            ),

            /// Register
            SizedBox(
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
                onPressed: cubit.isRegister
                    ? null
                    : () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.register();
                        }
                      },
                child: cubit.isRegister
                    ? CircularProgressIndicator()
                    : Text(S.of(context).register),
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                      fontColor: ColorTheme.secondColor,
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
