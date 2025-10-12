import 'package:flutter/material.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
import '../../../../../pets/domain/entities/pet_entity.dart';

class AddPetBreedDropdownModal extends StatelessWidget {
  final List<BreedEntity> breeds;
  final TextEditingController controller;
  final Function(String, String) onBreedSelected;

  const AddPetBreedDropdownModal({
    super.key,
    required this.breeds,
    required this.controller,
    required this.onBreedSelected,
  });

  Future<void> _openBreedPickerModal(BuildContext context) async {
    String filter = '';
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            List<BreedEntity> filtered = breeds;
            return StatefulBuilder(
              builder: (context, setModalState) {
                filtered = breeds
                    .where((b) => b.enType.toLowerCase().contains(filter.toLowerCase()))
                    .toList();
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search breed...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (v) => setModalState(() => filter = v),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(child: Text('No breeds found'))
                            : ListView.separated(
                                controller: scrollController,
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final b = filtered[index];
                                  return ListTile(
                                    title: Text(b.enType),
                                    onTap: () {
                                      controller.text = b.enType;
                                      onBreedSelected(b.id, b.enType);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openBreedPickerModal(context),
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          // show black text when a breed is selected (controller has text), otherwise show hint color
          style: TextStyle(color: controller.text.isNotEmpty ? Colors.black : Colors.grey[700]),
          decoration: InputDecoration(
            fillColor: ColorManager.white,
            filled: true,
            hintText: "Select breed (optional)",
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: ColorManager.primaryColor.withOpacity(.7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}