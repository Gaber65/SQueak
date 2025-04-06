import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/comments/view/comment.dart';

import '../../../models/post_model.dart';

class BuildPostItem extends StatelessWidget {
  const BuildPostItem({
    super.key,
    required this.postItem,
  });

  final Posts postItem; // postItem.clinicPost!s


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: Decorations.kDecorationBoxShadow(context: context),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // elevation: 5.0,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // head of post (ing + name + time)
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: MainCubit.get(context).isDark
                      ? Colors.black38
                      : Colors.white,
                  backgroundImage: FastCachedImageProvider(
                    imageUrl + postItem.clinicPost.image,
                  ),

                  // Use `Image.network` for better control over error handling
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postItem.clinicPost.name,
                        style: FontStyleThame.textStyle(
                          context: context,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          postItem.title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontSize: 14,
                                color: MainCubit.get(context).isDark ? Colors.white: Colors.grey,
                                height: 1.4,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              postItem.content,
              style: TextStyle(
                color: MainCubit.get(context).isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            if (postItem.image != null && postItem.image != '')
              Container(
                height: 250.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      "$imageUrl${postItem.image}",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            if (postItem.video != null && postItem.video != '')
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: VideoStringApp(
                  video: "$imageUrl${postItem.video}",
                ),
              ),
            if (postItem.image != null &&
                postItem.image !=
                    'http://squeak101-001-site1.itempurl.com/postImages')
              const SizedBox(
                height: 12,
              ),

            InkWell(
              onTap: () {
                CacheHelper.saveData('isReplayCommentOpen', false);

                navigateToScreen(
                    context,
                    CommentScreen(
                      postId: postItem.postId,
                      isAppBar: true,
                    ));
              },
              radius: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 20,
                  ),
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
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              formatFacebookTimePost(
                postItem.createdAt,
              ),
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

class BuildPostItemShimmer extends StatelessWidget {
  const BuildPostItemShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Decorations.kDecorationBoxShadow(context: context),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 22.0,
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          width: 120,
                          height: 10,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          width: 40,
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
                ),
                height: 170,
                width: double.infinity,
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: InkWell(
                        onTap: () {},
                        child: MyTextForm(
                          prefixIcon: const SizedBox(),
                          controller: TextEditingController(),
                          hintText: 'Write Your Comment',
                          enable: false,
                          obscureText: false,
                          enabled: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
