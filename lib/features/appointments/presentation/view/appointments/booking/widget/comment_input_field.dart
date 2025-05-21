import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSubmit;

  const CommentInputField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: FontStyleThame.textStyle(
        context: context,
        fontSize: 15,
      ),
      maxLines: 1,
      decoration: InputDecoration(
        hintText: S.of(context).addComment,
        contentPadding: EdgeInsetsDirectional.only(start: 10),
        counterStyle: FontStyleThame.textStyle(
          context: context,
          fontSize: 13,
        ),
        hintStyle: FontStyleThame.textStyle(
          context: context,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontColor: MainCubit.get(context).isDark
              ? Colors.white54
              : Colors.black54,
        ),
        suffixIcon: IconButton(
          onPressed: isLoading ? null : onSubmit,
          icon: isLoading
              ? const CircularProgressIndicator()
              : const Icon(IconlyLight.send),
        ),
        filled: true,
        fillColor: MainCubit.get(context).isDark
            ? ColorManager.myPetsBaseBlackColor
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
    );
  }
}