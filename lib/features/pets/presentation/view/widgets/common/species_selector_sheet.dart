// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';
import '../../../../domain/entities/pet_entity.dart';

/// Shows a modal bottom sheet that lets the user search and pick a species.
/// - Loads species inside the bottom sheet and shows loader until ready.
/// - Uses the provided `PetCubit` to fetch and read the species list.
/// - Calls [onSelected] with the picked [SpeciesEntity].
/// - Special mapping: cow/horse/sheep/goat -> cat (returns cat species but shows original selection)
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
            if (q.trim().isEmpty) {
              filtered = List.of(cubit.species);
            } else {
              filtered = cubit.species
                  .where((s) => s.type.toLowerCase().contains(q.toLowerCase()))
                  .toList();
            }
          }

          // Apply initial filter if there's text
          if (searchCtrl.text.isNotEmpty) {
            applyFilter(searchCtrl.text);
          }

          if (cubit.species.isEmpty) {
            Future.microtask(() async {
              await cubit.getAllSpecies();
              setState(() {
                applyFilter(searchCtrl.text);
              });
            });
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    S.of(context).species,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Show loader until data is loaded
                  if (cubit.species.isEmpty)
                    const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    // Search field
                    TextField(
                      controller: searchCtrl,
                      autofocus: false,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchCtrl.clear();
                                  setState(() => applyFilter(''));
                                },
                              )
                            : null,
                        hintText: isArabic()
                            ? 'ابحث عن الفصيلة'
                            : 'Search for species...',
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white10
                                : Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: ColorManager.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (q) => setState(() => applyFilter(q)),
                    ),
                    const SizedBox(height: 12),

                    // Results count indicator (optional)
                    if (searchCtrl.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          isArabic()
                              ? 'تم العثور على ${filtered.length} نتيجة'
                              : '${filtered.length} result${filtered.length != 1 ? 's' : ''} found',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),

                    // Species list
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      child: filtered.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      isArabic()
                                          ? 'لم يتم العثور على نتائج'
                                          : 'No species found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      isArabic()
                                          ? 'جرب مصطلح بحث مختلف'
                                          : 'Try a different search term',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Scrollbar(
                              thumbVisibility: true,
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                itemBuilder: (context, index) {
                                  final item = filtered[index];
                                  final willBeMappedToCat = _shouldMapToCat(item.type);
                                  
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    leading: Icon(
                                      Icons.pets,
                                      color: ColorManager.primaryColor,
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.type,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        if (willBeMappedToCat)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorManager.primaryColor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '→ Cat',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: ColorManager.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey.shade400,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _handleSpeciesSelection(
                                        item,
                                        cubit,
                                        onSelected,
                                      );
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

/// Check if a species should be mapped to cat
bool _shouldMapToCat(String speciesType) {
  const speciesToMapToCat = ['cow', 'horse', 'sheep', 'goat'];
  return speciesToMapToCat.contains(speciesType.toLowerCase());
}

/// Handles species selection with special mapping logic
/// If user selects cow/horse/sheep/goat, it will be mapped to "cat"
void _handleSpeciesSelection(
  SpeciesEntity selectedSpecies,
  PetCubit cubit,
  void Function(SpeciesEntity) onSelected,
) {
  // Check if this species should be mapped to cat
  if (_shouldMapToCat(selectedSpecies.type)) {
    // Try to find cat in the species list
    final catSpecies = cubit.species.firstWhere(
      (s) => s.type.toLowerCase() == 'cat',
      orElse: () => selectedSpecies, // Fallback to original if cat not found
    );
    
    // Pass the cat species to the callback
    onSelected(catSpecies);
    return;
  }

  // Normal selection
  onSelected(selectedSpecies);
}