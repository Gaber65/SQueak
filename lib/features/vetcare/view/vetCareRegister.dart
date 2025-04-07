import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/constant/global_widget/toast.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/features/vetcare/view/pet_merge_screen.dart';

import '../../../core/constant/global_function/custom_text_form_field.dart';
import '../../../core/constant/global_function/global_function.dart';
import '../../../core/thames/styles.dart';
import '../../../generated/l10n.dart';
import '../../authentication/view/widgets/authItem.dart';
import '../../layout/layout.dart';
import '../controller/vet_cubit.dart';

class VetCareRegister extends StatelessWidget {
  const VetCareRegister({
    super.key,
    required this.invitationCode,
  });
  final String invitationCode;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VetCubit()..getClient(invitationCode),
      child: BlocConsumer<VetCubit, VetState>(
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
            if (state.isHavePet) {
              navigateAndFinish(
                  context,
                  PetMergeScreen(
                      Code: VetCubit.get(context).vetClientModelOne!.clinicCode,
                      isNavigation: false));
            } else {
              navigateAndFinish(context, LayoutScreen());
            }
          }
          if (state is ErrorLoginState) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }
        },
        builder: (context, state) {
          var cubit = VetCubit.get(context);
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

  final VetCubit cubit;

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
              isArabic()
                  ? 'أكمل نموذج التسجيل دعوة vetIcare'
                  : 'Complete the register from vetIcare invitation',
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: 20,
            ),

            /// phone
            MyTextForm(
              controller: cubit.phoneController,
              prefixIcon: const Icon(
                IconlyBold.call,
                size: 14,
              ),
              enable: false,
              enabled: false,
              hintText: S.of(context).enterPhone,
              validatorText: S.of(context).enterUrEmail,
              obscureText: false,
            ),

            /// password
            SizedBox(
              height: 20,
            ),

            /// email
            if (cubit.emailController.text.isEmpty)
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
            if (cubit.emailController.text.isEmpty)
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

            /// Register
            SizedBox(
              height: 20,
            ),

            CustomElevatedButton(
              isLoading: cubit.isRegister,
              formKey: cubit.formKey,
              onPressed: () {
                cubit.register();
              },
              buttonText: S.of(context).register,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
