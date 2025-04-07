import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helper/build_service/main_cubit/main_cubit.dart';
import '../../thames/color_manager.dart';
import '../../thames/styles.dart';

String formatTimeToAmPm(String time) {
  if (time.isNotEmpty) {
    // Split the time string into hours, minutes, and seconds
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2].substring(0, 1));

    // Create a DateTime object with the provided time in UTC
    DateTime utcDate = DateTime.utc(0, 1, 1, hours, minutes, seconds);

    // Increase the time by 1 hour
    DateTime updatedDate = utcDate;

    // Convert the updated time to local time
    DateTime localDate = updatedDate.toLocal();

    // Get the local hours and minutes
    int localHours = localDate.hour;
    int localMinutes = localDate.minute;

    // Determine the AM/PM suffix
    String suffix = localHours >= 12 ? 'PM' : 'AM';

    // Adjust the hours for 12-hour format
    int hour = localHours % 12;
    if (hour == 0) {
      hour = 12;
    }

    // Format the minutes to always have two digits
    String formattedMinutes = localMinutes.toString().padLeft(2, '0');

    return '$hour:$formattedMinutes $suffix';
  }

  return '';
}

String formatDateString(String dateString) {
  DateTime date = DateTime.parse(dateString);
  final DateFormat formatter = DateFormat('yyyy MMMM d', 'en_US');
  return formatter.format(date);
}

String formatDateStringAndTime(String dateString) {
  DateTime date = DateTime.parse(dateString);
  final DateFormat formatter =
      DateFormat('EEE , MMM dd yyyy , hh:mm a', 'en_US');
  return formatter.format(date);
}

String formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  DateFormat formatter = DateFormat('EEE , MMM dd yyyy , hh:mm a', 'en_US');
  return formatter.format(date);
}

String formatFacebookTimePost(String createdAt) {
  try {
    DateFormat backendFormat =
        DateFormat('EEE MMM dd yyyy HH:mm:ss \'GMT\'z', 'en_US');

    DateTime utcTime = backendFormat.parse(createdAt, true);

    DateTime localTime = utcTime.toLocal();

    DateTime now = DateTime.now();

    Duration difference = now.difference(localTime);

    if (difference.inSeconds < 60) {
      return isArabic() ? 'الآن' : 'Just now';
    } else if (difference.inMinutes < 60) {
      return isArabic()
          ? 'منذ ${difference.inMinutes} دقيقة'
          : '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return isArabic()
          ? 'منذ ${difference.inHours} ساعة'
          : '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return isArabic()
          ? 'أمس في ${DateFormat('h:mm a', 'ar').format(localTime)}'
          : 'Yesterday at ${DateFormat('h:mm a').format(localTime)}';
    } else if (difference.inDays < 7) {
      return isArabic()
          ? '${DateFormat('EEEE', 'ar').format(localTime)} في ${DateFormat('h:mm a', 'ar').format(localTime)}'
          : '${DateFormat('EEEE \'at\' h:mm a').format(localTime)}';
    } else {
      return isArabic()
          ? '${DateFormat('MMM d', 'ar').format(localTime)} في ${DateFormat('h:mm a', 'ar').format(localTime)}'
          : DateFormat('MMM d \'at\' h:mm a').format(localTime);
    }
  } catch (e) {
    return 'Invalid date';
  }
}

String formatBILL(String createdAt) {
  print("Input date string: $createdAt");

  // Define the expected format based on actual date string
  DateFormat backendFormat =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss", 'en_US'); // Adjust as needed

  DateTime utcTime = backendFormat.parse(createdAt, true);

  DateTime localTime = utcTime.toLocal();

  return DateFormat('EEE, MMM dd yyyy, hh:mm a', 'en_US').format(localTime);
}

String normalizePhoneNumber(String phoneNumber) {
  if (phoneNumber.startsWith('0')) {
    return phoneNumber.substring(1);
  }
  return phoneNumber;
}

bool isEmail(String input) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(input);
}

bool isArabic() {
  return Intl.getCurrentLocale() == 'ar';
}

class CustomElevatedButton extends StatelessWidget {
  final bool isLoading;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressed;
  final String buttonText;

  const CustomElevatedButton({
    Key? key,
    required this.isLoading,
    required this.formKey,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

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
          backgroundColor: ColorTheme.primaryColor,
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

void showCustomConfirmationDialog({
  required BuildContext context,
  required dynamic description,
  required String imageUrl,
  required VoidCallback onConfirm,

  ///TODO : Mohamed Elkerm -> make the title of the alert more reuse

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
                  fontColor: MainCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                ),
              )
            else
              description,
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
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
                backgroundColor: MainCubit.get(context).isDark
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
                  fontColor: MainCubit.get(context).isDark
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
                backgroundColor: MainCubit.get(context).isDark
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
                  fontColor: MainCubit.get(context).isDark
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

Map<String, String?> extractQueryParams(String url) {
  String? queryStart;

  if (url.contains('/vetRegister/')) {
    queryStart = '/vetRegister/';
  } else if (url.contains('/QrRegister/')) {
    queryStart = '/QrRegister/';
  }

  if (queryStart == null) {
    return {};
  }

  final startIndex = url.indexOf(queryStart);
  final queryString = url.substring(startIndex + queryStart.length);

  final pairs = queryString.split('&');
  final params = <String, String>{};

  for (var pair in pairs) {
    final keyValue = pair.split('=');

    if (keyValue.length == 2) {
      final key = Uri.decodeComponent(keyValue[0]);
      final value = Uri.decodeComponent(keyValue[1]);
      params[key] = value;
    }
  }

  final result = {
    'qrClinicCode': params['qrClinicCode'],
    'clinicName': params['clinicName'],
    'clinicLogo': params['clinicLogo'],
  };

  return result;
}
