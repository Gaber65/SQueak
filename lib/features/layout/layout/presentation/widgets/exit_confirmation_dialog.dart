// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:squeak/core/utils/export_path/export_files.dart';
//
// Completer<bool> completer = Completer<bool>();
//
// Future<bool> showExitConfirmationDialog(BuildContext context) async {
//   // Use Completer to return a value asynchronously.
//   completer = Completer<bool>();
//   QuickAlert.show(
//     context: context,
//     type: QuickAlertType.confirm,
//     backgroundColor:
//         MainCubit.get(context).isDark
//             ? ColorManager.myPetsBaseBlackColor
//             : Colors.white,
//     textColor: MainCubit.get(context).isDark ? Colors.white : Colors.black,
//     titleColor: MainCubit.get(context).isDark ? Colors.white : Colors.black,
//     title: isArabic() ? 'إغلاق التطبيق' : 'Close App',
//     cancelBtnText: isArabic() ? 'لا' : 'No',
//     confirmBtnText: isArabic() ? 'نعم' : 'Yes',
//     text:
//         isArabic()
//             ? 'هل أنت متأكد من إغلاق التطبيق؟'
//             : 'Are you sure you want to close the app?',
//     showCancelBtn: true,
//     onCancelBtnTap: () {
//       Navigator.of(context).pop(); // Close the alert.
//       completer.complete(false); // User canceled.
//     },
//     onConfirmBtnTap: () {
//       Navigator.of(context).pop(); // Close the dialog
//       // Exit the app on confirmation
//       if (Platform.isAndroid) {
//         SystemNavigator.pop(); // Exit app on Android
//       } else if (Platform.isIOS) {
//         exit(0); // Force exit on iOS (use with caution)
//       }
//       completer.complete(true);
//     },
//   );
//
//   return completer.future; // Wait for the user's decision.
// }
