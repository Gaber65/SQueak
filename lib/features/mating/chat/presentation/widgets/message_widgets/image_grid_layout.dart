import 'package:flutter/material.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:squeak/core/network/end_points.dart';
import '../attach_files_in_chat/full_screen_media_viewer.dart';
import '../../../domain/entities/message_entity.dart';

class ImageGridLayout extends StatelessWidget {
  final List<Attachment> imageAttachments;

  const ImageGridLayout({
    super.key,
    required this.imageAttachments,
  });

  @override
  Widget build(BuildContext context) {
    if (imageAttachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: _buildImageGrid(context),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    final count = imageAttachments.length;

    if (count == 1) {
      return _buildSingleImage(context, imageAttachments[0], 0);
    } else if (count == 2) {
      return _buildTwoImages(context);
    } else if (count == 3) {
      return _buildThreeImages(context);
    } else {
      return _buildFourOrMoreImages(context);
    }
  }

  Widget _buildSingleImage(BuildContext context, Attachment attachment, int index) {
    return _buildImageWithTap(
      context,
      attachment.url,
      width: 220,
      height: 160,
      borderRadius: 12,
      index: index,
    );
  }

  Widget _buildTwoImages(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildImageWithTap(
          context,
          imageAttachments[0].url,
          width: 105,
          height: 160,
          borderRadius: 12,
          margin: const EdgeInsets.only(right: 4),
          index: 0,
        ),
        _buildImageWithTap(
          context,
          imageAttachments[1].url,
          width: 105,
          height: 160,
          borderRadius: 12,
          margin: const EdgeInsets.only(left: 4),
          index: 1,
        ),
      ],
    );
  }

  Widget _buildThreeImages(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row: 2 images
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageWithTap(
              context,
              imageAttachments[0].url,
              width: 108,
              height: 75,
              borderRadius: 12,
              margin: const EdgeInsets.only(right: 2, bottom: 2),
              index: 0,
            ),
            _buildImageWithTap(
              context,
              imageAttachments[1].url,
              width: 108,
              height: 75,
              borderRadius: 12,
              margin: const EdgeInsets.only(left: 2, bottom: 2),
              index: 1,
            ),
          ],
        ),
        _buildImageWithTap(
          context,
          imageAttachments[2].url,
          width: 218,
          height: 75,
          borderRadius: 12,
          margin: const EdgeInsets.only(top: 2),
          index: 2,
        ),
      ],
    );
  }

  Widget _buildFourOrMoreImages(BuildContext context) {
    final isMoreThan4 = imageAttachments.length > 4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageWithTap(
              context,
              imageAttachments[0].url,
              width: 108,
              height: 75,
              borderRadius: 12,
              margin: const EdgeInsets.only(right: 2, bottom: 2),
              index: 0,
            ),
            _buildImageWithTap(
              context,
              imageAttachments[1].url,
              width: 108,
              height: 75,
              borderRadius: 12,
              margin: const EdgeInsets.only(left: 2, bottom: 2),
              index: 1,
            ),
          ],
        ),
        // Bottom row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageWithTap(
              context,
              imageAttachments[2].url,
              width: 108,
              height: 75,
              borderRadius: 12,
              margin: const EdgeInsets.only(right: 2, top: 2),
              index: 2,
            ),
            if (isMoreThan4)
              _buildImageWithCounterTap(
                context,
                imageAttachments[3].url,
                width: 108,
                height: 75,
                borderRadius: 12,
                margin: const EdgeInsets.only(left: 2, top: 2),
                index: 3,
                remainingCount: imageAttachments.length - 4,
              )
            else
              _buildImageWithTap(
                context,
                imageAttachments[3].url,
                width: 108,
                height: 75,
                borderRadius: 12,
                margin: const EdgeInsets.only(left: 2, top: 2),
                index: 3,
              ),
          ],
        ),
      ],
    );
  }

  /// Build a single image with tap handler
  Widget _buildImageWithTap(
    BuildContext context,
    String attachmentUrl, {
    required double width,
    required double height,
    required double borderRadius,
    EdgeInsets margin = EdgeInsets.zero,
    int index = 0,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenMediaViewer(
              mediaUrl: imageUrl + attachmentUrl,
              mediaType: MediaType.image,
              caption: imageAttachments[index].description,
            ),
          ),
        );
      },
      child: Container(
        margin: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: FastCachedImage(
            url: imageUrl + attachmentUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, exception, stacktrace) {
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: const Center(child: Icon(Icons.image_not_supported)),
              );
            },
            loadingBuilder: (context, imageProvider) {
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build an image with a counter overlay
  Widget _buildImageWithCounterTap(
    BuildContext context,
    String attachmentUrl, {
    required double width,
    required double height,
    required double borderRadius,
    EdgeInsets margin = EdgeInsets.zero,
    int index = 0,
    required int remainingCount,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenMediaViewer(
              mediaUrl: imageUrl + attachmentUrl,
              mediaType: MediaType.image,
              caption: imageAttachments[index].description,
            ),
          ),
        );
      },
      child: Container(
        margin: margin,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: FastCachedImage(
                url: imageUrl + attachmentUrl,
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (context, exception, stacktrace) {
                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  );
                },
                loadingBuilder: (context, imageProvider) {
                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            // Dark overlay
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            // Counter text
            Text(
              '+$remainingCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
