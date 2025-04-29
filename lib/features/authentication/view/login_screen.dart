import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:squeak/features/authentication/controller/auth_cubit.dart';
import 'package:squeak/features/authentication/view/forgot_password.dart';
import 'package:squeak/features/authentication/view/register_screen.dart';
import 'package:squeak/features/authentication/view/widgets/authItem.dart';
import 'package:squeak/features/authentication/view/widgets/phone_or_email_form.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/layout/layout.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../generated/l10n.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ErrorLoginState) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }
          if (state is SuccessLoginState) {
            CacheHelper.saveData('token', state.userModel.data!.token);
            CacheHelper.saveData('role', state.userModel.data!.role);
            CacheHelper.saveData('clintId', state.userModel.data!.id);
            CacheHelper.saveData(
                'refreshToken', state.userModel.data!.refreshToken);
            CacheHelper.saveData('phone', state.userModel.data!.phone);
            CacheHelper.saveData('name', state.userModel.data!.fullName);
            CacheHelper.saveData(
              'clientName',
              state.userModel.data!.fullName,
            );
            LayoutCubit.get(context).getOwnerPet();
            LayoutCubit.get(context).getOwnerData();
            navigateAndFinish(context, LayoutScreen());
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return AuthItem(
            widget: LoginView(
              cubit: cubit,
            ),
          );
        },
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({
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
              S.of(context).login,
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 13,
            ),
            EmailOrPhoneField(controller: cubit.emailController),
            SizedBox(
              height: 13,
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
            SizedBox(
              height: 13,
            ),
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
            SizedBox(
              height: 13,
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
                onPressed: cubit.isLoggedIn
                    ? null
                    : () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.login(context);
                        }
                      },
                child: cubit.isLoggedIn
                    ? CircularProgressIndicator()
                    : Text(S.of(context).login),
              ),
            ),
            SizedBox(
              height: 13,
            ),
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
            // SizedBox(
            //   height: 5,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Container(
            //       width: MediaQuery.of(context).size.width / 4,
            //       height: 1,
            //       color: Colors.grey,
            //     ),
            //     SizedBox(
            //       width: 15,
            //     ),
            //     Text(
            //       S.of(context).Orloginasadoctor,
            //       style: FontStyleThame.textStyle(
            //         context: context,
            //         fontSize: 14,
            //         fontColor: MainCubit.get(context).isDark ? Colors.white : Colors.black,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 15,
            //     ),
            //     Container(
            //       width: MediaQuery.of(context).size.width / 4,
            //       height: 1,
            //       color: Colors.grey,
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 13,
            // ),
            // Container(
            //   height: 50,
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       elevation: 0,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       side: BorderSide(
            //         color: MainCubit.get(context).isDark
            //             ? Colors.black.withOpacity(0)
            //             : Colors.grey.shade200,
            //         width: 1,
            //       ),
            //       backgroundColor: MainCubit.get(context).isDark
            //           ? Colors.black54
            //           : Colors.white,
            //     ),
            //     onPressed: () {
            //       navigateToURL('https://vic.veticareapp.com:90/');
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.all(4.0),
            //       child: FastCachedImage(
            //         url: 'https://veticareapp.com/share/logo.png',
            //       ),
            //     ),
            //   ),
            // ),

            // Row(
            //   children: [
            //     Expanded(
            //       child: Container(
            //         height: 50,
            //         child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             elevation: 0,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //             side: BorderSide(
            //               color: Colors.grey.shade200,
            //               width: 1,
            //             ),
            //             backgroundColor: Colors.white,
            //           ),
            //           onPressed: () {
            //             cubit.signInWithFacebook(context);
            //           },
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: FastCachedImage(
            //               url:
            //                   'https://firebasestorage.googleapis.com/v0/b/socail-app-99ae9.appspot.com/o/R.png?alt=media&token=5132d376-4893-438c-9474-2ab95cbf0b5e',
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       child: Container(
            //         height: 50,
            //         child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             elevation: 0,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //             side: BorderSide(
            //               color: Colors.grey.shade200,
            //               width: 1,
            //             ),
            //             backgroundColor: Colors.white,
            //           ),
            //           onPressed: () {},
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: FastCachedImage(
            //                 url:
            //                     'https://firebasestorage.googleapis.com/v0/b/socail-app-99ae9.appspot.com/o/Flat-design-Google-logo-design-Vector-PNG-removebg-preview.png?alt=media&token=44bd601d-0b2f-45d2-8e9c-a412c56321c5'),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

void navigateToURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
