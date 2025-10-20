import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/profile/domain/entities/history_entities.dart';

import '../../domain/usecases/mating_profile_prams.dart'; // ضروري

class StatusManagerDialog extends StatefulWidget {
  const StatusManagerDialog({
    super.key,
    required this.petId,
    required this.historyId,
    required this.cubit,
    required this.listDate,
  });
  final String petId;
  final String historyId;
  final ProfileMatingCubit cubit;
  final List<Map<String, dynamic>> listDate;

  @override
  State<StatusManagerDialog> createState() => _StatusManagerDialogState();
}

class _StatusManagerDialogState extends State<StatusManagerDialog> {
  HistoryStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);



    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: widget.cubit.formKey,
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.pets, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    s.update_pet_status,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                s.change_pet_status_for({
                  'petName': 'Koky',
                }), // replace with actual pet name
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Status Options
              Expanded(
                child: ListView.builder(
                  itemCount: widget.listDate.length,
                  itemBuilder: (context, index) {
                    final statusData = widget.listDate[index];
                    final status = statusData['status'] as HistoryStatus;
                    final isSelected = _selectedStatus == status;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => setState(() => _selectedStatus = status),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected
                                      ? ColorManager.primaryColor
                                      : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color:
                                isSelected
                                    ? ColorManager.primaryColor.withAlpha(50)
                                    : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      statusData['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isSelected
                                                ? ColorManager.primaryColor
                                                    .withAlpha(255)
                                                : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      statusData['description'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorManager.primaryColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    s.selected,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Action Buttons
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(s.cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomElevatedButton(
                      isLoading: widget.cubit.isLoading,
                      formKey: widget.cubit.formKey,
                      onPressed: () async {
                        widget.cubit.updatePetMatingStatues(
                          MatingProfileParams(
                            petId: widget.petId,
                            historyId: widget.historyId,
                            status: _selectedStatus!,
                          ),
                        );
                        if (!widget.cubit.isLoading) {
                          Navigator.of(context).pop();
                        }
                      },

                      buttonText: S.of(context).update_status,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
