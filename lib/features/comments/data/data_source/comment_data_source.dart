import 'package:dio/dio.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/dio.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/error_message_model.dart';
import '../../domain/repository/base_comment_repository.dart';
import '../model/comment_model.dart';

abstract class BaseCommentRemoteDataSource {
  Future<CommentModel> createCommentDataSource(
    CreateCommentParameters parameters,
  );
  Future<CommentModel> updateCommentDataSource(
    CreateCommentParameters parameters,
  );
  Future<List<CommentModel>> getCommentDataSource(
    CreateCommentParameters parameters,
  );
  Future<CommentModel> deleteCommentDataSource(
    CreateCommentParameters parameters,
  );
}

class CommentRemoteDataSource extends BaseCommentRemoteDataSource {
  @override
  Future<CommentModel> createCommentDataSource(
    CreateCommentParameters parameters,
  ) async {
    try {
      var result = await DioFinalHelper.postData(
        method: createCommentEndPoint,
        requestId: 'comment',
        data: {
          "content": parameters.content,
          "image": parameters.image,
          "petId": parameters.petId,
          "postId": parameters.postId,
          "parentId": parameters.parentId,
        },
      );
      return CommentModel.fromJson(result.data['data']);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        final model = ErrorMessageModel(
          errors: {},
          message: e.response?.toString() ?? 'Request canceled',
          success: false,
          statusCode: 0,
        );
        throw ServerException(errorMessageModel: model);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
        );
      }
    }
  }

  @override
  Future<CommentModel> deleteCommentDataSource(
    CreateCommentParameters parameters,
  ) async {
    try {
      var result = await DioFinalHelper.deleteData(
        method: deleteCommentEndPoint + parameters.commentId!,
      );
      return CommentModel.fromJson(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<CommentModel> updateCommentDataSource(
    CreateCommentParameters parameters,
  ) async {
    try {
      var result = await DioFinalHelper.patchData(
        method: updateCommentEndPoint,
        data: {
          "content": parameters.content,
          "petId": parameters.petId,
          "postId": parameters.postId,
          "id": parameters.commentId,
          "parentId": parameters.parentId,
        },
      );
      return CommentModel.fromJson(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<CommentModel>> getCommentDataSource(
    CreateCommentParameters parameters,
  ) async {
    try {
      Response result = await DioFinalHelper.getData(
        method: getCommentEndPoint + parameters.postId!,
        language: true,
      );
      return (result.data['data']['result'] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      // print(e.response!.data);
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
