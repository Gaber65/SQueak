import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/status_manager_dialog.dart';

import '../../../../pets/domain/entities/pet_entity.dart';
import '../../domain/entities/history_entities.dart';

class HistoryTab extends StatelessWidget {
  final bool isDarkMode;
  final List<HistoryEntity> history;
  final ProfileMatingCubit cubit;
  final PetEntities pet;

  const HistoryTab({
    super.key,
    required this.isDarkMode,
    required this.cubit,
    required this.history,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return buildContainerItem(item, context);
      },
    );
  }

  Widget buildContainerItem(HistoryEntity item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDarkMode
                  ? [Colors.grey.shade800, Colors.grey.shade800]
                  : [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDarkMode
                  ? Colors.grey.shade700.withOpacity(0.5)
                  : Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (pet.gender == 2 &&
              pet.ownerId == CacheHelper.getData('clintId')) {
            showDialog(
              context: context,
              builder: (context) {
                return StatusManagerDialog(
                  petId: item.pet!.petId!,
                  historyId: item.id,
                  listDate: statusesAlertToUpdateHistory(S.of(context)),
                  cubit: cubit,
                );
              },
            );
          }
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  item.currentStatus.color.withOpacity(0.3),
                  item.currentStatus.color.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.currentStatus.icon,
              color: item.currentStatus.color,
              size: 20,
            ),
          ),
          title: Text(
            'Mated with ${item.pet!.petName}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            formatFacebookTimePost(item.currentStatusDate ?? ""),
            style: TextStyle(
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: item.currentStatus.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.currentStatus.color.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  item.currentStatus.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: item.currentStatus.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
