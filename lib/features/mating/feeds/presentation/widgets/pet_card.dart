import 'package:flutter/material.dart';
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
    final hasImage = pet.imageName != null &&
        pet.imageName!.isNotEmpty &&
        pet.imageName != imageUrl;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: Decorations.kDecorationBoxShadow(context: context),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 🐶 Avatar
            hasImage
                ? ClipOval(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl + pet.imageName!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.pets, color: Colors.white),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes !=
                                null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
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
              width: 70,
              height: 70,
              child: CircleAvatar(
                backgroundColor: ColorManager.primaryColor,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    pet.petName ?? S.of(context).littleFriend,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 🩵 Pet Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.petName ?? S.of(context).littleFriend,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    (pet.birthdate != null && pet.birthdate!.isNotEmpty)
                        ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))}${pet.breed?.enBreed != null ? " • ${pet.breed!.enBreed}" : ""}"
                        : pet.breed?.enBreed ?? "",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: pet.isSpayed!
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pet.isSpayed!
                          ? S.of(context).spayed
                          : S.of(context).notSpayed,
                      style: TextStyle(
                        color: pet.isSpayed! ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 💌 Buttons
            Column(
              children: [
                !pet.isSelected ?
                SizedBox(
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: onSendRequest,
                    icon: const Icon(Icons.favorite, size: 16),
                    label: Text(
                      S.of(context).sendRequest,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: ColorManager.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ) :
                SizedBox(
                  width: 150,
                  child: OutlinedButton.icon(
                    onPressed: onCancelRequest,
                    icon: const Icon(Icons.close, size: 16),
                    label: Text(S.of(context).cancelRequest),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 150,
                  child: OutlinedButton.icon(
                    onPressed: onViewProfile,
                    icon: const Icon(Icons.person, size: 16),
                    label: Text(S.of(context).viewProfile),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: ColorManager.primaryColor,
                      side: BorderSide(color: ColorManager.primaryColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
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
  }
}
