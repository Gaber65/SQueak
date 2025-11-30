import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../entities/post_entity.dart';

abstract class BasePostRepository {
  Future<Either<Failure, List<PostEntity>>> getAllUserPosts(
    GetPostParams params,
  );
  Future<Either<Failure, PostEntity>> createPost(CreatePostParams params);
}

class GetPostParams {
  final int allPostUserPageNumber;
  final bool isPet;
  final String petId;

  GetPostParams({
    required this.allPostUserPageNumber,
    required this.isPet,
    required this.petId,
  });
}

class CreatePostParams {
  final String title;
  final String content;
  final List<Map<String, dynamic>> postSocailMedias;
  final String petId;

  CreatePostParams({
    required this.title,
    required this.content,
    required this.petId,
    required this.postSocailMedias,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'postSocailMedias': postSocailMedias,

      'petId': petId,
    };
  }

}
