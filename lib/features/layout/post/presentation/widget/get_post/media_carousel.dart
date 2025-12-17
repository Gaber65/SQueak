import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../domain/entities/post_entity.dart';

class MediaCarousel extends StatelessWidget {
  const MediaCarousel({
    super.key,
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
    if (media.length == 1) {
      return media.first.type == MediaType.video ? 300 : 400;
    }
    return 350;
  }
}

class _MediaItem extends StatefulWidget {
  const _MediaItem({
    required this.mediaItem,
    required this.onImageTap,
    required this.onVideoTap,
  });

  final MediaItem mediaItem;
  final VoidCallback onImageTap;
  final VoidCallback onVideoTap;

  @override
  State<_MediaItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<_MediaItem> {
  Future<File?>? _thumbnailFuture;

  @override
  void initState() {
    super.initState();

    // ✅ Generate thumbnail مرة واحدة بس
    if (widget.mediaItem.type == MediaType.video &&
        (widget.mediaItem.thumbnail?.isEmpty ?? true)) {
      _thumbnailFuture = generateVideoThumbnail(imageUrl+widget.mediaItem.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaItem.type == MediaType.image) {
      return _buildImage(context);
    } else {
      return _buildVideo(context);
    }
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: widget.onImageTap,
      child: Hero(
        tag: 'image_${widget.mediaItem.id}',
        child: FastCachedImage(
          url: imageUrl + widget.mediaItem.path,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => _imageError(),
        ),
      ),
    );
  }

  Widget _imageError() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
      ),
    );
  }

  // ================= VIDEO =================

  Widget _buildVideo(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1️⃣ Thumbnail من الـ backend
        if (widget.mediaItem.thumbnail?.isNotEmpty ?? false)
          FastCachedImage(
            url: imageUrl + widget.mediaItem.thumbnail!,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => _videoThumbnailFromUrl(),
          )
        // 2️⃣ Thumbnail من الفيديو نفسه
        else
          _videoThumbnailFromUrl(),

        // ▶ Play overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onVideoTap,
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.play_arrow, size: 40, color: Colors.white),
                ),
              ),
            ),
          ),
        ),

        // 🎥 Badge
        Positioned(
          bottom: 12,
          right: 12,
          child: _videoBadge(),
        ),
      ],
    );
  }

  Widget _videoThumbnailFromUrl() {
    return FutureBuilder<File?>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        print(snapshot.data);
        print(snapshot.connectionState);
print('---------------');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _videoPlaceholder();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return _videoPlaceholder();
        }

        return Image.file(
          snapshot.data!,
          fit: BoxFit.cover,
          width: double.infinity,
        );
      },
    );
  }

  Widget _videoPlaceholder() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Icon(Icons.videocam, color: Colors.white54, size: 40),
      ),
    );
  }

  Widget _videoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.videocam, size: 12, color: Colors.white),
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
    );
  }
}

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
