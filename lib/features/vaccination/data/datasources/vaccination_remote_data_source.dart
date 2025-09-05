import 'package:dio/dio.dart';
import 'package:squeak/core/network/dio.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/network/end-points.dart';
import '../../../../core/network/error_message_model.dart';
import '../models/vaccination_model.dart';

abstract class VaccinationRemoteDataSource {
  Future<List<VaccinationNameModel>> getVaccinationNames();
}

class VaccinationRemoteDataSourceImpl implements VaccinationRemoteDataSource {
  VaccinationRemoteDataSourceImpl();

  @override
  Future<List<VaccinationNameModel>> getVaccinationNames() async {
    try {
      final response = await DioFinalHelper.getData(
        method: allVacEndPoint,
        language: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> vaccinationsJson =
            response.data['data']['_vaccinations'];
        return vaccinationsJson
            .map((json) => VaccinationNameModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          e.response?.data ??
              {
                'errors': {},
                'message': e.message ?? 'Network error occurred',
                'success': false,
                'statusCode': e.response?.statusCode ?? 500,
              },
        ),
      );
    }
  }
}
