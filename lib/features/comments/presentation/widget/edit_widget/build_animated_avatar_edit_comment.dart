// EditCommentAvatar
import 'package:flutter/material.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../../domain/entities/comment_entity.dart';

Widget buildEditCommentAvatar(
  CommentEntity comment,
  avatarAnimation,
  animationController,
) {
  final imageUrlString =
      comment.pet == null
          ? (comment.user!.imageName != null &&
                  comment.user!.imageName!.isNotEmpty)
              ? "$imageUrl${comment.user!.imageName}"
              : AssetImageModel.defaultUserImage
          : (comment.pet!.imageName != null &&
              comment.pet!.imageName!.isNotEmpty)
          ? "$imageUrl${comment.pet!.imageName}"
          : AssetImageModel.defaultPetImage;

  return FadeTransition(
    opacity: avatarAnimation,
    child: ScaleTransition(
      scale: avatarAnimation,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[400]!, Colors.purple[500]!],
          ),
        ),
        child: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(imageUrlString),
        ),
      ),
    ),
  );
}
