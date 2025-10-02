import 'package:flutter/material.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../../../../core/service/global_widget/ImageDetail.dart';
import '../../../../comments/presentation/screens/comment.dart';
import '../../domain/entities/post_entity.dart';

class BuildPostItem extends StatelessWidget {
  const BuildPostItem({super.key, required this.postItem});

  final PostEntity postItem;

  @override
  Widget build(BuildContext context) {
    final isDark = MainCubit.get(context).isDark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: Decorations.kDecorationBoxShadow(context: context),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: isDark ? Colors.black38 : Colors.white,
                  backgroundImage: FastCachedImageProvider(
                    imageUrl + postItem.clinic.image,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postItem.clinic.name,
                        style: FontStyleThame.textStyle(context: context),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          postItem.title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            color: subTextColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              postItem.content,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 12),

            // Post image
            if (postItem.image != null && postItem.image!.isNotEmpty)
              InkWell(
                onTap: () {
                  navigateToScreen(
                    context,
                    ImageDetailSimple(
                      path:
                       imageUrl + postItem.image!,
                      title:
                      postItem.title,
                      description: postItem.content,
                    ),
                  );
                },
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl + postItem.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

            // Post video
            if (postItem.video != null && postItem.video!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: VideoStringApp(video: imageUrl + postItem.video!),
                ),
              ),

            if (postItem.image != null || postItem.video != null)
              const SizedBox(height: 12),

            // Comments button
            InkWell(
              onTap: () {
                CacheHelper.saveData('isReplayCommentOpen', false);
                navigateToScreen(
                  context,
                  CommentScreen(postId: postItem.postId),
                );
              },
              radius: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 20),
                  Text(
                    '${postItem.numberOfComments} ${isArabic() ? 'تعليقات' : 'Comments'}',
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 12),

            // Post time
            Text(
              formatFacebookTimePost(postItem.createdAt),
              style: FontStyleThame.textStyle(
                context: context,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
