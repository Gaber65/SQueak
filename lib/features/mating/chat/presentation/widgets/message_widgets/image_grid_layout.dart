import 'package:flutter/material.dart';
import 'package:squeak/core/network/end_points.dart';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../../../core/service/global_widget/image_detail.dart';
import '../attach_files_in_chat/full_screen_media_viewer.dart';
import '../../../domain/entities/message_entity.dart';

class ImageGridLayout extends StatefulWidget {
  final List<Attachment> imageAttachments;

  const ImageGridLayout({super.key, required this.imageAttachments});

  @override
  State<ImageGridLayout> createState() => _ImageGridLayoutState();
}

class _ImageGridLayoutState extends State<ImageGridLayout> {
  final Map<String, Uint8List?> _thumbnailCache = {};

  final double spacing = 4.0;

  @override
  Widget build(BuildContext context) {
    if (widget.imageAttachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _buildImageGrid(context),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    final count = widget.imageAttachments.length;

    if (count == 1) {
      return _buildMediaItem(
        context,
        widget.imageAttachments[0],
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
          widget.imageAttachments[0],
          index: 0,
          width: 115,
          height: 170,
          borderRadius: 16,
        ),
        SizedBox(width: spacing), 
        _buildMediaItem(
          context,
          widget.imageAttachments[1],
          index: 1,
          width: 115,
          height: 170,
          borderRadius: 16,
        ),
      ],
    );
  }

  Widget _buildThreeImages(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMediaItem(
          context,
          widget.imageAttachments[0],
          index: 0,
          width: 230 + spacing, 
          height: 110,
          borderRadius: 14,
        ),
        SizedBox(height: spacing), 
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMediaItem(
              context,
              widget.imageAttachments[1],
              index: 1,
              width: 115,
              height: 85,
              borderRadius: 14,
            ),
            SizedBox(width: spacing), 
            _buildMediaItem(
              context,
              widget.imageAttachments[2],
              index: 2,
              width: 115,
              height: 85,
              borderRadius: 14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFourOrMoreImages(BuildContext context) {
    final isMoreThan4 = widget.imageAttachments.length > 4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMediaItem(
              context,
              widget.imageAttachments[0],
              index: 0,
              width: 115,
              height: 85,
              borderRadius: 14,
            ),
            SizedBox(width: spacing),
            _buildMediaItem(
              context,
              widget.imageAttachments[1],
              index: 1,
              width: 115,
              height: 85,
              borderRadius: 14,
            ),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMediaItem(
              context,
              widget.imageAttachments[2],
              index: 2,
              width: 115,
              height: 85,
              borderRadius: 14,
            ),
            SizedBox(width: spacing),
            _buildMediaItem(
              context,
              widget.imageAttachments[3],
              index: 3,
              width: 115,
              height: 85,
              borderRadius: 14,
              remainingCount:
                  isMoreThan4 ? widget.imageAttachments.length - 4 : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaItem(
    BuildContext context,
    Attachment attachment, {
    required int index,
    required double width,
    required double height,
    required double borderRadius,
    int? remainingCount,
  }) {
    final isVideo = attachment.attachmentType == 1;
    final heroTag =
        'media_${attachment.url}_${DateTime.now().millisecondsSinceEpoch}_$index';

    return Container(
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
                    _buildBaseMediaContent(
                      attachment.url,
                      isVideo,
                      width,
                      height,
                    ),
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

 

 
  Widget _buildBaseMediaContent(
    String url,
    bool isVideo,
    double width,
    double height,
  ) {
    if (isVideo) {
      return FutureBuilder<Uint8List?>(
        future: _generateVideoThumbnail(videoUrl + url, width, height),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              width: width,
              height: height,
              fit: BoxFit.cover,
            );
          } else {
            return Container(
              width: width,
              height: height,
              color: Colors.black87,
            );
          }
        },
      );
    }
    return SafeFastCachedImageExtension.safe(
      url: imageUrl + url,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  Future<Uint8List?> _generateVideoThumbnail(
    String videoUrl_,
    double width,
    double height,
  ) async {
    try {
      if (_thumbnailCache.containsKey(videoUrl_)) {
        return _thumbnailCache[videoUrl_];
      }
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoUrl_,
        imageFormat: ImageFormat.PNG,
        maxWidth: width.toInt(),
        maxHeight: height.toInt(),
        quality: 85,
        timeMs: 0,
      );
      if (uint8list != null) {
        _thumbnailCache[videoUrl_] = uint8list;
      }
      return uint8list;
    } catch (e) {
      debugPrint('❌ [GridVideoThumbnail] Error: $e');
      return null;
    }
  }

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
        child:
            remainingCount != null && !isVideo
                ? _buildCounterBadge(remainingCount)
                : _buildPlayButton(),
      ),
    );
  }

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

  Widget _buildCounterBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
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

  void _openMediaViewer(BuildContext context, int index, bool isVideo) {
    final mediaUrlsList =
        widget.imageAttachments.map((att) => imageUrl + att.url).toList();
    final captionList =
        widget.imageAttachments.map((att) => att.description).toList();
    final typesList =
        widget.imageAttachments
            .map(
              (att) =>
                  att.attachmentType == 0 ? MediaType.image : MediaType.video,
            )
            .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => FullScreenMediaViewer(
              mediaUrl: imageUrl + widget.imageAttachments[index].url,
              mediaUrls: mediaUrlsList,
              mediaType: isVideo ? MediaType.video : MediaType.image,
              caption: widget.imageAttachments[index].description,
              captions: captionList,
              mediaTypes: typesList,
              initialIndex: index,
            ),
      ),
    );
  }
}
