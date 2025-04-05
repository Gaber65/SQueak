import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';



String formatTimeToAmPm(String time) {
  if (time.isEmpty) return '';

  final parts = time.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final seconds = int.parse(parts[2].substring(0, 1));

  final utcDate = DateTime.utc(0, 1, 1, hours, minutes, seconds);
  final localDate = utcDate.toLocal();

  final localHours = localDate.hour;
  final formattedMinutes = localDate.minute.toString().padLeft(2, '0');
  final suffix = localHours >= 12 ? 'PM' : 'AM';

  var hour = localHours % 12;
  if (hour == 0) hour = 12;

  return '$hour:$formattedMinutes $suffix';
}

String formatDateString(String dateString) {
  final date = DateTime.parse(dateString);
  return DateFormat('yyyy MMMM d', 'en_US').format(date);
}

String formatDateStringAndTime(String dateString) {
  final date = DateTime.parse(dateString);
  return DateFormat('EEE , MMM dd yyyy , hh:mm a', 'en_US').format(date);
}

String formatDate(String dateString) {
  final date = DateTime.parse(dateString);
  return DateFormat('EEE , MMM dd yyyy , hh:mm a', 'en_US').format(date);
}

String formatFacebookTimePost(String createdAt) {
  try {
    final backendFormat = DateFormat('EEE MMM dd yyyy HH:mm:ss \'GMT\'z', 'en_US');
    final utcTime = backendFormat.parse(createdAt, true);
    final localTime = utcTime.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localTime);

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
          : DateFormat('EEEE \'at\' h:mm a').format(localTime);
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
  debugPrint("Input date string: $createdAt");

  final backendFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss", 'en_US');
  final utcTime = backendFormat.parse(createdAt, true);
  final localTime = utcTime.toLocal();

  return DateFormat('EEE, MMM dd yyyy, hh:mm a', 'en_US').format(localTime);
}
