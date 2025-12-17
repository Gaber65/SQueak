import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:squeak/features/layout/react/domain/entities/react_entities.dart';

import '../../../../../core/error/failure.dart';
import '../../presentation/animated_reaction/reaction_data.dart';

abstract class BaseReactRepo {
  Future<Either<Failure, ReactionSummary>> getAllReactOnPost(String postId);

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

enum ReactType {
  none(0),
  happy(1),
  sad(2),
  love(3),
  angry(4),
  like(5);

  final int value;
  const ReactType(this.value);

  static ReactType fromInt(int value) {
    return ReactType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ReactType.none,
    );
  }

  String get displayName {
    switch (this) {
      case ReactType.none:
        return 'None';
      case ReactType.happy:
        return 'Happy';
      case ReactType.sad:
        return 'Sad';
      case ReactType.love:
        return 'Love';
      case ReactType.angry:
        return 'Angry';
      case ReactType.like:
        return 'Like';
    }
  }

  Color get color {
    switch (this) {
      case ReactType.none:
        return Colors.grey;
      case ReactType.happy:
        return const Color(0xFFF7B928);
      case ReactType.sad:
        return const Color(0xFF1877F2);
      case ReactType.love:
        return const Color(0xFFF33E58);
      case ReactType.angry:
        return const Color(0xFFE9710F);
      case ReactType.like:
        return const Color(0xFF1877F2);
    }
  }

  String get iconPath {
    switch (this) {
      case ReactType.none:
        return '';
      case ReactType.happy:
        return ReactionData.facebookReactionIcon[2];
      case ReactType.sad:
        return ReactionData.facebookReactionIcon[3];
      case ReactType.love:
        return ReactionData.facebookReactionIcon[1];
      case ReactType.angry:
        return ReactionData.facebookReactionIcon[4];
      case ReactType.like:
        return ReactionData.facebookReactionIcon[0];
    }
  }
}
