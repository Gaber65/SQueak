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
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back_ios),
          //   onPressed: () => _handleBackPress(),
          // ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child:
                widget.state is DeletePetLoadingState
                    ? const LinearProgressIndicator()
                    : Container(),
          ),
        ),
        body: _buildBody(),
        floatingActionButton:
            _shouldShowFab()
                ? FloatingActionButton(
                  backgroundColor: ColorManager.primaryColor,
                  child: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => showPetTypeSelection(context, widget.cubit),
                )
                : null,
      ),
    );
  }

  Widget _buildBody() {
    // Show loading when fetching pets initially
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

    // Show error state if failed to load pets
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

    // Show empty state when no pets exist (after loading is complete)
    if (widget.pets.isEmpty && widget.state is! GetOwnerPetsLoadingState) {
      return EmptyState(
        onAddPetPressed: () => showPetTypeSelection(context, widget.cubit),
      );
    }

    // Show pets list when pets exist
    return _buildPetList(widget.qrCubit);
  }

  bool _shouldShowFab() {
    // Show FAB only when not loading
    return widget.state is! GetOwnerPetsLoadingState;
  }

  Widget _buildPetList(qrCubit) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.pets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return PetCard(
          pet: widget.pets[index],
          cubit: widget.cubit,
          qrCubit: qrCubit,
        );
      },
    );
  }

  void _handleBackPress() {
    if (_isSnackBarVisible) {
      _hideSnackBar();
    } else {
      _navigateToHome();
    }
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
      // Add StatefulBuilder to manage loading state
      return StatefulBuilder(
        builder: (context, setState) {
          bool isLoadingOther = cubit.isLoading = false;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
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
                      // Show species selector list after response
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
                      // Hide loading indicator
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
