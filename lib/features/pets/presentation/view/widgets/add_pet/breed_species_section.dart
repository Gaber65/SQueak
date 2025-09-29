import 'package:flutter/material.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';
import '../common/species_selector_sheet.dart';

class BreedSpeciesSection extends StatefulWidget {
  const BreedSpeciesSection({super.key, required this.cubit, required this.isDark});

  final PetCubit cubit;
  final bool isDark;

  @override
  State<BreedSpeciesSection> createState() => _BreedSpeciesSectionState();
}

class _BreedSpeciesSectionState extends State<BreedSpeciesSection> {
  bool _isLoadingBreeds = false;
  bool _showingOtherSpeciesLoader = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return BlocListener<PetCubit, PetState>(
          bloc: widget.cubit,
          listener: (context, state) {
            if (state is GetAllBreedsLoadingState) {
              setState(() {
                _isLoadingBreeds = true;
              });
            } else if (state is GetAllBreedsSuccessState || state is GetAllBreedsErrorState) {
              setState(() {
                _isLoadingBreeds = false;
              });
            }
            if (state is GetAllSpeciesLoadingState) {
              setState(() {
                _showingOtherSpeciesLoader = true;
              });
            } else if (state is GetAllSpeciesSuccessState || state is GetAllSpeciesErrorState) {
              setState(() {
                _showingOtherSpeciesLoader = false;
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSmallScreen) ...[
                _buildSpeciesSelection(context),
                const SizedBox(height: 16),
                _buildBreedDropdown(context),
              ] else ...[
                Row(
                  children: [
                    Expanded(child: _buildSpeciesSelection(context)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildBreedDropdown(context)),
                  ],
                ),
              ],
            ],
          ),
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
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        _isLoadingBreeds 
            ? _buildBreedLoadingField(context)
            : _buildDropDownBreed(widget.cubit.breedData, context),
      ],
    );
  }

  Widget _buildBreedLoadingField(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.black26 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.pets, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            'Loading breeds...',
            style: TextStyle(
              color: widget.isDark ? Colors.white54 : Colors.black54,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildSpeciesSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${S.of(context).species} *',
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;
            if (isSmallScreen) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildSpeciesCard(context, 'Dog', FontAwesomeIcons.dog, 'dog')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildSpeciesCard(context, 'Cat', FontAwesomeIcons.cat, 'cat')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildOtherSpeciesCard(context),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(child: _buildSpeciesCard(context, 'Dog', FontAwesomeIcons.dog, 'dog')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSpeciesCard(context, 'Cat', FontAwesomeIcons.cat, 'cat')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildOtherSpeciesCard(context)),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSpeciesCard(BuildContext context, String name, IconData icon, String speciesType) {
    final isSelected = widget.cubit.dropdownValueSpecies.toLowerCase() == name.toLowerCase();
    
    return GestureDetector(
      onTap: () async {
        final speciesId = _getSpeciesIdForType(speciesType);
        if (speciesId.isNotEmpty) {
          _handleSpeciesSelection(name, speciesId);
        } else {
          if (widget.cubit.species.isEmpty) {
            await widget.cubit.getAllSpecies();
          }
          final newSpeciesId = _getSpeciesIdForType(speciesType);
          if (newSpeciesId.isNotEmpty) {
            _handleSpeciesSelection(name, newSpeciesId);
          }
        }
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isSelected 
              ? (widget.isDark ? ColorManager.primaryColor.withValues(alpha: 0.3) : ColorManager.primaryLight)
              : (widget.isDark ? Colors.black26 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
              ? Border.all(color: ColorManager.primaryColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected 
                  ? ColorManager.primaryColor 
                  : (widget.isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontColor: isSelected 
                    ? ColorManager.primaryColor 
                    : (widget.isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherSpeciesCard(BuildContext context) {
    final hasOtherSpecies = widget.cubit.dropdownValueSpecies.isNotEmpty && 
        !['dog', 'cat'].contains(widget.cubit.dropdownValueSpecies.toLowerCase());
    
    return GestureDetector(
      onTap: _showingOtherSpeciesLoader ? null : () async {
        await _handleOtherSpeciesSelection(context);
      },
      child: Container(
        height: 80,
        width: 200,
        decoration: BoxDecoration(
          color: hasOtherSpecies 
              ? (widget.isDark ? ColorManager.primaryColor.withValues(alpha: 0.3) : ColorManager.primaryLight)
              : (widget.isDark ? Colors.black26 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          border: hasOtherSpecies 
              ? Border.all(color: ColorManager.primaryColor, width: 2)
              : null,
        ),
        child: _showingOtherSpeciesLoader 
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasOtherSpecies ? Icons.check_circle : Icons.pets,
                    size: 32,
                    color: hasOtherSpecies 
                        ? ColorManager.primaryColor 
                        : (widget.isDark ? Colors.white70 : Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasOtherSpecies 
                        ? widget.cubit.dropdownValueSpecies
                        : 'Other',
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 12,
                      fontWeight: hasOtherSpecies ? FontWeight.w600 : FontWeight.w500,
                      fontColor: hasOtherSpecies 
                          ? ColorManager.primaryColor 
                          : (widget.isDark ? Colors.white70 : Colors.black87),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }

  void _handleSpeciesSelection(String speciesName, String speciesId) {
    widget.cubit.changeSpecies(speciesName, speciesId);
    widget.cubit.dropdownValueBreed = '';
    widget.cubit.breedData.clear();
    widget.cubit.breedIdController.clear();
    widget.cubit.searchController.clear();
    
    widget.cubit.getBreedsBySpecies(speciesId);
  }

  Future<void> _handleOtherSpeciesSelection(BuildContext context) async {
    setState(() {
      _showingOtherSpeciesLoader = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      // Use the improved species selector with search
      await showSpeciesSelector(
        context,
        widget.cubit,
        onSelected: (SpeciesEntity s) {
          _handleSpeciesSelection(s.type, s.id);
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _showingOtherSpeciesLoader = false;
        });
      }
    }
  }

  String _getSpeciesIdForType(String speciesType) {
    final speciesList = widget.cubit.species;
    for (final species in speciesList) {
      if (species.type.toLowerCase().contains(speciesType.toLowerCase())) {
        return species.id;
      }
    }
    switch (speciesType.toLowerCase()) {
      case 'dog':
        return 'bca48207-f05d-4e9f-a631-06f34eb5af39'; 
      case 'cat':
        return 'f1131363-3b9f-40ee-9a89-0573ee274a10'; 
      default:
        return '';
    }
  }

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
          color: widget.isDark ? ColorManager.sWhite : ColorManager.black_87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          fillColor: widget.isDark ? Colors.black26 : Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: 'Enter breed (optional)',
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: widget.isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        controller: widget.cubit.searchController,
      ),
      suggestionsCallback: (pattern) {
        return getSuggestions(pattern);
      },
      itemBuilder: (context, BreedEntity suggestion) {
        return ListTile(
          title: Text(
            suggestion.enType,
            style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
          ),
        );
      },
      onSuggestionSelected: (BreedEntity suggestion) {
        widget.cubit.searchController.text = suggestion.enType;
        widget.cubit.changeBreed(suggestion.enType, suggestion.id);
      },
      suggestionsBoxController: suggestionBoxController,
      displayAllSuggestionWhenTap: true,
    );
  }
}