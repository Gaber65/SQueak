// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:squeak/features/pets/presentation/view/add_pet_screen.dart';
import 'package:squeak/features/pets/presentation/view/widgets/get_pet/pet_card.dart';
import 'package:squeak/features/pets/presentation/view/widgets/get_pet/pet_type_option.dart';
import 'package:squeak/features/qr/presentation/controller/qr_cubit.dart';

import '../../../../../../core/utils/export_path/export_files.dart';
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
        backgroundColor:
            MainCubit.get(context).isDark
                ? const Color(0xFF121212)
                : const Color(0xFFF8FAFC),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            S.of(context).myPets,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color:
                  MainCubit.get(context).isDark ? Colors.white : Colors.black87,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child:
                widget.state is DeletePetLoadingState
                    ? Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorManager.primaryColor,
                            ColorManager.secondColor,
                          ],
                        ),
                      ),
                      child: const LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.transparent,
                        ),
                      ),
                    )
                    : Container(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      setState(() {
                        _selectionMode = !_selectionMode;
                        _selectedPets.clear();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [ColorManager.primaryColor, ColorManager.secondColor],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.primaryColor.withOpacity(0.22),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectionMode ? Icons.close : Icons.merge_type,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              S.of(context).mergePets,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        body: _buildBody(),
        floatingActionButton: _buildFab(),
        // Place FAB at the start side so it is left in LTR and right in RTL
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }

  FloatingActionButton? _buildFab() {
    if (_selectionMode && _selectedPets.isNotEmpty) {
      return FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => _showMergeConfirmDialog(),
        label: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            final pulseScale = 1.0 + (math.sin(value * 2 * math.pi) * 0.03);
            final glowIntensity = 0.3 + (math.sin(value * 2 * math.pi) * 0.2);

            return Transform.scale(
              scale: pulseScale,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorManager.primaryColor,
                      ColorManager.secondColor,
                      ColorManager.primaryColor.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(
                        glowIntensity,
                      ),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: ColorManager.secondColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: -2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.merge_type,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Merge ${_selectedPets.length} pets',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return _shouldShowFab()
        ? FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => showPetTypeSelection(context, widget.cubit),
          label: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1500),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              final pulseScale = 1.0 + (math.sin(value * 2 * math.pi) * 0.05);
              final glowIntensity = 0.4 + (math.sin(value * 2 * math.pi) * 0.3);
              final rotationAngle = math.sin(value * 2 * math.pi) * 0.1;

              return Transform.scale(
                scale: pulseScale,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorManager.primaryColor,
                        ColorManager.secondColor,
                        ColorManager.primaryColor.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.primaryColor.withOpacity(
                          glowIntensity,
                        ),
                        blurRadius: 20,
                        spreadRadius: 3,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: ColorManager.secondColor.withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: -3,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: -1,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: rotationAngle,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            FontAwesomeIcons.paw,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
        : null;
  }

  void _showMergeConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => BlocProvider.value(
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
                        builder:
                            (successContext) => AlertDialog(
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
                                    isArabic()
                                        ? "تم الدمج بنجاح"
                                        : "Merge Successful",
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
                        builder:
                            (errorContext) => AlertDialog(
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
                                  onPressed:
                                      () => Navigator.of(errorContext).pop(),
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
                      onPressed:
                          isLoading
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
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                widget.cubit.mergePets(_selectedPets.toList());
                              },
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
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
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MainCubit.get(context).isDark
                  ? Colors.grey[900]!.withOpacity(0.8)
                  : Colors.white.withOpacity(0.8),
              MainCubit.get(context).isDark
                  ? Colors.grey[800]!.withOpacity(0.6)
                  : Colors.grey[50]!.withOpacity(0.6),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      MainCubit.get(context).isDark
                          ? Colors.grey[800]
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildPawLoadingIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      isArabic()
                          ? "جاري تحميل اصدقائك الأليفة..."
                          : "Loading your pets...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            MainCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.state is GetOwnerPetsErrorState) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      MainCubit.get(context).isDark
                          ? Colors.grey[800]
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isArabic()
                          ? "خطأ في تحميل حيواناتك الأليفة"
                          : "Failed to load your pets",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color:
                            MainCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isArabic()
                          ? "يرجى المحاولة مرة أخرى"
                          : "Please try again",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            ColorManager.primaryColor,
                            ColorManager.secondColor,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => widget.cubit.getOwnerPets(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            child: Text(
                              isArabic() ? "إعادة المحاولة" : "Try Again",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.pets.isEmpty && widget.state is! GetOwnerPetsLoadingState) {
      return EmptyState(
        onAddPetPressed: () => showPetTypeSelection(context, widget.cubit),
      );
    }

    return Column(
      children: [
        if (widget.pets.isNotEmpty) _buildPetsDashboard(),
        Expanded(child: _buildPetList(widget.qrCubit)),
      ],
    );
  }

  Widget _buildPetsDashboard() {
    final totalPets = widget.pets.length;
    final linkedPets =
        widget.pets.where((pet) => pet.qrCode?.isNotEmpty == true).length;
    // final petsWithPassport = widget.pets.where((pet) => 
    //     pet.passportNumber?.isNotEmpty == true).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primaryColor.withOpacity(0.1),
            ColorManager.secondColor.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: ColorManager.primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryColor,
                      ColorManager.secondColor,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.pets,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic()
                          ? "لوحة الأصدقاء الأليفة"
                          : "Pet Dashboard",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color:
                            MainCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black87,
                      ),
                    ),
                    Text(
                      isArabic()
                          ? "نظرة سريعة على أصدقائك"
                          : "Quick overview",
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            MainCubit.get(context).isDark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCompactStatCard(
                  totalPets.toString(),
                  isArabic() ? "المجموع" : "Total",
                  Icons.pets_outlined,
                  const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCompactStatCard(
                  linkedPets.toString(),
                  isArabic() ? "مربوطة" : "Linked",
                  Icons.qr_code_2,
                  const Color(0xFF10B981),
                ),
              ),
              // const SizedBox(width: 10),
              // Expanded(
              //   child: _buildCompactStatCard(
              //     petsWithPassport.toString(),
              //     isArabic() ? "جوازات" : "Passport",
              //     Icons.card_membership,
              //     const Color(0xFF8B5CF6),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: MainCubit.get(context).isDark
            ? Colors.grey[800]!.withOpacity(0.6)
            : Colors.white.withOpacity(0.8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color.withOpacity(0.15),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: MainCubit.get(context).isDark 
                  ? Colors.white 
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: MainCubit.get(context).isDark
                  ? Colors.grey[400]
                  : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  bool _shouldShowFab() {
    return widget.state is! GetOwnerPetsLoadingState;
  }

  Widget _buildPetList(qrCubit) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MainCubit.get(context).isDark
                ? const Color(0xFF121212)
                : const Color(0xFFF8FAFC),
            MainCubit.get(context).isDark
                ? Colors.grey[900]!.withOpacity(0.8)
                : Colors.grey[50]!.withOpacity(0.8),
          ],
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: widget.pets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final pet = widget.pets[index];
          // Ensure animation duration doesn't get too long for lists with many items
          final animationDelay = (index * 50).clamp(0, 500);
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + animationDelay),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              // Clamp the value to ensure it's between 0.0 and 1.0
              final clampedValue = value.clamp(0.0, 1.0);
              return Transform.translate(
                offset: Offset(0, 20 * (1 - clampedValue)),
                child: Opacity(opacity: clampedValue, child: child),
              );
            },
            child: Hero(
              tag: 'pet_card_${pet.petId}',
              child: Material(
                color: Colors.transparent,
                child: RepaintBoundary(
                  child: PetCard(
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
                          _selectedPets.remove(
                            widget.pets.elementAt(index).petId,
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => _isSnackBarVisible = false);
  }

  void _navigateToHome() {
    navigateAndFinish(context, const LayoutScreen());
  }

  Widget _buildPawLoadingIndicator() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Central paw
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryColor,
                      ColorManager.secondColor,
                    ],
                  ),
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 24),
              ),
              // Animated paws around the center
              ...List.generate(4, (index) {
                final angle =
                    (index * 90) * (3.14159 / 180); // Convert to radians
                final animationOffset = (value + (index * 0.25)) % 1.0;
                final opacity =
                    (math.sin(animationOffset * 2 * math.pi) + 1) / 2;
                final scale = 0.5 + (opacity * 0.5);

                return Positioned(
                  left: 40 + (25 * math.cos(angle)) - 10,
                  top: 40 + (25 * math.sin(angle)) - 10,
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity.clamp(0.3, 1.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorManager.primaryColor.withOpacity(0.6),
                        ),
                        child: const Icon(
                          Icons.pets,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
      onEnd: () {
        // Restart the animation
        if (mounted) {
          setState(() {});
        }
      },
    );
  }
}

void showPetTypeSelection(BuildContext context, PetCubit cubit) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool isLoadingOther = cubit.isLoading = false;

          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MainCubit.get(context).isDark
                      ? Colors.grey[900]!
                      : Colors.white,
                  MainCubit.get(context).isDark
                      ? Colors.grey[800]!.withOpacity(0.95)
                      : Colors.grey[50]!.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    S.of(context).selectPetType,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic()
                        ? "اختر نوع صغيرك الأليف لبدء الرحلة"
                        : "Choose your pet type to get started",
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorManager.primaryColor.withOpacity(0.1),
                                ColorManager.secondColor.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: ColorManager.primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: PetTypeOption(
                            icon: FontAwesomeIcons.cat,
                            label: isArabic() ? 'قطة' : 'Cat',
                            onTap:
                                () => navigateToAddPet(
                                  isArabic() ? 'قطة' : 'Cat',
                                  'assets/avatar_new.webp',
                                  'f1131363-3b9f-40ee-9a89-0573ee274a10',
                                  context,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorManager.primaryColor.withOpacity(0.1),
                                ColorManager.secondColor.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: ColorManager.primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: PetTypeOption(
                            icon: FontAwesomeIcons.dog,
                            label: isArabic() ? 'كلب' : 'Dog',
                            onTap:
                                () => navigateToAddPet(
                                  isArabic() ? 'كلب' : 'Dog',
                                  'assets/avatar_new.webp',
                                  'bca48207-f05d-4e9f-a631-06f34eb5af39',
                                  context,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorManager.primaryColor.withOpacity(0.1),
                          ColorManager.secondColor.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: ColorManager.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          try {
                            await showSpeciesSelector(
                              context,
                              cubit,
                              onSelected: (species) {
                                navigateToAddPet(
                                  species.type,
                                  'assets/avatar_new.webp',
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isLoadingOther
                                  ? TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 800),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, value, child) {
                                      final scale =
                                          0.8 +
                                          (math.sin(value * 2 * math.pi) * 0.2);
                                      return Transform.scale(
                                        scale: scale,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: ColorManager.primaryColor
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.paw,
                                            size: 20,
                                            color: ColorManager.primaryColor,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.paw,
                                      size: 28,
                                      color: Colors.orange,
                                    ),
                                  ),
                              const SizedBox(height: 12),
                              Text(
                                isArabic() ? 'أخرى' : 'Other',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      MainCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic()
                                    ? 'اختر من المزيد من الأنواع'
                                    : 'Choose from more species',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      MainCubit.get(context).isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
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
