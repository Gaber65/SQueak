// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';
import '../../../../domain/entities/pet_entity.dart';

/// Shows a modal bottom sheet that lets the user search and pick a species.
/// - Uses the provided `PetCubit` to read the loaded species list.
/// - If species are not loaded yet, it triggers `getAllSpecies()` and shows
///   a small loading indicator until results are available.
/// - Calls [onSelected] with the picked `SpeciesEntity`.
Future<void> showSpeciesSelector(
  BuildContext context,
  PetCubit cubit, {
  required void Function(SpeciesEntity) onSelected,
}) async {
  // Ensure we have species data available before opening the sheet
  if (cubit.species.isEmpty) {
    await cubit.getAllSpecies();
  }

  // Local controller for searching
  final TextEditingController searchCtrl = TextEditingController();
  List<SpeciesEntity> filtered = List.of(cubit.species);

  void applyFilter(String q) {
    filtered =
        cubit.species
            .where((s) => s.type.toLowerCase().contains(q.toLowerCase()))
            .toList();
  }

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
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText:
                          isArabic()
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
                      // Make the sheet tall but not full screen
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child:
                        cubit.species.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : Scrollbar(
                              thumbVisibility: true,
                              child: ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder:
                                    (_, __) => Divider(
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
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
