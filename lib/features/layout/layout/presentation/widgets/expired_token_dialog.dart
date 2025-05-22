import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../../auth/login/presentation/pages/login_screen.dart';

Future<dynamic> showExpiredTokenDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  isArabic() ? 'انتهت صلاحية الجلسة' : 'Session Expired',
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontColor: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    CacheHelper.clearData();
                    navigateAndFinish(context, const LoginScreen());
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.red.shade400,
                    size: 50,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic()
                            ? 'انتهت صلاحية الجلسة'
                            : 'Your session has expired',
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        isArabic()
                            ? 'سيتم تحويلك لصفحة تسجيل الدخول'
                            : 'You will be redirected to login page',
                        maxLines: 2,
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 100,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      CacheHelper.clearData();
                      navigateAndFinish(context, const LoginScreen());
                    },
                    child: Text(isArabic() ? "موافق" : "OK"),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
