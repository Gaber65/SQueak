import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/feeds/domain/entities/pet_mating_model.dart';

import '../../../../../core/utils/theme/decorations/decorations.dart';

class PetCardMating extends StatelessWidget {
  final PetMating pet;
  final VoidCallback onSendRequest;
  final VoidCallback onViewProfile;

  const PetCardMating({
    super.key,
    required this.pet,
    required this.onSendRequest,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: Decorations.kDecorationBoxShadow(context: context),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Pet Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                pet.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Pet Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${pet.breed} • ${pet.age}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  if (pet.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      pet.description!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: pet.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pet.status.displayName,
                      style: TextStyle(
                        color: pet.status.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: onSendRequest,
                    icon: const Icon(Icons.favorite, size: 16),
                    label: const Text(
                      'Send Request',
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
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 120,
                  child: OutlinedButton.icon(
                    onPressed: onViewProfile,
                    icon: const Icon(Icons.person, size: 16),
                    label: const Text('View Profile'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: ColorManager.primaryColor,
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
