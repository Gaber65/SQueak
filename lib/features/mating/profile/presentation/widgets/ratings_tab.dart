import 'package:flutter/material.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../core/network/end_points.dart';
import '../../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../../../../generated/l10n.dart';
import '../../domain/entities/history_entities.dart';

class RatingsTab extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;
  final List<HistoryEntity> history;

  const RatingsTab({
    super.key,
    required this.pet,
    required this.history,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final historyItem = history[index];
        return buildContainerItem(historyItem, context);
      },
    );
  }

  Container buildContainerItem(HistoryEntity item, context) {
    final hasImage =
        item.pet!.imageName != null &&
        item.pet!.imageName!.isNotEmpty &&
        item.pet!.imageName != imageUrl;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDarkMode
                  ? [Colors.grey.shade800, Colors.grey.shade800]
                  : [Colors.white, Colors.amber.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDarkMode
                  ? Colors.grey.shade700.withOpacity(0.5)
                  : Colors.amber.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
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
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                strokeWidth: 2,
                                valueColor: const AlwaysStoppedAnimation<Color>(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.pet!.owner!.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: index < 5 ? Colors.amber : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.partnerRateComment ?? '',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
