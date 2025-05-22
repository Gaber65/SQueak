import 'package:squeak/core/network/dio.dart';

import '../../../../../core/network/end-points.dart';

class ContactUsRemoteDataSource {
  ContactUsRemoteDataSource();

  Future<void> contactUs({
    required String title,
    required String phone,
    required String fullName,
    required String comment,
    required String email,
  }) async {
    try {
      await DioFinalHelper.postData(
        method: contactUsEndPoint,
        data: {
          "title": title,
          "phone": phone,
          "fullName": fullName,
          "comment": comment,
          "email": email,
          "statues": false,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
