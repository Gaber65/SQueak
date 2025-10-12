import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../auth/login/domin/entities/login_entity.dart';
import '../../../auth/register/presentation/widgets/auth_item.dart';
import '../controllers/vet_register/vet_register_cubit.dart';
import 'pet_merge_screen.dart';

class VetCareRegister extends StatelessWidget {
  const VetCareRegister({super.key, required this.invitationCode});
  final String invitationCode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VetRegisterCubit>()..getClient(invitationCode),
      child: _VetCareRegisterContent(),
    );
  }
}

class _VetCareRegisterContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VetRegisterCubit, VetRegisterState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        final cubit = VetRegisterCubit.get(context);
        return AuthItem(widget: RegisterView(cubit: cubit));
      },
    );
  }

  void _handleStateChanges(BuildContext context, VetRegisterState state) {
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
    errorToast(context, extractFirstErrorAuth(state.error));
  }

  void _handleLoginSuccess(BuildContext context, SuccessLoginState state) {
    _saveUserData(state.authModel);
    _navigateAfterLogin(context, state);
  }

  void _saveUserData(LoginEntity userModel) {
    CacheHelper.saveData('token', userModel.token);
    CacheHelper.saveData('role', userModel.role);
    CacheHelper.saveData('clintId', userModel.id);
    CacheHelper.saveData('refreshToken', userModel.refreshToken);
    CacheHelper.saveData('phone', userModel.phone);
    CacheHelper.saveData('name', userModel.fullName);
    CacheHelper.saveData('clientName', userModel.fullName);
    CacheHelper.saveData('expiry', userModel.expiresIn.toIso8601String());
    sub?.cancel();
  }

  void _navigateAfterLogin(BuildContext context, SuccessLoginState state) {
    final cubit = VetRegisterCubit.get(context);
    final nextScreen =
        state.isHavePet
            ? PetMergeScreen(
              code: cubit.vetClientModelOne?.clinicCode ?? '',
              isNavigation: false,
            )
            : LayoutScreen();
    navigateAndFinish(context, nextScreen);
  }

  void _showLoginErrorToast(BuildContext context, ErrorLoginState state) {
    errorToast(
      context,
      state.error is Map &&
              state.error['errors'] != null &&
              state.error['errors'].isNotEmpty
          ? state.error['errors'].values.first.first
          : state.error.toString(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key, required this.cubit});

  final VetRegisterCubit cubit;

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
