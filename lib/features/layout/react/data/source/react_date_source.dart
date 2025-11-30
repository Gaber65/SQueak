import 'package:dio/dio.dart';
import 'package:squeak/core/network/dio.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error_message_model.dart';
import '../../domain/repo/base_react_repo.dart';
import '../models/react_model.dart';

abstract class ReactDataSource {
  Future<ReactionSummaryModel> getAllReactOnPost(String postId);
  Future<ReactionActionResultModel> reactOnPost(ReactParams params);
}

class ReactDataSourceImpl implements ReactDataSource {
  @override
  Future<ReactionSummaryModel> getAllReactOnPost(String postId) async {
    try {
      final result = await DioFinalHelper.getData(
        method: getReactEndPoint + postId,
      );
      return ReactionSummaryModel.fromJson(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<ReactionActionResultModel> reactOnPost(ReactParams params) async {
    try {
      final result = await DioFinalHelper.postData(
        method: getReactEndPoint,
        data: params.toJson(),
      );
      return ReactionActionResultModel.fromJson(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
