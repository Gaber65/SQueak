import 'package:dio/dio.dart';
import '../../../../../core/utils/export_path/export_files.dart';
import '../model/post_model.dart';

abstract class BasePostRemoteDataSource {
  Future<List<PostDataModel>> getPostDataSource(int allPostUserPageNumber);
}

class PostRemoteDataSource extends BasePostRemoteDataSource {
  @override
  Future<List<PostDataModel>> getPostDataSource(
    int allPostUserPageNumber,
  ) async {
    try {
      Response result = await DioFinalHelper.getData(
        method: getPostEndPoint(allPostUserPageNumber),
        language: true,
      );
      return (result.data['data']['result'] as List)
          .map((e) => PostDataModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      // print(e.response?.data);
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
