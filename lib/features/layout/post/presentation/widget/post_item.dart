import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../../../../core/service/global_widget/image_detail.dart';
import '../../../../comments/presentation/screens/comment.dart';
import '../../domain/entities/post_entity.dart';

import 'get_post/post_header.dart';
import 'get_post/post_content.dart';
import 'get_post/media_carousel.dart';
import 'get_post/action_buttons.dart';
import 'get_post/video_fullscreen.dart';

class BuildPostItem extends StatefulWidget {
  const BuildPostItem({
    super.key,
    required this.postItem,
    this.petId,
    this.onShare,
    this.onMenuTap,
    this.onLike,
  });

  final PostEntity postItem;
  final String? petId;
  final VoidCallback? onShare;
  final VoidCallback? onMenuTap;
  final VoidCallback? onLike;

  @override
  State<BuildPostItem> createState() => _BuildPostItemState();
}

class _BuildPostItemState extends State<BuildPostItem> {
  final PageController _pageController = PageController();
  int _currentMediaIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MainCubit.get(context).isDark;
    final allMedia = _combineMedia();
    final hasMedia = allMedia.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: Decorations.kDecorationBoxShadow(context: context),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            postItem: widget.postItem,
            isDark: isDark,
            petId: widget.petId,
            onMenuTap: widget.onMenuTap,
          ),

          PostContent(content: widget.postItem.content!, isDark: isDark),

          if (hasMedia)
            MediaCarousel(
              media: allMedia,
              currentIndex: _currentMediaIndex,
              pageController: _pageController,
              onPageChanged: (index) {
                setState(() => _currentMediaIndex = index);
              },
              onImageTap: (imagePath) => _navigateToImageDetail(imagePath),
              onVideoTap: (videoPath) => _playVideoFullscreen(videoPath),
            ),

          const Divider(height: 1, thickness: 0.5),

          ActionButtons(
            postItm: widget.postItem,
            commentsCount: widget.postItem.numberOfComments ?? 0,
            isDark: isDark,
            postId: widget.postItem.postId!,
            petID: widget.petId,
            onComment: _navigateToComments,
          ),
        ],
      ),
    );
  }

  List<MediaItem> _combineMedia() {
    final allMedia = <MediaItem>[];

    if (widget.postItem.postSocialMedia != null) {
      for (var media in widget.postItem.postSocialMedia!) {
        if (media.imagePath?.isNotEmpty ?? false) {
          allMedia.add(
            MediaItem(
              type: MediaType.image,
              path: media.imagePath!,
              id: media.id,
              duration: '',
              thumbnail: '',
            ),
          );
        }

        if (media.videoPath?.isNotEmpty ?? false) {
          allMedia.add(
            MediaItem(
              duration: '',
              thumbnail: '',
              type: MediaType.video,
              path: media.videoPath!,
              id: media.id,
            ),
          );
        }
      }
    }

    return allMedia;
  }

  void _navigateToImageDetail(String imagePath) {
    navigateToScreen(
      context,
      ImageDetailSimple(
        path: imageUrl + imagePath,
        title: widget.postItem.title ?? '',
        description: widget.postItem.content ?? '',
      ),
    );
  }

  void _playVideoFullscreen(String videoPath) {
    navigateToScreen(
      context,
      VideoFullScreenPlayer(
        videoUrl: imageUrl + videoPath,
        title: widget.postItem.title ?? '',
      ),
    );
  }

  void _navigateToComments() {
    CacheHelper.saveData('isReplayCommentOpen', false);
    navigateToScreen(
      context,
      CommentScreen(postId: widget.postItem.postId!, petID: widget.petId ?? ''),
    );
  }
}
