import 'package:flutter/material.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/react/presentation/screens/reaction_button_widget.dart';
import '../../../../../core/service/global_widget/image_detail.dart';
import '../../../../comments/presentation/screens/comment.dart';
import '../../domain/entities/post_entity.dart';

/// Professional Facebook-like post component with media carousel
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
          // Header Section
          _PostHeader(
            postItem: widget.postItem,
            isDark: isDark,
            petId: widget.petId,
            onMenuTap: widget.onMenuTap,
          ),

          _PostContent(content: widget.postItem.content!, isDark: isDark),

          // Media Section
          if (hasMedia)
            _MediaCarousel(
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

          // Action Buttons
          _ActionButtons(
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

  /// Combine images and videos - FIXED VERSION
  /// Treats imagePath and videoPath as separate media items
  List<MediaItem> _combineMedia() {
    final allMedia = <MediaItem>[];

    if (widget.postItem.postSocialMedia != null) {
      for (var media in widget.postItem.postSocialMedia!) {
        // Add image as separate media item if exists
        if (media.imagePath?.isNotEmpty ?? false) {
          allMedia.add(
            MediaItem(
              type: MediaType.image,
              path: media.imagePath!,
              id: '${media.id}_image', // Unique ID for image
              originalId: media.id,
            ),
          );
        }

        // Add video as separate media item if exists
        if (media.videoPath?.isNotEmpty ?? false) {
          allMedia.add(
            MediaItem(
              type: MediaType.video,
              path: media.videoPath!,
              id: '${media.id}_video', // Unique ID for video
              originalId: media.id,
            ),
          );
        }

        // Log if media has both image and video
        if ((media.imagePath?.isNotEmpty ?? false) &&
            (media.videoPath?.isNotEmpty ?? false)) {}
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
    // Implement fullscreen video player
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
    navigateToScreen(context, CommentScreen(postId: widget.postItem.postId!));
  }
}

// ==================== POST HEADER ====================
class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.postItem,
    required this.isDark,
    required this.petId,
    this.onMenuTap,
  });

  final PostEntity postItem;
  final String? petId;
  final bool isDark;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Clinic Avatar
          _ClinicAvatar(imagePath: postItem.clinic?.image ?? postItem.petOwner?.imageName, isDark: isDark),

          const SizedBox(width: 12),

          // Clinic Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  postItem.clinic?.name ?? postItem.petOwner?.petName ?? '',
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  formatFacebookTimePost(postItem.createdAt!),
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey[500],
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Menu Button
          // if (petId != null && petId == postItem.petId)
          // IconButton(
          //   icon: Icon(
          //     Icons.more_horiz,
          //     color: isDark ? Colors.white70 : Colors.grey[700],
          //   ),
          //   onPressed: onMenuTap ?? () => _showPostMenu(context),
          //   splashRadius: 20,
          // ),
        ],
      ),
    );
  }

  void _showPostMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _PostMenuSheet(postItem: postItem),
    );
  }
}

// ==================== CLINIC AVATAR ====================
class _ClinicAvatar extends StatelessWidget {
  const _ClinicAvatar({required this.imagePath, required this.isDark});

  final String? imagePath;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: isDark ? Colors.grey[850] : Colors.grey[200],
        backgroundImage:
            imagePath != null && imagePath!.isNotEmpty
                ? FastCachedImageProvider(imageUrl + imagePath!)
                : null,
        child:
            imagePath == null || imagePath!.isEmpty
                ? Icon(
                  Icons.business,
                  color: isDark ? Colors.white54 : Colors.grey[600],
                  size: 22,
                )
                : null,
      ),
    );
  }
}

// ==================== POST CONTENT ====================
class _PostContent extends StatefulWidget {
  const _PostContent({required this.content, required this.isDark});

  final String content;
  final bool isDark;

  @override
  State<_PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<_PostContent> {
  bool _isExpanded = false;
  static const int _maxLines = 4;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : Colors.black87;
    final shouldShowMore = widget.content.length > 200;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.content,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              height: 1.5,
              letterSpacing: 0.2,
            ),
            maxLines: _isExpanded ? null : _maxLines,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
          ),
          if (shouldShowMore)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _isExpanded
                      ? (isArabic() ? 'عرض أقل' : 'See less')
                      : (isArabic() ? 'المزيد' : 'See more'),
                  style: TextStyle(
                    color: widget.isDark ? Colors.blue[300] : Colors.blue[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== MEDIA CAROUSEL ====================
class _MediaCarousel extends StatelessWidget {
  const _MediaCarousel({
    required this.media,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.onImageTap,
    required this.onVideoTap,
  });

  final List<MediaItem> media;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<String> onImageTap;
  final ValueChanged<String> onVideoTap;

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        // Media PageView
        SizedBox(
          height: _getMediaHeight(media),
          child: PageView.builder(
            controller: pageController,
            itemCount: media.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final item = media[index];
              return _MediaItem(
                mediaItem: item,
                onImageTap: () => onImageTap(item.path),
                onVideoTap: () => onVideoTap(item.path),
              );
            },
          ),
        ),

        // Media Counter Indicator
        if (media.length > 1)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${currentIndex + 1}/${media.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Navigation Dots
        if (media.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: _MediaDots(count: media.length, currentIndex: currentIndex),
          ),
      ],
    );
  }

  double _getMediaHeight(List<MediaItem> media) {
    // Adjust height based on media type and count
    if (media.length == 1) {
      return media.first.type == MediaType.video ? 300 : 400;
    }
    return 350; // Default height for carousel
  }
}

