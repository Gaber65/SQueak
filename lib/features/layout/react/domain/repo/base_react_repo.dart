import 'package:dartz/dartz.dart';
import 'package:squeak/features/layout/react/domain/entities/react_entities.dart';

import '../../../../../core/error/failure.dart';

abstract class BaseReactRepo {
  Future<Either<Failure, ReactionSummary>> getAllReactOnPost(
    String postId,
  );

  Future<Either<Failure, ReactionActionResult>> reactOnPost(ReactParams params);
}

class ReactParams {
  final String postId;
  int reactType;
  final String? petId;

  ReactParams({
    required this.postId,
    required this.petId,
    required this.reactType,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'petId': petId!.isEmpty ? null : petId,
      'reactType': reactType,
    };
  }
}

enum ReactType { none, happy, sad, love, angry, like }
