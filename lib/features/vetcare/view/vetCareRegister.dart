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
import '../../authentication/models/login.dart';
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
      child: _VetCareRegisterContent(),
    );
  }
}

class _VetCareRegisterContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VetCubit, VetState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        final cubit = VetCubit.get(context);
        return AuthItem(
          widget: RegisterView(cubit: cubit),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, VetState state) {
    if (state is ErrorRegisterState) {
      _showErrorToast(context, state);
    }
    if (state is SuccessLoginState) {
      _handleLoginSuccess(context, state);
    }
    if (state is ErrorLoginState) {
      _showLoginErrorToast(context, state);
    }
  }

  void _showErrorToast(BuildContext context, ErrorRegisterState state) {
    errorToast(
      context,
      state.error.errors.isNotEmpty
          ? state.error.errors.values.first.first
          : state.error.message,
    );
  }

  void _handleLoginSuccess(BuildContext context, SuccessLoginState state) {
    _saveUserData(state.userModel);
    _navigateAfterLogin(context, state);
  }

  void _saveUserData(AuthModel userModel) {
    CacheHelper.saveData('token', userModel.data!.token);
    CacheHelper.saveData('role', userModel.data!.role);
    CacheHelper.saveData('clintId', userModel.data!.id);
    CacheHelper.saveData('refreshToken', userModel.data!.refreshToken);
    CacheHelper.saveData('phone', userModel.data!.phone);
    CacheHelper.saveData('name', userModel.data!.fullName);
    CacheHelper.saveData('clientName', userModel.data!.fullName);
  }

  void _navigateAfterLogin(BuildContext context, SuccessLoginState state) {
    final nextScreen = state.isHavePet
        ? PetMergeScreen(
      Code: VetCubit.get(context).vetClientModelOne!.clinicCode,
      isNavigation: false,
    )
        : LayoutScreen();
    navigateAndFinish(context, nextScreen);
  }

  void _showLoginErrorToast(BuildContext context, ErrorLoginState state) {
    errorToast(
      context,
      state.error.errors.isNotEmpty
          ? state.error.errors.values.first.first
          : state.error.message,
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
            _buildTitle(context),
            const SizedBox(height: 20),
            _buildPhoneField(context),
            const SizedBox(height: 20),
            _buildEmailFieldIfNeeded(context),
            if (cubit.emailController.text.isEmpty) const SizedBox(height: 20),
            _buildPasswordField(context),
            const SizedBox(height: 20),
            _buildRegisterButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      S.of(context).compeleteSqueakRegister,
      style: FontStyleThame.textStyle(
        context: context,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPhoneField(context) {
    return MyTextForm(
      controller: cubit.phoneController,
      prefixIcon: const Icon(IconlyBold.call, size: 14),
      enable: false,
      enabled: false,
      hintText: S.of(context).enterPhone,
      validatorText: S.of(context).enterUrEmail,
      obscureText: false,
    );
  }

  Widget _buildEmailFieldIfNeeded(context) {
    if (cubit.emailController.text.isEmpty) {
      return MyTextForm(
        controller: cubit.emailController,
        prefixIcon: const Icon(Icons.alternate_email_sharp, size: 14),
        enable: false,
        hintText: S.of(context).enterUrEmail,
        validatorText: S.of(context).enterUrEmail,
        obscureText: false,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildPasswordField(context) {
    return MyTextForm(
      controller: cubit.passwordController,
      prefixIcon: const Icon(Icons.lock, size: 14),
      enable: true,
      hintText: S.of(context).enterUrPassword,
      validatorText: S.of(context).enterUrPassword,
      obscureText: false,
    );
  }

  Widget _buildRegisterButton(context) {
    return CustomElevatedButton(
      isLoading: cubit.isRegister,
      formKey: cubit.formKey,
      onPressed: () => cubit.register(),
      buttonText: S.of(context).register,
    );
  }
}