import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:squeak/features/authentication/controller/auth_cubit.dart';
import 'package:squeak/features/authentication/view/widgets/authItem.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../generated/l10n.dart';
import '../../layout/controller/layout_cubit.dart';
import '../../layout/layout.dart';
import '../../vetcare/view/pet_merge_screen.dart';

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
    return BlocProvider(
      create: (context) => AuthCubit()..getCountry(''),
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

            if (AuthCubit.get(context).isAccept) {
              AuthCubit.get(context)
                  .getClintFormVetVoid(clinicCode, false)
                  .then(
                (value) {
                  if (value.isNotEmpty) {
                    if (value.first.id.contains('0000')) {
                      navigateAndFinish(context, LayoutScreen());
                    } else {
                      navigateAndFinish(
                        context,
                        PetMergeScreen(
                          Code: clinicCode,
                          isNavigation: false,
                        ),
                      );
                    }
                  } else {
                    navigateAndFinish(context, LayoutScreen());
                  }
                },
              );
            } else {
              navigateAndFinish(context, LayoutScreen());
            }

            LayoutCubit.get(context).getOwnerPet();
            LayoutCubit.get(context).getOwnerData();
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return AuthItem(
            logo: imageUrl + clinicLogo,
            widget: RegisterView(
              cubit: cubit,
              clinicCode: clinicCode,
              clinicName: clinicName,
              clinicLogo: clinicLogo,
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
    required this.clinicCode,
    required this.clinicName,
    required this.clinicLogo,
  });
  final String clinicCode;
  final String clinicName;
  final String clinicLogo;
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
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$clinicName ',
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: isArabic()
                        ? 'تدعوك للتسجيل في Squeak والبقاء على اتصال. سجل اليوم وتابعنا للحصول على التحديثات!'
                        : 'invites you to register on Squeak and stay connected. Sign up today and follow us for updates!',
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
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
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Checkbox(
                  value: cubit.isAccept,
                  onChanged: (value) {
                    cubit.allToShareDataWithVetICare();
                  },
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 80,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: isArabic()
                              ? 'أنا أوافق على مشاركة الاسم ورقم الهاتف مع'
                              : " I agree to share my Name, telephone number with",
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: " $clinicName",
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: isArabic()
                              ? '، للحصول على العروض والعروض ومعلومات الخدمة'
                              : " for receiving offers, promotions, and service information.,",
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
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
                  backgroundColor: ColorManager.primaryColor,
                ),
                onPressed: cubit.isLoggedIn
                    ? null
                    : () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.registerQr(clinicCode, context);
                        }
                      },
                child: cubit.isLoggedIn
                    ? CircularProgressIndicator()
                    : Text(S.of(context).register),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
