import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';



class EmailOrPhoneField extends StatelessWidget {
  final TextEditingController controller;

  const EmailOrPhoneField({
    super.key,
    required this.controller,
  });

  String? _validateInput(String? value, context) {
    // Trim leading/trailing whitespace before validation
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return S.of(context).enterUrEmailOPhone;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (emailRegex.hasMatch(value)) {
      return null; // Valid email
    }

    // Validate phone number format (for example, 10 digits)
    // Validate phone number format (accept any length of digits)
    final phoneRegex = RegExp(r'^\d+$');
    if (phoneRegex.hasMatch(value)) {
      return null; // Valid phone number
    }

    return S.of(context).enterUrEmailOPhoneValid;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: FontStyleThame.textStyle(
        context: context,
        fontSize: 15,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: S.of(context).enterUrEmailORPhone,

        contentPadding: EdgeInsets.all(0),
        hintStyle: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontColor: MainCubit.get(context).isDark
                ? Colors.white54
                : Color.fromRGBO(0, 0, 0, .3)),
        prefixIcon: const Icon(
          Icons.alternate_email_sharp,
          size: 14,
        ),
        filled: true,
        fillColor: MainCubit.get(context).isDark
            ? Colors.black26
            : Colors.grey.shade200,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusColor: Colors.grey.shade200,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardAppearance:
          MainCubit.get(context).isDark ? Brightness.dark : Brightness.light,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => _validateInput(value, context),
    );
  }
}
