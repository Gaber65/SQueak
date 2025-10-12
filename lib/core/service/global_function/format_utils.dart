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

String? extractFirstUuidFromUrl(String url) {
  try {
    final regex = RegExp(
      r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}',
      caseSensitive: false,
    );

    final matches = regex.allMatches(url);
    if (matches.isNotEmpty) {
      return matches.first.group(0);
    } else {
      // URL صحيح لكن مفيهوش UUID
      return null;
    }
  } catch (e) {
    // لو حصل أي استثناء (مثلاً null أو غير متوقع)
    // print('Error extracting UUID from URL: $e');
    return null;
  }
}