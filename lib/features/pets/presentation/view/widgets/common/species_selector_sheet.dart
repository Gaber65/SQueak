// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';
import '../../../../domain/entities/pet_entity.dart';

/// Shows a modal bottom sheet that lets the user search and pick a species.
/// - Loads species inside the bottom sheet and shows loader until ready.
/// - Uses the provided `PetCubit` to fetch and read the species list.
/// - Calls [onSelected] with the picked [SpeciesEntity].
Future<void> showSpeciesSelector(
  BuildContext context,
  PetCubit cubit, {
  required void Function(SpeciesEntity) onSelected,
}) async {
  final TextEditingController searchCtrl = TextEditingController();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          List<SpeciesEntity> filtered = List.of(cubit.species);

          void applyFilter(String q) {
            filtered = cubit.species
                .where((s) => s.type.toLowerCase().contains(q.toLowerCase()))
                .toList();
          }

          // Trigger loading if species are not loaded yet
          if (cubit.species.isEmpty) {
            Future.microtask(() async {
              await cubit.getAllSpecies();
              setState(() {}); // refresh UI when loaded
            });
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // small drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    S.of(context).species,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // show loader until data is loaded
                  if (cubit.species.isEmpty)
                    const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: isArabic()
                            ? 'ابحث عن الفصيلة'
                            : 'Search for species...',
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white10
                                : Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (q) => setState(() => applyFilter(q)),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return ListTile(
                              title: Text(item.type),
                              onTap: () {
                                Navigator.pop(context);
                                onSelected(item);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
