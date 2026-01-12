// ignore_for_file: deprecated_member_use

import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';

import '../../utils/theme/color_mangment/color_manager.dart';
import '../../utils/theme/fonts/font_styles.dart';
import '../global_function/format_utils.dart';

void showCustomConfirmationDialog({
  required BuildContext context,
  required dynamic description,
  required String imageUrl,
  required VoidCallback onConfirm,

  String titleOfAlertAR = 'تأكيد الحذف',
  String titleOfAlertEN = 'Delete Confirmation',
  Color yesButtonColor = Colors.red,
  Color noButtonColor = Colors.green,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          isArabic() ? titleOfAlertAR : titleOfAlertEN,
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontColor:
                MainCubit.get(context).isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (description is String)
              Text(
                description,
                style: FontStyleThame.textStyle(
                  context: context,
                  fontSize: 14,
                  fontColor:
                      MainCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                ),
              )
            else
              description,
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: SafeFastCachedImageProviderExtension.safe(
                imageUrl,
              ),
              radius: 60,
            ),
          ],
        ),
        actions: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: noButtonColor,
                backgroundColor:
                    MainCubit.get(context).isDark
                        ? ColorManager.myPetsBaseBlackColor
                        : noButtonColor.withOpacity(.4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                isArabic() ? 'لا' : 'No',
                style: FontStyleThame.textStyle(
                  context: context,
                  fontSize: 14,
                  fontColor:
                      MainCubit.get(context).isDark
                          ? noButtonColor
                          : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                foregroundColor: yesButtonColor,
                backgroundColor:
                    MainCubit.get(context).isDark
                        ? ColorManager.myPetsBaseBlackColor
                        : yesButtonColor.withOpacity(.4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                isArabic() ? 'نعم' : 'Yes',
                style: FontStyleThame.textStyle(
                  context: context,
                  fontSize: 14,
                  fontColor:
                      MainCubit.get(context).isDark
                          ? yesButtonColor
                          : Colors.black,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
