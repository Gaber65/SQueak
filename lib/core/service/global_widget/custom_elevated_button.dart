import 'package:flutter/material.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  final bool isLoading;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressed;
  final String buttonText;

  const CustomElevatedButton({
    super.key,
    required this.isLoading,
    required this.formKey,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: ColorManager.primaryColor,
        ),
        onPressed: isLoading
            ? null
            : () {
                if (formKey.currentState!.validate()) {
                  onPressed();
                }
              },
        child: isLoading ? CircularProgressIndicator() : Text(buttonText),
      ),
    );
  }
}
