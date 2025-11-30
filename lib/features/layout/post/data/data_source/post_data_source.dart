import 'package:dio/dio.dart';
import '../../../../../core/utils/export_path/export_files.dart';
import '../../domain/repository/base_post_repository.dart';
import '../model/post_model.dart';

abstract class BasePostRemoteDataSource {
  Future<List<PostDataModel>> getPostDataSource(GetPostParams params);

  Future<PostDataModel> createPostDataSource(CreatePostParams params);
}

class PostRemoteDataSource extends BasePostRemoteDataSource {
  @override
  Future<List<PostDataModel>> getPostDataSource(GetPostParams params) async {
    try {
      Response result = await DioFinalHelper.getData(
        method: getPostEndPoint(params),
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

  @override
  Future<PostDataModel> createPostDataSource(CreatePostParams params) async {
    try {
      Response result = await DioFinalHelper.postData(
        method: createPostEndPointText,
        data: params.toJson(),
      );
      return PostDataModel.fromJson(result.data['data']);
    } on DioException catch (e) {
      print(e.response?.data);
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
