import 'package:flutter/material.dart';
import 'package:squeak/core/network/end_points.dart';

import '../../../../../../core/service/global_widget/image_detail.dart';
import '../attach_files_in_chat/full_screen_media_viewer.dart';
import '../../../domain/entities/message_entity.dart';

class ImageGridLayout extends StatelessWidget {
  final List<Attachment> imageAttachments;

  const ImageGridLayout({super.key, required this.imageAttachments});

  @override
  Widget build(BuildContext context) {
    if (imageAttachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: _buildImageGrid(context),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    final count = imageAttachments.length;

    if (count == 1) {
      return _buildMediaItem(
        context,
        imageAttachments[0],
        index: 0,
        width: 240,
        height: 180,
        borderRadius: 16,
      );
    } else if (count == 2) {
      return _buildTwoImages(context);
    } else if (count == 3) {
      return _buildThreeImages(context);
    } else {
      return _buildFourOrMoreImages(context);
    }
  }

  Widget _buildTwoImages(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMediaItem(
          context,
          imageAttachments[0],
          index: 0,
          width: 115,
          height: 170,
          borderRadius: 16,
          margin: const EdgeInsets.only(right: 4),
        ),
        _buildMediaItem(
          context,
          imageAttachments[1],
          index: 1,
          width: 115,
          height: 170,
          borderRadius: 16,
          margin: const EdgeInsets.only(left: 4),
        ),
      ],
    );
  }

  Widget _buildThreeImages(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMediaItem(
              context,
              imageAttachments[0],
              index: 0,
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(right: 4, bottom: 4),
            ),
            _buildMediaItem(
              context,
              imageAttachments[1],
              index: 1,
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(left: 4, bottom: 4),
            ),
          ],
        ),
        _buildMediaItem(
          context,
          imageAttachments[2],
          index: 2,
          width: 234,
          height: 85,
          borderRadius: 14,
          margin: const EdgeInsets.only(top: 4),
        ),
      ],
    );
  }

  Widget _buildFourOrMoreImages(BuildContext context) {
    final isMoreThan4 = imageAttachments.length > 4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMediaItem(
              context,
              imageAttachments[0],
              index: 0,
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(right: 4, bottom: 4),
            ),
            _buildMediaItem(
              context,
              imageAttachments[1],
              index: 1,
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(left: 4, bottom: 4),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMediaItem(
              context,
              imageAttachments[2],
              index: 2,
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(right: 4, top: 4),
            ),
            
            _buildMediaItem(
              context,
              imageAttachments[3],
              index: 3,
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(left: 4, top: 4),
              remainingCount: isMoreThan4 ? imageAttachments.length - 4 : null,
            ),
          ],
        ),
      ],
    );
  }

  /// Unified method to build any media item (image or video)
  Widget _buildMediaItem(
    BuildContext context,
    Attachment attachment, {
    required int index,
    required double width,
    required double height,
    required double borderRadius,
    EdgeInsets margin = EdgeInsets.zero,
    int? remainingCount,
  }) {
    final isVideo = attachment.attachmentType == 1;
    final heroTag = 'media_${attachment.url}_${DateTime.now().millisecondsSinceEpoch}_$index';

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _openMediaViewer(context, index, isVideo),
          child: Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: SizedBox(
                width: width,
                height: height,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Base media content
                    _buildBaseMediaContent(
                      attachment.url,
                      isVideo,
                      width,
                      height,
                    ),
                    
                    // Overlays
                    if (isVideo || remainingCount != null)
                      _buildMediaOverlay(
                        isVideo,
                        remainingCount,
                        width,
                        height,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build the base content (image or video background)
  Widget _buildBaseMediaContent(
    String url,
    bool isVideo,
    double width,
    double height,
  ) {
    if (isVideo) {
      return Container(
        width: width,
        height: height,
        color: Colors.black87,
      );
    }

    return SafeFastCachedImageExtension.safe(
      url: imageUrl + url,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  /// Build overlay for video play button or remaining count
  Widget _buildMediaOverlay(
    bool isVideo,
    int? remainingCount,
    double width,
    double height,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(remainingCount != null ? 0.3 : 0.25),
            Colors.black.withOpacity(remainingCount != null ? 0.6 : 0.35),
          ],
        ),
      ),
      child: Center(
        child: remainingCount != null && !isVideo
            ? _buildCounterBadge(remainingCount)
            : _buildPlayButton(),
      ),
    );
  }

  /// Build play button for videos
  Widget _buildPlayButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  /// Build counter badge for remaining images
  Widget _buildCounterBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        '+$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Open full screen media viewer
  void _openMediaViewer(BuildContext context, int index, bool isVideo) {
    final mediaUrlsList =
        imageAttachments.map((att) => imageUrl + att.url).toList();
    final captionsList =
        imageAttachments.map((att) => att.description).toList();
    final typesList = imageAttachments
        .map(
          (att) =>
              att.attachmentType == 0 ? MediaType.image : MediaType.video,
        )
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenMediaViewer(
          mediaUrl: imageUrl + imageAttachments[index].url,
          mediaUrls: mediaUrlsList,
          mediaType: isVideo ? MediaType.video : MediaType.image,
          caption: imageAttachments[index].description,
          captions: captionsList,
          mediaTypes: typesList,
          initialIndex: index,
        ),
      ),
    );
  }
}