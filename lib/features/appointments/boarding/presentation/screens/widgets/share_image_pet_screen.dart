import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';

import '../../../domain/entities/boarding_entry_entity.dart';

class ImageCarouselWidget extends StatefulWidget {
  final bool open;
  final void Function(bool) onOpenChange;
  final BoardingEntryEntity? boarding;
  final void Function(String imageUrl, String platform) onShare;

  const ImageCarouselWidget({
    super.key,
    required this.open,
    required this.onOpenChange,
    required this.boarding,
    required this.onShare,
  });

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  double currentImageIndex = 0;

  void nextImage() {
    setState(() {
      currentImageIndex =
          (currentImageIndex + 1) %
          (widget.boarding?.boardingImages.length ?? 1);
    });
  }

  void prevImage() {
    setState(() {
      currentImageIndex =
          currentImageIndex == 0
              ? (widget.boarding!.boardingImages.length - 1)
              : currentImageIndex - 1;
    });
  }

  void openShareSheet(String imageUrl) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  isArabic() ? 'مشاركة في الفيسبوك' : 'Share to Facebook',
                ),
                onTap: () {
                  widget.onShare(imageUrl, 'facebook');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  isArabic() ? 'مشاركة في الانستقرام' : 'Share to Instagram',
                ),
                onTap: () {
                  widget.onShare(imageUrl, 'instagram');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  isArabic() ? 'مشاركة في تويتر' : 'Share to Twitter',
                ),
                onTap: () {
                  widget.onShare(imageUrl, 'twitter');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  isArabic() ? 'مشاركة في واتساب' : 'Share to WhatsApp',
                ),
                onTap: () {
                  widget.onShare(imageUrl, 'whatsapp');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox();

    final boarding = widget.boarding;
    if (boarding == null || boarding.boardingImages.isEmpty) {
      return AlertDialog(
        title: Text(isArabic() ? 'لا توجد صور' : 'No Images Found'),
        content: Text(
          isArabic()
              ? 'لا توجد صور لهذه الاقامة.'
              : 'No images found for this boarding.',
        ),
        actions: [
          TextButton(
            onPressed: () => widget.onOpenChange(false),
            child: const Text('Close'),
          ),
        ],
      );
    }

    final currentImage = boarding.boardingImages[currentImageIndex.toInt()];

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isArabic()
                  ? 'صور إقامة ${boarding.pet.name}'
                  : "${boarding.pet.name}'s Boarding Photos",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SafeFastCachedImageExtension.safe(
                  url: currentImage,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, _) =>
                          const Center(child: Text('Failed to load image')),
                ),
              ),
              if (boarding.boardingImages.length > 1) ...[
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: prevImage,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: nextImage,
                  ),
                ),
              ],
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () => openShareSheet(currentImage),
                ),
              ),
            ],
          ),
          if (boarding.boardingImages.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  boarding.boardingImages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          currentImageIndex == index
                              ? Colors.blue
                              : Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ),
          TextButton(
            onPressed: () => widget.onOpenChange(false),
            child: Text(isArabic() ? "اغلاق" : "Close"),
          ),
        ],
      ),
    );
  }
}
