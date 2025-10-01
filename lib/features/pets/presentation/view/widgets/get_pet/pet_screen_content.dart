import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:squeak/features/pets/presentation/view/add_pet_screen.dart';
import 'package:squeak/features/pets/presentation/view/widgets/get_pet/pet_card.dart';
import 'package:squeak/features/pets/presentation/view/widgets/get_pet/pet_type_option.dart';
import 'package:squeak/features/qr/presentation/controller/qr_cubit.dart';

import '../../../../../../core/utils/export_path/export_files.dart';
import '../../../../../../core/service/global_widget/vc_loading_widget.dart';
import '../../../../domain/entities/pet_entity.dart';
import '../../../controller/pet_cubit.dart';
import 'empty_state.dart';
import '../common/species_selector_sheet.dart';

class PetScreenContent extends StatefulWidget {
  final List<PetEntities> pets;
  final PetCubit cubit;
  final QrCubit qrCubit;
  final PetState state;

  const PetScreenContent({
    super.key,
    required this.pets,
    required this.cubit,
    required this.state,
    required this.qrCubit,
  });

  @override
  State<PetScreenContent> createState() => _PetScreenContentState();
}

class _PetScreenContentState extends State<PetScreenContent> {
  bool _isSnackBarVisible = false;

  // new states for selection mode
  bool _selectionMode = false;
  final Set<String> _selectedPets = {};

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_isSnackBarVisible) {
          _hideSnackBar();
          return false;
        }
        _navigateToHome();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(S.of(context).myPets),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child:
                widget.state is DeletePetLoadingState
                    ? const LinearProgressIndicator()
                    : Container(),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.primaryColor,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.merge_type,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _selectionMode = !_selectionMode;
                    _selectedPets.clear();
                  });
                },
              ),
            ),
          ],
        ),
        body: _buildBody(),
        floatingActionButton: _buildFab(),
      ),
    );
  }

  FloatingActionButton? _buildFab() {
    if (_selectionMode && _selectedPets.isNotEmpty) {
      return FloatingActionButton(
        backgroundColor: ColorManager.primaryColor,
        child: const Icon(Icons.merge_type, color: Colors.white),
        onPressed: () => _showMergeConfirmDialog(),
      );
    }

    // Normal FAB
    return _shouldShowFab()
        ? FloatingActionButton(
          backgroundColor: ColorManager.primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => showPetTypeSelection(context, widget.cubit),
        )
        : null;
  }

  void _showMergeConfirmDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isArabic() ? "تأكيد الدمج" : "Confirm Merge"),
            content: Text(
              isArabic()
                  ? "هل تريد دمج ${_selectedPets.length} حيوانات؟"
                  : "Do you want to merge ${_selectedPets.length} pets?",
            ),
            actions: [
              TextButton(
                child: Text(isArabic() ? "إلغاء" : "Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                ),
                child: Text(isArabic() ? "تأكيد" : "Confirm"),
                onPressed: () {
                  Navigator.pop(context);
                  widget.cubit.mergePets(_selectedPets.toList());
                  setState(() {
                    _selectionMode = false;
                    _selectedPets.clear();
                  });
                },
              ),
            ],
          ),
    );
  }

  Widget _buildBody() {
    if (widget.state is GetOwnerPetsLoadingState) {
      return Center(
        child: VcLoadingIndicator(
          message:
              isArabic()
                  ? "جاري تحميل حيواناتك الأليفة..."
                  : "Loading your pets...",
          size: 32.0,
        ),
      );
    }

    if (widget.state is GetOwnerPetsErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              isArabic()
                  ? "خطأ في تحميل حيواناتك الأليفة"
                  : "Failed to load your pets",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => widget.cubit.getOwnerPets(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
              ),
              child: Text(isArabic() ? "إعادة المحاولة" : "Try Again"),
            ),
          ],
        ),
      );
    }

    if (widget.pets.isEmpty && widget.state is! GetOwnerPetsLoadingState) {
      return EmptyState(
        onAddPetPressed: () => showPetTypeSelection(context, widget.cubit),
      );
    }

    return _buildPetList(widget.qrCubit);
  }

  bool _shouldShowFab() {
    return widget.state is! GetOwnerPetsLoadingState;
  }

  Widget _buildPetList(qrCubit) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.pets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final pet = widget.pets[index];
        return PetCard(
          pet: pet,
          cubit: widget.cubit,
          qrCubit: qrCubit,
          selectionMode: _selectionMode,
          isSelected: _selectedPets.contains(
            widget.pets.elementAt(index).petId,
          ),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedPets.add(widget.pets.elementAt(index).petId!);
              } else {
                _selectedPets.remove(widget.pets.elementAt(index).petId);
              }
            });
          },
        );
      },
    );
  }

  void _hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => _isSnackBarVisible = false);
  }

  void _navigateToHome() {
    navigateAndFinish(context, const LayoutScreen());
  }
}

void showPetTypeSelection(BuildContext context, PetCubit cubit) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor:
        MainCubit.get(context).isDark ? Colors.grey[900] : Colors.white,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool isLoadingOther = cubit.isLoading = false;

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  S.of(context).selectPetType,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        MainCubit.get(context).isDark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: PetTypeOption(
                        icon: FontAwesomeIcons.cat,
                        label: isArabic() ? 'قطة' : 'Cat',
                        onTap:
                            () => navigateToAddPet(
                              isArabic() ? 'قطة' : 'Cat',
                              'assets/avatar7.jpg',
                              'f1131363-3b9f-40ee-9a89-0573ee274a10',
                              context,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PetTypeOption(
                        icon: FontAwesomeIcons.dog,
                        label: isArabic() ? 'كلب' : 'Dog',
                        onTap:
                            () => navigateToAddPet(
                              isArabic() ? 'كلب' : 'Dog',
                              'assets/avatar7.jpg',
                              'bca48207-f05d-4e9f-a631-06f34eb5af39',
                              context,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    try {
                      await showSpeciesSelector(
                        context,
                        cubit,
                        onSelected: (species) {
                          navigateToAddPet(
                            species.type,
                            'assets/avatar7.jpg',
                            species.id,
                            context,
                          );
                        },
                      );
                    } finally {
                      setState(() {
                        isLoadingOther = false;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isLoadingOther
                            ? const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorManager.primaryColor,
                                ),
                              ),
                            )
                            : const Icon(
                              FontAwesomeIcons.paw,
                              size: 40,
                              color: Colors.blueAccent,
                            ),
                        const SizedBox(height: 8),
                        Text(
                          isArabic() ? 'أخرى' : 'Other',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color:
                                MainCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}

void navigateToAddPet(
  String speciesName,
  String imagePath,
  String speciesId,
  BuildContext context,
) {
  Navigator.pop(context);
  navigateToScreen(
    context,
    AddPetScreen(
      dropdownValueSpecies: speciesName,
      pathImage: imagePath,
      species: speciesId,
    ),
  );
}
