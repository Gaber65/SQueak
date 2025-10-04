// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    barrierDismissible: false,
    builder: (dialogContext) => BlocProvider.value(
      value: widget.cubit,
      child: BlocConsumer<PetCubit, PetState>(
        listener: (listenerContext, state) {
          if (state is MergePetsSuccessState) {
            Navigator.of(dialogContext).pop();
            if (mounted) {
              setState(() {
                _selectionMode = false;
                _selectedPets.clear();
              });
            }
            widget.cubit.getOwnerPets();
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (successContext) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isArabic() ? "تم الدمج بنجاح" : "Merge Successful",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(successContext).pop();
                        },
                        child: Text(isArabic() ? "موافق" : "OK"),
                      ),
                    ],
                  ),
                );
              }
            });
          } else if (state is MergePetsErrorState) {
            Navigator.of(dialogContext).pop();
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (errorContext) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Row(
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isArabic() ? "فشل الدمج" : "Merge Failed",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      isArabic()
                          ? "فشل الدمج. الرجاء المحاولة مرة أخرى"
                          : "Merge failed. Please try again.",
                      style: const TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(errorContext).pop(),
                        child: Text(isArabic() ? "موافق" : "OK"),
                      ),
                    ],
                  ),
                );
              }
            });
          }
        },
        builder: (builderContext, state) {
          final isLoading = state is MergePetsLoadingState;
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 32,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isArabic() ? "تأكيد الدمج" : "Confirm Merge",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              isArabic()
                  ? "⚠️ سيتم حذف الأليف الأحدث، وسيبقى الأليف الأقدم فقط.\n\n❗ هذا الإجراء لا يمكن التراجع عنه."
                  : "⚠️ The newest pets will be deleted, and only the oldest will remain.\n\n❗ This action cannot be undone.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: isLoading
                    ? null
                    : () => Navigator.of(dialogContext).pop(),
                child: Text(isArabic() ? "إلغاء" : "Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        widget.cubit.mergePets(_selectedPets.toList());
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(isArabic() ? "تأكيد" : "Confirm"),
              ),
            ],
          );
        },
      ),
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
