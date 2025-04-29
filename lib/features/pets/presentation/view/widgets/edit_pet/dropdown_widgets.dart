import 'package:flutter/material.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/generated/l10n.dart';

import '../../../../data/models/pet_model.dart';
import '../../../../domain/entities/pet_entity.dart';
import '../../../controller/pet_cubit.dart';

Widget buildDropDownSpecies(
  List<SpeciesEntity> speciesData,
  BuildContext context,
  PetCubit cubit,
) {
  List<SpeciesEntity> getSpeciesSuggestions(String query) {
    return speciesData
        .where((s) => s.type.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  return DropDownSearchFormField(
    textFieldConfiguration: TextFieldConfiguration(
      style: TextStyle(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintText:
            cubit.dropdownValueSpecies.isEmpty
                ? 'Select species'
                : cubit.dropdownValueSpecies,
        fillColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black26
                : Colors.grey.shade200,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
      ),
    ),
    suggestionsCallback: (pattern) {
      return getSpeciesSuggestions(pattern);
    },
    itemBuilder: (context, SpeciesEntity suggestion) {
      return ListTile(
        title: Text(
          suggestion.type,
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      );
    },
    onSuggestionSelected: (SpeciesEntity suggestion) {
      cubit.changeSpecies(suggestion.type, suggestion.id);
      cubit.dropdownValueBreed = '';
      cubit.breedData.clear();
      cubit.breedIdController.clear();
      cubit.searchController.clear();
      cubit.getBreedsBySpecies(suggestion.id);
    },
    suggestionsBoxController: SuggestionsBoxController(),
    displayAllSuggestionWhenTap: true,
  );
}

Widget buildDropDownBreed(
  List<BreedEntity> breedData,
  BuildContext context,
  PetCubit cubit,
) {
  List<BreedEntity> getSuggestions(String query) {
    return breedData
        .where((s) => s.enType.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  return DropDownSearchFormField(
    textFieldConfiguration: TextFieldConfiguration(
      style: TextStyle(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        fillColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black26
                : Colors.grey.shade200,
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
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      );
    },
    onSuggestionSelected: (BreedEntity suggestion) {
      cubit.searchController.text = suggestion.enType;
      cubit.changeBreed(suggestion.enType, suggestion.id);
    },
    suggestionsBoxController: SuggestionsBoxController(),
    displayAllSuggestionWhenTap: true,
  );
}
