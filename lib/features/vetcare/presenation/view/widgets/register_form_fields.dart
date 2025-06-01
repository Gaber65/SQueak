import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';

class RegisterFormFields extends StatelessWidget {
  const RegisterFormFields({super.key, required this.cubit});

  final RegisterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNameField(context),
        const SizedBox(height: 16),
        _buildEmailField(context),
        const SizedBox(height: 16),
        _buildPhoneField(),
        const SizedBox(height: 16),
        _buildPasswordField(context),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return MyTextForm(
      controller: cubit.nameController,
      prefixIcon: const Icon(Icons.person, size: 20),
      enable: false,
      hintText: S.of(context).enterName,
      validatorText: S.of(context).enterName,
      obscureText: false,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return MyTextForm(
      controller: cubit.emailController,
      prefixIcon: const Icon(Icons.email_outlined, size: 20),
      enable: false,
      hintText: S.of(context).enterUrEmail,
      validatorText: S.of(context).enterUrEmail,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneField() {
    return PhoneTextField(
      controller: cubit.phoneController,
      countries: cubit.countries,
      registerCubit: cubit,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return MyTextForm(
      controller: cubit.passwordController,
      prefixIcon: const Icon(Icons.lock_outline, size: 20),
      enable: true,
      hintText: S.of(context).enterUrPassword,
      validatorText: S.of(context).enterUrPassword,
      obscureText: true,
    );
  }
}
