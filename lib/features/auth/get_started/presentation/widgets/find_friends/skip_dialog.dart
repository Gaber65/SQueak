import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

class SkipDialog extends StatelessWidget {
  const SkipDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorManager.editScreenTextFieldBaseColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Text(
        "Are you sure you want to skip finding friends?",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ColorManager.editScreenBaseFontColor,
        ),
      ),
      content: const Text(
        "You can always connect later.",
        style: TextStyle(
          fontSize: 14,
          color: ColorManager.editScreenBaseFontColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            navigateToScreen(context, LayoutScreen());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: ColorManager.bTwitter,
            ),
            child: const Text("OK", style: TextStyle(color: Colors.black)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: ColorManager.followersShadowLightColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(color: ColorManager.editScreenBaseFontColor),
            ),
          ),
        ),
      ],
    );
  }
}
