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
