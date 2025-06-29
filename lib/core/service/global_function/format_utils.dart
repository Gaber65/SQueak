import 'package:intl/intl.dart';


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

String extractAllIdsFromUrl(String url) {
  // استخدم regex لاستخراج كل شكل UUID
  final regex = RegExp(
    r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}',
    caseSensitive: false,
  );

  return regex.allMatches(url).map((m) => m.group(0)!).toList().first;
}