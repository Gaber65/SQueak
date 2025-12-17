import 'package:dio/dio.dart';

import '../../../../../core/service/service_locator/locatore_export_path.dart';

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
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
