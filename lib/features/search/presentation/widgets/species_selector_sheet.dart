import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/pets/presentation/controller/pet_cubit.dart';

class SpeciesSelectorSheet extends StatefulWidget {
  final PetCubit petCubit;
  final Function(SpeciesEntity) onSelected;

  const SpeciesSelectorSheet({
    super.key,
    required this.petCubit,
    required this.onSelected,
  });

  @override
  State<SpeciesSelectorSheet> createState() => _SpeciesSelectorSheetState();
}

class _SpeciesSelectorSheetState extends State<SpeciesSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<SpeciesEntity> _filteredSpecies = [];

  @override
  void initState() {
    super.initState();
    _filteredSpecies = widget.petCubit.species;
    _searchController.addListener(_filterSpecies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSpecies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSpecies = widget.petCubit.species.where((species) {
        return species.type.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final isTablet = screen.width > 600;
    final mainCubit = context.read<MainCubit>();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: mainCubit.isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: mainCubit.isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              // Search bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screen.width * 0.04,
                  vertical: screen.height * 0.01,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: mainCubit.isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    hintText: 'Search species...',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screen.height * 0.018,
                      horizontal: screen.width * 0.04,
                    ),
                    filled: true,
                    fillColor: mainCubit.isDark ? Colors.grey[800] : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: mainCubit.isDark ? Colors.grey[700]! : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: mainCubit.isDark ? Colors.grey[700]! : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: ColorManager.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // Species list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _filteredSpecies.length,
                  itemBuilder: (context, index) {
                    final species = _filteredSpecies[index];
                    return ListTile(
                      title: Text(
                        species.type,
                        style: TextStyle(
                          fontSize: isTablet ? 16 : screen.width * 0.04,
                          color: mainCubit.isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      onTap: () {
                        widget.onSelected(species);
                        Navigator.pop(context);
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
  }
}

Future<void> showSpeciesSelector(
  BuildContext context,
  PetCubit petCubit,
  {required Function(SpeciesEntity) onSelected}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SpeciesSelectorSheet(
      petCubit: petCubit,
      onSelected: onSelected,
    ),
  );
}