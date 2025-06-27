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


String extractQRIdFromUrl(String url) {
  final uri = Uri.parse(url);
  return uri.queryParameters['id'] ?? '';
}