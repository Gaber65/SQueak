import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/presentation/view/supplier/get_supplier.dart';

import '../../../../../qr/presentation/controller/qr_cubit.dart';
import '../../../../../qr/presentation/widgets/qr_action_buttons.dart';
import '../../../../../qr/presentation/widgets/qr_status_indicator.dart';
import '../../../../domain/entities/pet_entity.dart';
import '../../../controller/pet_cubit.dart';
import '../../edit_pet_screen.dart';

class PetCard extends StatefulWidget {
  final PetEntities pet;
  final PetCubit cubit;
  final QrCubit qrCubit;

  // new
  final bool selectionMode;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const PetCard({
    super.key,
    required this.pet,
    required this.cubit,
    required this.qrCubit,
    this.selectionMode = false,
    this.isSelected = false,
    required this.onSelected,
  });

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MainCubit.get(context).isDark
                  ? Colors.grey[800]!.withOpacity(0.9)
                  : Colors.white,
              MainCubit.get(context).isDark
                  ? Colors.grey[850]!.withOpacity(0.8)
                  : Colors.grey[50]!.withOpacity(0.5),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color:
                  MainCubit.get(context).isDark
                      ? Colors.black.withOpacity(0.3)
                      : ColorManager.primaryColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color:
                  MainCubit.get(context).isDark
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.8),
              blurRadius: 10,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color:
                MainCubit.get(context).isDark
                    ? Colors.grey[700]!.withOpacity(0.3)
                    : Colors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap:
                widget.selectionMode
                    ? () => widget.onSelected(!widget.isSelected)
                    : () => _navigateToEditPet(context),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (widget.selectionMode) ...[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  widget.isSelected
                                      ? ColorManager.primaryColor
                                      : Colors.grey.withOpacity(0.3),
                              width: 2,
                            ),
                            color:
                                widget.isSelected
                                    ? ColorManager.primaryColor
                                    : Colors.transparent,
                          ),
                          child: Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: widget.isSelected,
                              onChanged:
                                  (val) => widget.onSelected(val ?? false),
                              activeColor: Colors.transparent,
                              checkColor: Colors.white,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(child: _buildPetHeader(context)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  QrStatusIndicator(pet: widget.pet),
                  const SizedBox(height: 16),

                  if (!widget.selectionMode)
                    QrActionButtons(
                      pet: widget.pet,
                      petCubit: widget.cubit,
                      c: widget.qrCubit,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(
                widget.pet.imageName.toString().contains('PetAvatar') ||
                        widget.pet.imageName.toString().isEmpty
                    ? 'https://img.freepik.com/free-vector/hand-drawn-animal-rescue-illustration_52683-109643.jpg'
                    : '$imageUrl${widget.pet.imageName}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.primaryColor.withOpacity(0.3),
                          ColorManager.secondColor.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.pets,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.primaryColor.withOpacity(0.1),
                          ColorManager.secondColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorManager.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.pet.petName ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color:
                      MainCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  // Gender indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getGenderColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _getGenderColor().withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getGenderIcon(),
                          size: 12,
                          color: _getGenderColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getGenderText(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getGenderColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Spay/Neuter status
                  if (widget.pet.isSpayed != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            widget.pet.isSpayed!
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color:
                              widget.pet.isSpayed!
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.orange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.pet.isSpayed!
                                ? Icons.health_and_safety
                                : Icons.warning_amber_outlined,
                            size: 12,
                            color:
                                widget.pet.isSpayed!
                                    ? Colors.green
                                    : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.pet.isSpayed!
                                ? (isArabic() ? "معقم" : "Spayed")
                                : (isArabic() ? "غير معقم" : "Not Spayed"),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color:
                                  widget.pet.isSpayed!
                                      ? Colors.green
                                      : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (widget.pet.birthdate?.isNotEmpty ?? false) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorManager.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cake_outlined,
                        size: 14,
                        color: ColorManager.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.pet.birthdate!.substring(0, 10),
                        style: TextStyle(
                          color: ColorManager.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _calculateAge(),
                        style: TextStyle(
                          color: ColorManager.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
              if (widget.pet.breed != null) ...[
                Text(
                  isArabic()
                      ? widget.pet.breed!.arBreed
                      : widget.pet.breed!.enBreed,
                  style: TextStyle(
                    color:
                        MainCubit.get(context).isDark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        if (!widget.selectionMode) _buildCalendarButton(context),
      ],
    );
  }

  Widget _buildCalendarButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
          onTap:
              () => navigateToScreen(
                context,
                MySupplierScreen(petSelectFromIcon: widget.pet),
              ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              IconlyLight.calendar,
              size: 22,
              color: ColorManager.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Color _getGenderColor() {
    switch (widget.pet.gender) {
      case 1:
        return Colors.blue; // Male
      case 2:
        return Colors.pink; // Female
      default:
        return Colors.grey;
    }
  }

  IconData _getGenderIcon() {
    switch (widget.pet.gender) {
      case 1:
        return Icons.male; // Male
      case 2:
        return Icons.female; // Female
      default:
        return Icons.help_outline;
    }
  }

  String _getGenderText() {
    switch (widget.pet.gender) {
      case 1:
        return isArabic() ? "ذكر" : "Male";
      case 2:
        return isArabic() ? "أنثى" : "Female";
      default:
        return isArabic() ? "غير محدد" : "Unknown";
    }
  }

  String _calculateAge() {
    if (widget.pet.birthdate?.isEmpty ?? true) return "";

    try {
      final birthDate = DateTime.parse(widget.pet.birthdate!);
      final now = DateTime.now();
      final difference = now.difference(birthDate);

      final years = difference.inDays ~/ 365;
      final months = (difference.inDays % 365) ~/ 30;

      if (years > 0) {
        return isArabic()
            ? "($years ${years == 1 ? 'سنة' : 'سنوات'})"
            : "($years ${years == 1 ? 'year' : 'years'})";
      } else if (months > 0) {
        return isArabic()
            ? "($months ${months == 1 ? 'شهر' : 'شهور'})"
            : "($months ${months == 1 ? 'month' : 'months'})";
      } else {
        final days = difference.inDays;
        return isArabic()
            ? "($days ${days == 1 ? 'يوم' : 'أيام'})"
            : "($days ${days == 1 ? 'day' : 'days'})";
      }
    } catch (e) {
      return "";
    }
  }

  void _navigateToEditPet(BuildContext context) {
    navigateToScreen(
      context,
      EditPet(pets: widget.pet, breedData: widget.cubit.allBreeds),
    );
  }
}
