import 'package:flutter/material.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';

class AddPetTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool readOnly;
  final Widget? suffix;
  final VoidCallback? onTap;

  const AddPetTextField({
    super.key,
    required this.hint,
    this.controller,
    this.readOnly = false,
    this.suffix,
    this.onTap,
   
  });

  @override
  Widget build(BuildContext context) {
    // If a controller is provided, listen to its value and update text color
    // to black when non-empty. Otherwise default to black text color.
    if (controller != null) {
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller!,
        builder: (context, value, child) {
          final hasText = value.text.trim().isNotEmpty;
          return TextField(
            key: key,
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            // Show black text once the user has typed; use a slightly dim color when empty
            style: TextStyle(color: hasText ? Colors.black : Colors.black54),
            decoration: InputDecoration(
              fillColor: ColorManager.white,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              suffixIcon: suffix,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: ColorManager.primaryColor.withOpacity(.7),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          );
        },
      );
    }

    return TextField(
      key: key,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: ColorManager.white,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: ColorManager.primaryColor.withOpacity(.7),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}