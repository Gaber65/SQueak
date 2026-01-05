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
      margin: const EdgeInsets.only(bottom: 12),
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
      width: 240,
      height: 180,
      borderRadius: 16,
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
          width: 115,
          height: 170,
          borderRadius: 16,
          margin: const EdgeInsets.only(right: 6),
          index: 0,
        ),
        _buildImageWithTap(
          context,
          imageAttachments[1].url,
          width: 115,
          height: 170,
          borderRadius: 16,
          margin: const EdgeInsets.only(left: 6),
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
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(right: 4, bottom: 4),
              index: 0,
            ),
            _buildImageWithTap(
              context,
              imageAttachments[1].url,
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(left: 4, bottom: 4),
              index: 1,
            ),
          ],
        ),
        _buildImageWithTap(
          context,
          imageAttachments[2].url,
          width: 234,
          height: 85,
          borderRadius: 14,
          margin: const EdgeInsets.only(top: 4),
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
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(right: 4, bottom: 4),
              index: 0,
            ),
            _buildImageWithTap(
              context,
              imageAttachments[1].url,
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(left: 4, bottom: 4),
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
              width: 115,
              height: 85,
              borderRadius: 14,
              margin: const EdgeInsets.only(right: 4, top: 4),
              index: 2,
            ),
            if (isMoreThan4)
              _buildImageWithCounterTap(
                context,
                imageAttachments[3].url,
                width: 115,
                height: 85,
                borderRadius: 14,
                margin: const EdgeInsets.only(left: 4, top: 4),
                index: 3,
                remainingCount: imageAttachments.length - 4,
              )
            else
              _buildImageWithTap(
                context,
                imageAttachments[3].url,
                width: 115,
                height: 85,
                borderRadius: 14,
                margin: const EdgeInsets.only(left: 4, top: 4),
                index: 3,
              ),
          ],
        ),
      ],
    );
  }

  /// Build a single image with tap handler and enhanced UI
  Widget _buildImageWithTap(
    BuildContext context,
    String attachmentUrl, {
    required double width,
    required double height,
    required double borderRadius,
    EdgeInsets margin = EdgeInsets.zero,
    int index = 0,
  }) {
    final heroTag = 'image_${attachmentUrl}_$index';

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
          child: Hero(
            tag: heroTag,
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
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_rounded,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Failed to load',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loadingBuilder: (context, imageProvider) {
                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: _buildShimmerEffect(width, height, borderRadius),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build an image with a counter overlay and enhanced UI
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
    final heroTag = 'image_${attachmentUrl}_$index';

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
          child: Hero(
            tag: heroTag,
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
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_rounded,
                              size: 32,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Failed to load',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, imageProvider) {
                      return Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: _buildShimmerEffect(width, height, borderRadius),
                      );
                    },
                  ),
                ),
                // Gradient overlay for better text visibility
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                // Enhanced counter badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '+$remainingCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build shimmer loading effect
  Widget _buildShimmerEffect(double width, double height, double borderRadius) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1.0, end: 2.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                (value - 0.3).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 0.3).clamp(0.0, 1.0),
              ],
              colors: [
                Colors.grey[200]!,
                Colors.grey[100]!,
                Colors.grey[200]!,
              ],
            ),
          ),
        );
      },
      onEnd: () {
       
      },
    );
  }
}