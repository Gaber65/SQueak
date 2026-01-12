import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

class PetCardMating extends StatelessWidget {
  final PetEntities pet;
  final VoidCallback onSendRequest;
  final VoidCallback onViewProfile;
  final VoidCallback onCancelRequest;

  const PetCardMating({
    super.key,
    required this.pet,
    required this.onSendRequest,
    required this.onCancelRequest,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        pet.imageName != null &&
        pet.imageName!.isNotEmpty &&
        pet.imageName != imageUrl;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textSecondaryColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Base sizes that scale with available width
        final maxWidth = constraints.maxWidth;
        final avatarSize = (maxWidth * 0.12).clamp(48.0, 96.0);
        final spacing = (maxWidth * 0.02).clamp(8.0, 20.0);
        // buttonWidth removed — buttons are now using Expanded to layout responsively
        final titleFont = (maxWidth * 0.045).clamp(14.0, 20.0);
        final subtitleFont = (maxWidth * 0.032).clamp(12.0, 16.0);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing),
          margin: EdgeInsets.symmetric(vertical: spacing, horizontal: spacing),
          decoration: Decorations.kDecorationBoxShadow(context: context),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: EdgeInsets.all(spacing * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row: avatar + info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🐶 Avatar
                    hasImage
                        ? ClipOval(
                          child: Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: ClipOval(
                              child: SafeFastCachedImageExtension.safe(
  url: imageUrl + pet.imageName!,
                                width: avatarSize,
                                height: avatarSize,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace,
) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.pets,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                loadingBuilder: (
                                  context,
                                  loadingProgress,
                                ) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                        .totalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .downloadedBytes /
                                                    loadingProgress
                                                        .totalBytes!
                                                : null,
                                        strokeWidth: 2,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                        : SizedBox(
                          width: avatarSize,
                          height: avatarSize,
                          child: CircleAvatar(
                            backgroundColor: ColorManager.primaryColor,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                pet.petName ?? S.of(context).littleFriend,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: (avatarSize * 0.18).clamp(
                                    10.0,
                                    14.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                    SizedBox(width: spacing * 2),

                    // 🩵 Pet Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pet.petName ?? S.of(context).littleFriend,
                                style: TextStyle(
                                  fontSize: titleFont,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (pet.gender != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isDarkMode
                                            ? Colors.grey.shade800
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          pet.gender == 1
                                              ? Colors.blue.shade100
                                              : Colors.pink.shade100,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          isDarkMode ? 0.15 : 0.03,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        pet.gender == 1
                                            ? Icons.male
                                            : Icons.female,
                                        size: 14,
                                        color:
                                            pet.gender == 1
                                                ? Colors.blue
                                                : Colors.pink,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        pet.gender == 1
                                            ? S.of(context).male
                                            : S.of(context).female,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: textSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (pet.birthdate != null && pet.birthdate!.isNotEmpty)
                                ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))}${pet.breed?.enBreed != null ? " • ${pet.breed!.enBreed}" : ""}"
                                : pet.breed?.enBreed ?? "",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: subtitleFont,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing * 0.8,
                              vertical: spacing * 0.35,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  pet.isSpayed!
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              pet.isSpayed!
                                  ? S.of(context).spayed
                                  : S.of(context).notSpayed,
                              style: TextStyle(
                                color:
                                    pet.isSpayed! ? Colors.green : Colors.red,
                                fontSize: (subtitleFont * 0.85).clamp(
                                  9.0,
                                  12.0,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: spacing * 1.25),

                // Bottom row: two buttons side-by-side
                Row(
                  children: [
                    Expanded(
                      child:
                          !pet.isSelected
                              ? ElevatedButton.icon(
                                onPressed: onSendRequest,
                                icon: const Icon(Icons.send_outlined, size: 16),
                                label: Text(
                                  S.of(context).sendRequest,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: ColorManager.primaryColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacing,
                                    vertical: spacing * 0.9,
                                  ),
                                ),
                              )
                              : OutlinedButton.icon(
                                onPressed: onCancelRequest,
                                icon: const Icon(Icons.close, size: 16),
                                label: Text(
                                  S.of(context).cancelRequest,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  foregroundColor: Colors.red,
                                  side: BorderSide(color: Colors.red),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacing,
                                    vertical: spacing * 0.9,
                                  ),
                                ),
                              ),
                    ),

                    SizedBox(width: spacing),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onViewProfile,
                        icon: const Icon(Icons.person, size: 16),
                        label: Text(
                          S.of(context).viewProfile,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: ColorManager.primaryColor,
                          side: BorderSide(color: ColorManager.primaryColor),
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing,
                            vertical: spacing * 0.9,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