// ==================== MEDIA ITEM ====================
class _MediaItem extends StatelessWidget {
  const _MediaItem({
    required this.mediaItem,
    required this.onImageTap,
    required this.onVideoTap,
  });

  final MediaItem mediaItem;
  final VoidCallback onImageTap;
  final VoidCallback onVideoTap;

  @override
  Widget build(BuildContext context) {
    if (mediaItem.type == MediaType.image) {
      return _buildImage(context);
    } else {
      return _buildVideo(context);
    }
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: onImageTap,
      child: Hero(
        tag: 'image_${mediaItem.id}',
        child: FastCachedImage(
          url: imageUrl + mediaItem.path,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 60, color: Colors.grey[500]),
                  const SizedBox(height: 8),
                  Text(
                    isArabic() ? 'فشل تحميل الصورة' : 'Failed to load image',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
          loadingBuilder: (context, progress) {
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: progress.downloadedBytes / (progress.totalBytes ?? 1),
                  strokeWidth: 2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideo(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video thumbnail or placeholder
        (mediaItem.thumbnail?.isNotEmpty ?? false)
            ? FastCachedImage(
              url: imageUrl + mediaItem.thumbnail!,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildVideoPlaceholder();
              },
            )
            : _buildVideoPlaceholder(),

        // Video play button
        Positioned.fill(
          child: GestureDetector(
            onTap: onVideoTap,
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, size: 40, color: Colors.white),
                ),
              ),
            ),
          ),
        ),

        // Video badge
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.videocam, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  isArabic() ? 'فيديو' : 'Video',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: Icon(Icons.videocam, size: 60, color: Colors.grey[400]),
    );
  }
}

// ==================== MEDIA DOTS ====================
class _MediaDots extends StatelessWidget {
  const _MediaDots({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: isActive ? 20 : 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4),
            ],
          ),
        );
      }),
    );
  }
}



// ==================== ACTION BUTTONS ====================
class _ActionButtons extends StatefulWidget {
  const _ActionButtons({
    required this.postItm,
    required this.commentsCount,
    required this.isDark,
    required this.postId,
    required this.petID,
    required this.onComment,
  });

  final PostEntity postItm;
  final String postId;
  final String? petID;
  final int commentsCount;
  final bool isDark;
  final VoidCallback onComment;

  @override
  State<_ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<_ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),

      child: Row(
        children: [
          // Like Button
          ReactionButton(
            postId: widget.postId,
            petID: widget.petID,
            postItm: widget.postItm,
          ),

          // Comment Button
          _ActionButton(
            icon: IconlyLight.chat,
            label: '${widget.commentsCount} ${isArabic() ? 'تعليق' : 'Comment'}',
            color: widget.isDark ? Colors.white70 : Colors.grey[700]!,
            onTap: widget.onComment,
          ),
        ],
      ),
    );
  }
}

// ==================== ACTION BUTTON ====================
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// ==================== POST MENU SHEET ====================
class _PostMenuSheet extends StatelessWidget {
  const _PostMenuSheet({required this.postItem});

  final PostEntity postItem;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MenuItem(
            icon: Icons.edit,
            title: isArabic() ? 'تعديل المنشور' : 'Edit post',
            onTap: () {
              Navigator.pop(context);
              // هنا ممكن تضيف منطق تعديل المنشور
            },
          ),
          _MenuItem(
            icon: Icons.delete_outline,
            title: isArabic() ? 'حذف المنشور' : 'Delete post',
            isDestructive: true,
            onTap: () {
              Navigator.pop(context);
              _showDeleteDialog(context);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(isArabic() ? 'تأكيد الحذف' : 'Confirm Delete'),
            content: Text(
              isArabic()
                  ? 'هل أنت متأكد أنك تريد حذف هذا المنشور؟'
                  : 'Are you sure you want to delete this post?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(isArabic() ? 'إلغاء' : 'Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  // هنا تضيف منطق الحذف الحقيقي للمنشور
                },
                child: Text(isArabic() ? 'حذف' : 'Delete'),
              ),
            ],
          ),
    );
  }
}

// ==================== MENU ITEM ====================
class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : null;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}

// ==================== MEDIA ITEM MODEL ====================
enum MediaType { image, video }

class MediaItem {
  final MediaType type;
  final String path;
  final String? id;
  final String? originalId; // Original media entity ID
  final String? thumbnail; // Separate thumbnail for videos

  const MediaItem({
    required this.type,
    required this.path,
    this.id,
    this.originalId,
    this.thumbnail,
  });

  bool get isImage => type == MediaType.image;
  bool get isVideo => type == MediaType.video;
}

// ==================== VIDEO FULLSCREEN PLAYER ====================
class VideoFullScreenPlayer extends StatelessWidget {
  final String videoUrl;
  final String title;

  const VideoFullScreenPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: VideoStringApp(video: videoUrl)),
    );
  }
}
