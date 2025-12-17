import 'package:flutter/material.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../../core/utils/theme/color_mangment/color_manager.dart';

class PetAvatar extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;

  const PetAvatar({super.key, required this.pet, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final rawImageName = pet.imageName;
    final hasImage =
        rawImageName != null &&
        rawImageName.isNotEmpty &&
        rawImageName != 'xxx';

    String? fullImageUrl;
    if (hasImage) {
      if (rawImageName.startsWith('http')) {
        fullImageUrl = rawImageName;
      } else {
        fullImageUrl = imageUrl + rawImageName;
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor.withOpacity(1),
            ColorManager.primaryColor.withOpacity(.4),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child:
            hasImage && fullImageUrl != null
                ? CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      fullImageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color:
                              isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.pets,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
                : CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.pets,
                        size: 40,
                        color: isDarkMode ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
