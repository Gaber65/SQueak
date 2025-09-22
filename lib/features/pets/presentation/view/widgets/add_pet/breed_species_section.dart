import 'package:flutter/material.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../controller/pet_cubit.dart';
import '../common/species_selector_sheet.dart';

class BreedSpeciesSection extends StatelessWidget {
  BreedSpeciesSection({super.key, required this.cubit, required this.isDark});

  final PetCubit cubit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSmallScreen) ...[
              // Stack vertically on small screens
              _buildSpeciesDropdown(context),
              const SizedBox(height: 16),

              _buildBreedDropdown(context),
            ] else ...[
              // Side by side on larger screens
              Row(
                children: [
                  Expanded(child: _buildSpeciesDropdown(context)),
                  const SizedBox(width: 16),

                  Expanded(child: _buildBreedDropdown(context)),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildBreedDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).breed,
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropDownBreed(cubit.breedData, context),
      ],
    );
  }

  Widget _buildSpeciesDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).species,
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Tappable field that opens our unified species selector bottom sheet.
        InkWell(
          onTap: () async {
            await showSpeciesSelector(
              context,
              cubit,
              onSelected: (SpeciesEntity s) {
                cubit.changeSpecies(s.type, s.id);
                cubit.dropdownValueBreed = '';
                cubit.breedData.clear();
                cubit.breedIdController.clear();
                cubit.searchController.clear();
                cubit.getBreedsBySpecies(s.id);
              },
            );
          },
          child: MyTextForm(
            controller: TextEditingController(text: cubit.dropdownValueSpecies),
            enable: false,
            enabled: false,
            hintText:
                cubit.dropdownValueSpecies.isEmpty
                    ? 'Select species'
                    : cubit.dropdownValueSpecies,
            obscureText: false,
            prefixIcon: const Icon(Icons.pets),
          ),
        ),
      ],
    );
  }

  // Legacy dropdown removed in favor of the unified selector sheet.

  final suggestionBoxController = SuggestionsBoxController();

  Widget _buildDropDownBreed(
    List<BreedEntity> breedData,
    BuildContext context,
  ) {
    List<BreedEntity> getSuggestions(String query) {
      return breedData
          .where((s) => s.enType.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return DropDownSearchFormField(
      textFieldConfiguration: TextFieldConfiguration(
        style: TextStyle(
          color: isDark ? ColorManager.sWhite : ColorManager.black_87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          fillColor: isDark ? Colors.black26 : Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: S.of(context).breed,
          filled: true,
        ),
        controller: cubit.searchController,
      ),
      suggestionsCallback: (pattern) {
        return getSuggestions(pattern);
      },
      itemBuilder: (context, BreedEntity suggestion) {
        return ListTile(
          title: Text(
            suggestion.enType,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        );
      },
      onSuggestionSelected: (BreedEntity suggestion) {
        cubit.searchController.text = suggestion.enType;
        cubit.changeBreed(suggestion.enType, suggestion.id);
      },
      suggestionsBoxController: suggestionBoxController,
      displayAllSuggestionWhenTap: true,
    );
  }
}
