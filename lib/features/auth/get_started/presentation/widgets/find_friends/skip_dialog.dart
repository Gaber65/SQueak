import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

class SkipDialog extends StatelessWidget {
  const SkipDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor:
          isDark ? ColorManager.editScreenTextFieldBaseColor : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        "Are you sure you want to skip finding friends?",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color:
              isDark
                  ? ColorManager.editScreenBaseFontColor
                  : ColorManager.black87,
        ),
      ),
      content: Text(
        "You can always connect later.",
        style: TextStyle(
          fontSize: 14,
          color:
              isDark
                  ? ColorManager.editScreenBaseFontColor
                  : ColorManager.black87,
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
            child:  Text(
              "OK",
              style: TextStyle(
                color:
                    isDark
                        ? ColorManager.editScreenBaseFontColor
                        : ColorManager.black87,
              ),
            ),
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
            child: Text(
              "Cancel",
              style: TextStyle(
                color:
                    isDark
                        ? ColorManager.editScreenBaseFontColor
                        : ColorManager.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
