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
    return TextField(
      key: key,
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: ColorManager.followersShadowLightColor,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
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