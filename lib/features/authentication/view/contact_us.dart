import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/constant/global_function/custom_text_form_field.dart';
import 'package:squeak/core/constant/global_widget/responsive_screen.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/features/authentication/controller/auth_cubit.dart';

import '../../../core/constant/global_function/global_function.dart';
import '../../../core/constant/global_widget/national_phone.dart';
import '../../../core/constant/global_widget/toast.dart';
import '../../../core/thames/styles.dart';
import '../../../generated/l10n.dart';

class ContactScreen extends StatelessWidget {
  ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()
        ..init(context)
        ..getCountry(''),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ContactUsErrorState) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }

          if (state is ContactUsSuccessState) {
            successToast(
              context,
              isArabic()
                  ? 'تم الارسال بنجاح'
                  : 'Your message has been sent successfully',
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                S.of(context).help,
              ),
            ),
            body: _buildBody(context, cubit),
          );
        },
      ),
    );
  }

  Widget _buildBody(context, AuthCubit cubit) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  _buildProfile(context),
                  const SizedBox(height: 80),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: _buildLoginDetail(context, cubit),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final String image =
      'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/cute-little-dog-isolated-yellow.png?alt=media&token=f0b2c1e2-9947-4d3b-b5b9-ed8bbc7baff8';

  Widget _buildProfile(context) {
    return Container(
      width: double.infinity,
      height: ResponsiveScreen.isMobile(context)
          ? MediaQuery.of(context).size.height * 0.2
          : MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(image),
        ),
      ),
    );
  }

  Widget _buildLoginDetail(context, AuthCubit cubit) {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: cubit.formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
            decoration: BoxDecoration(
              color: MainCubit.get(context).isDark
                  ? Colors.grey.shade900
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  hintText: S.of(context).name_hint,
                  validatorText: S.of(context).name_validation,
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
                  hintText: S.of(context).email_hint,
                  validatorText: S.of(context).email_validation,
                  obscureText: false,
                ),

                /// phone
                SizedBox(
                  height: 20,
                ),
                (CacheHelper.getData('token') != null)
                    ? MyTextForm(
                        controller: cubit.phoneController,
                        prefixIcon: const Icon(
                          Icons.phone,
                          size: 14,
                        ),
                        enable: false,
                        enabled: true,
                        hintText: S.of(context).phone_hint,
                        validatorText: S.of(context).phone_validation,
                        obscureText: false,
                      )
                    : PhoneTextField(
                        controller: cubit.phoneController,
                        countries: cubit.countries,
                      ),

                /// title
                SizedBox(
                  height: 20,
                ),
                MyTextForm(
                  controller: cubit.titleController,
                  prefixIcon: const Icon(
                    Icons.title,
                    size: 14,
                  ),
                  enable: false,
                  hintText: isArabic()
                      ? 'ادخال عنوان المشكلة'
                      : 'enter your problem title',
                  validatorText: isArabic()
                      ? 'الرجاء ادخال عنوان المشكلة'
                      : 'Please enter your problem title',
                  obscureText: false,
                ),

                /// comment
                SizedBox(
                  height: 20,
                ),
                MyTextForm(
                  controller: cubit.commentController,
                  prefixIcon: SizedBox(),
                  maxLines: 5,
                  enable: false,
                  hintText: isArabic()
                      ? 'ادخال تعليقك علي المشكلة'
                      : 'Enter your problem comment',
                  validatorText: isArabic()
                      ? 'الرجاء ادخال عنوان المشكلة'
                      : 'Please enter your problem comment',
                  obscureText: false,
                ),
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
                    onPressed: cubit.isContactUs
                        ? null
                        : () {
                            if (cubit.formKey.currentState!.validate()) {
                              cubit.contactUs();
                            }
                          },
                    child: cubit.isContactUs
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
  }
}
