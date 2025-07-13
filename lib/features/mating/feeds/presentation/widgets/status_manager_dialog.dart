import 'package:flutter/material.dart';
import 'package:squeak/features/mating/feeds/domain/entities/pet_mating_model.dart';

class StatusManagerDialog extends StatefulWidget {
  const StatusManagerDialog({super.key});

  @override
  State<StatusManagerDialog> createState() => _StatusManagerDialogState();
}

class _StatusManagerDialogState extends State<StatusManagerDialog> {
  PetMatingStatus? _selectedStatus;

  final List<Map<String, dynamic>> _statuses = [
    {
      'status': PetMatingStatus.single,
      'title': 'Single',
      'description': 'Not looking for mating',
    },
    {
      'status': PetMatingStatus.availableForMating,
      'title': 'Available for Mating',
      'description': 'Ready to find a partner',
    },
    {
      'status': PetMatingStatus.onMating,
      'title': 'On Mating',
      'description': 'Currently in a mating relationship',
    },
    {
      'status': PetMatingStatus.previouslyMated,
      'title': 'Previously Mated',
      'description': 'Has completed mating',
    },
    {
      'status': PetMatingStatus.pregnant,
      'title': 'Pregnant',
      'description': 'Expecting babies',
    },
    {
      'status': PetMatingStatus.hasSetItsBaby,
      'title': 'Has Set Its Baby',
      'description': 'Now a parent',
    },
    {
      'status': PetMatingStatus.divorced,
      'title': 'Divorced',
      'description': 'Single again after mating',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.pets, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Update Pet Status',
                  style: TextStyle(
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
              'Change {petProvider.currentProfile?.name}\'s relationship status',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Status Options
            Expanded(
              child: ListView.builder(
                itemCount: _statuses.length,
                itemBuilder: (context, index) {
                  final statusData = _statuses[index];
                  final status = statusData['status'] as PetMatingStatus;
                  final isSelected = _selectedStatus == status;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => setState(() => _selectedStatus = status),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.pink : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? Colors.pink.shade50 : Colors.white,
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
                                      color: isSelected ? Colors.pink.shade700 : Colors.black,
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
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'Selected',
                                  style: TextStyle(
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
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Update Status'),
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
