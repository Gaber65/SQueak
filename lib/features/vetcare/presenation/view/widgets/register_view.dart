import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';

import 'welcome_card.dart';
import 'register_form_fields.dart';
import 'consent_checkbox.dart';
import 'register_button.dart';

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
  final RegisterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: cubit.formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeCard(clinicName: clinicName),
            const SizedBox(height: 24),
            RegisterFormFields(cubit: cubit),
            const SizedBox(height: 20),
            ConsentCheckbox(
              cubit: cubit,
              clinicName: clinicName,
            ),
            const SizedBox(height: 24),
            RegisterButton(
              cubit: cubit,
              clinicCode: clinicCode,
            ),
          ],
        ),
      ),
    );
  }
}