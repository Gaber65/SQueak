import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';

String formatTimeToAmPm(String time) {
  if (time.isEmpty) return '';

  try {
    final parts = time.split(':');
    if (parts.length < 3) return '';

    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);

    // If there's a decimal in seconds, split
    final secondsPart = parts[2].split('.')[0];
    final seconds = int.parse(secondsPart);

    final utcDate = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, hours, minutes, seconds);
    final localDate = utcDate.toLocal();

    int hour = localDate.hour % 12;
    if (hour == 0) hour = 12;

    final formattedMinutes = localDate.minute.toString().padLeft(2, '0');
    final suffix = localDate.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$formattedMinutes $suffix';
  } catch (e) {
    // print('Error in formatTimeToAmPm: $e');
    return '';
  }
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
    final backendFormat = DateFormat(
      'EEE MMM dd yyyy HH:mm:ss \'GMT\'z',
      'en_US',
    );
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

String formatTimeToAmPmReminder(String time) {
  // print('time: $time');
  // print('time.trim().isEmpty: ${time.trim().isEmpty}');
  if (time.trim().isEmpty) return '';
  final parts = time.trim().split(':').map((e) => e.trim()).toList();
  if (parts.length < 2) return '';
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);

  var hour = hours % 12;
  if (hour == 0) hour = 12;

  final formattedMinutes = minutes.toString().padLeft(2, '0');
  final suffix = hours >= 12 ? 'PM' : 'AM';

  return '$hour:$formattedMinutes $suffix';
}

String formatBoarding(String createdAt) {
  // print("Input date string: $createdAt");

  try {
    // لو السيرفر بيرسل التوقيت كـ UTC بدون 'Z' في آخره
    // لازم نحلل التاريخ باعتباره في UTC manually
    DateTime utcTime = DateTime.parse(createdAt).toUtc();

    // نحوله للتوقيت المحلي
    DateTime localTime = utcTime.toLocal();

    // ننسق الناتج
    return DateFormat('MMM dd yyyy, hh:mm a', 'en_US').format(localTime);
  } catch (e) {
    // print('Error parsing date: $e');
    return createdAt;
  }
}

String convertLocalTimeToUTC(String time) {
  if (time.isEmpty) return '';

  try {
    final parts = time.split(':');
    if (parts.length < 2) return '';

    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = parts.length >= 3 ? int.parse(parts[2]) : 0;

    final now = DateTime.now();
    final localDate = DateTime(
      now.year,
      now.month,
      now.day,
      hours,
      minutes,
      seconds,
    );

    final utcDate = localDate.toUtc();

    final utcHours = utcDate.hour.toString().padLeft(2, '0');
    final utcMinutes = utcDate.minute.toString().padLeft(2, '0');
    final utcSeconds = utcDate.second.toString().padLeft(2, '0');

    return '$utcHours:$utcMinutes:$utcSeconds';
  } catch (e) {
    // print('Error in convertLocalTimeToUTC: $e');
    return '';
  }
}

String formatAge(dynamic birthDate, {bool isUser = false}) {
  // print(birthDate);
  // print('---------------');
  try {
    // تأكد إنه DateTime
    final date = (birthDate is DateTime)
        ? birthDate
        : DateTime.tryParse(birthDate.toString());

    if (date == null) {
      return isArabic() ? "تاريخ غير صالح" : "Invalid date";
    }

    final today = DateTime.now();

    int years = today.year - date.year;
    int months = today.month - date.month;
    int days = today.day - date.day;

    if (days < 0) {
      final prevMonth = DateTime(today.year, today.month, 0);
      days += prevMonth.day;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    final arabic = isArabic();
    final parts = <String>[];

    String pluralizeArabic(int value, String singular, String dual, String plural) {
      if (value == 1) return "$value $singular";
      if (value == 2) return dual;
      return "$value $plural";
    }

    if (years > 0) {
      if (arabic) {
        parts.add(pluralizeArabic(years, "سنة", "سنتين", "سنوات"));
      } else {
        parts.add("$years year${years > 1 ? 's' : ''}");
      }
    }

    if (months > 0) {
      if (arabic) {
        parts.add(pluralizeArabic(months, "شهر", "شهرين", "شهور"));
      } else {
        parts.add("$months month${months > 1 ? 's' : ''}");
      }
    }

    if (!isUser && years == 0 && months <= 2 && days > 0) {
      if (arabic) {
        parts.add(pluralizeArabic(days, "يوم", "يومين", "أيام"));
      } else {
        parts.add("$days day${days > 1 ? 's' : ''}");
      }
    }

    if (parts.isEmpty) {
      return arabic ? "0 أيام" : "0 days";
    }

    return arabic ? parts.join(" و ") : parts.join(", ");
  } catch (e) {
    return isArabic() ? "تاريخ غير صالح" : "Invalid date";
  }
}