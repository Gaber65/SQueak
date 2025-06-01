import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.cubit,
    required this.clinicCode,
  });

  final RegisterCubit cubit;
  final String clinicCode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final isLoading = RegisterCubit.get(context).isRegister;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: ColorManager.primaryColor,
              elevation: 2,
            ),
            onPressed: isLoading ? null : () => _handleRegister(context),
            child:
                isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(
                      S.of(context).register,
                      style: FontStyleThame.textStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        context: context,
                        fontColor: Colors.white,
                      ),
                    ),
          ),
        );
      },
    );
  }

  void _handleRegister(BuildContext context) {
    if (cubit.formKey.currentState!.validate()) {
      if (cubit.countryCode.isEmpty) {
        infoToast(
          context,
          isArabic()
              ? 'يرجى اختيار دولتك قبل متابعة التسجيل.'
              : 'Please select your country before proceeding with registration.',
        );
      } else {
        cubit.registerWithQr(clinicCode, context);
      }
    }
  }
}
