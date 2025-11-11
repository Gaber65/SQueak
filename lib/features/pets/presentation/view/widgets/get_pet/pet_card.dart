import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/presentation/view/supplier/get_supplier.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../qr/presentation/controller/qr_cubit.dart';
import '../../../../../qr/presentation/widgets/qr_action_buttons.dart';
import '../../../../../qr/presentation/widgets/qr_status_indicator.dart';
import '../../../../../qr/presentation/widgets/qr_link_dialog.dart';
import '../../../../domain/entities/pet_entity.dart';
import '../../../controller/pet_cubit.dart';
import '../../edit_pet_screen.dart';

class PetCard extends StatefulWidget {
  final PetEntities pet;
  final PetCubit cubit;
  final QrCubit qrCubit;
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
  void _handleQrIconTap(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLinked = widget.pet.qrCode?.isNotEmpty == true;
    if (isLinked) {
      showDialog(
        context: context,
        builder:
            (dialogContext) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.green.shade50, Colors.white],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      S.of(context).qrCodeStatus,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      S.of(context).linkedToQr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          S.of(context).ok,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (dialogContext) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDark ? Colors.grey.shade900 : Colors.orange.shade50,
                      isDark ? Colors.grey.shade800 : Colors.white,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.qr_code_2_rounded,
                        color: Colors.orange,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      S.of(context).qrNotLinked,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      S.of(context).youCanLinkQrNow,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              Navigator.pop(dialogContext);
                              final url = Uri.parse(
                                'https://veticareapp.com/qr/',
                              );
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            icon: Icon(Icons.info_outline, size: 18),
                            label: Text(
                              S.of(context).learnHow,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ColorManager.primaryColor,
                              side: BorderSide(
                                color: ColorManager.primaryColor,
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              showDialog(
                                context: context,
                                builder:
                                    (ctx) => QrLinkDialog(
                                      pet: widget.pet,
                                      cubit: widget.qrCubit,
                                      isDarkMode: isDark,
                                    ),
                              );
                            },
                            icon: Icon(Icons.link, size: 18),
                            label: Text(
                              S.of(context).linkQr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? Colors.grey[800]!.withOpacity(0.9) : Colors.white,
              isDark
                  ? Colors.grey[850]!.withOpacity(0.8)
                  : Colors.grey[50]!.withOpacity(0.5),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withOpacity(0.3)
                      : ColorManager.primaryColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color:
                isDark
                    ? Colors.grey[700]!.withOpacity(0.3)
                    : Colors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap:
                widget.selectionMode
                    ? () => widget.onSelected(!widget.isSelected)
                    : () => _showPetDetailsBottomSheet(context),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
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
                          onChanged: (val) => widget.onSelected(val ?? false),
                          activeColor: Colors.transparent,
                          checkColor: Colors.white,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  _buildCompactPetImage(),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCompactPetInfo(context)),
                  if (!widget.selectionMode) ...[
                    // QR Status Camera Icon
                    InkWell(
                      onTap: () => _handleQrIconTap(context),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              (widget.pet.qrCode?.isNotEmpty == true)
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                (widget.pet.qrCode?.isNotEmpty == true)
                                    ? Colors.green
                                    : Colors.red,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          (widget.pet.qrCode?.isNotEmpty == true)
                              ? Icons.qr_code_scanner_rounded
                              : Icons.qr_code_scanner_rounded,
                          color:
                              (widget.pet.qrCode?.isNotEmpty == true)
                                  ? Colors.green
                                  : Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactPetImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
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
        // Gender icon at bottom-right
        Positioned(
          right: -5,
          bottom: -10,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _getGenderColor(),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(_getGenderIcon(), size: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactPetInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.pet.petName ?? '',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (widget.pet.breed != null)
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: ColorManager.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isArabic()
                        ? widget.pet.breed!.arBreed
                        : widget.pet.breed!.enBreed,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            if (widget.pet.birthdate?.isNotEmpty ?? false) ...[
              const SizedBox(width: 6),
              Text(
                _calculateAge(),
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _showPetDetailsBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: widget.cubit,
          child: BlocProvider.value(
            value: widget.qrCubit,
            child: DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.75,
              maxChildSize: 0.95,
              expand: false,
              snap: true,
              snapSizes: const [0.75, 0.95],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        isDark ? Colors.grey[900]! : Colors.grey[50]!,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Drag Handle
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              // Header with pet image, name, and edit icon
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            ColorManager.primaryColor
                                                .withOpacity(0.1),
                                            ColorManager.secondColor
                                                .withOpacity(0.1),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: ColorManager.primaryColor
                                              .withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(17),
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: Image.network(
                                            widget.pet.imageName
                                                        .toString()
                                                        .contains(
                                                          'PetAvatar',
                                                        ) ||
                                                    widget.pet.imageName
                                                        .toString()
                                                        .isEmpty
                                                ? 'https://img.freepik.com/free-vector/hand-drawn-animal-rescue-illustration_52683-109643.jpg'
                                                : '$imageUrl${widget.pet.imageName}',
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      ColorManager.primaryColor
                                                          .withOpacity(0.3),
                                                      ColorManager.secondColor
                                                          .withOpacity(0.3),
                                                    ],
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.pets,
                                                  color: Colors.white,
                                                  size: 32,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.pet.petName ?? '',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  isDark
                                                      ? Colors.white
                                                      : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          if (widget.pet.breed != null)
                                            Text(
                                              widget.pet.breed!.enBreed,
                                              style: TextStyle(
                                                color:
                                                    MainCubit.get(
                                                          context,
                                                        ).isDark
                                                        ? Colors.grey[400]
                                                        : Colors.grey[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // Edit icon button
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(bottomSheetContext);
                                        _navigateToEditPet(context);
                                      },
                                      icon: const Icon(Icons.edit_outlined),
                                      color: Colors.blue,
                                      iconSize: 28,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Pet Details
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildDetailCard(
                                            S.of(context).gender,
                                            _getGenderText(),
                                            _getGenderIcon(),
                                            _getGenderColor(),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        if (widget.pet.isSpayed != null)
                                          Expanded(
                                            child: _buildDetailCard(
                                              S.of(context).sterilization,
                                              widget.pet.isSpayed!
                                                  ? (S.of(context).spayed)
                                                  : (S.of(context).notSpayed),
                                              widget.pet.isSpayed!
                                                  ? Icons.health_and_safety
                                                  : Icons
                                                      .warning_amber_outlined,
                                              widget.pet.isSpayed!
                                                  ? Colors.green
                                                  : Colors.orange,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (widget.pet.birthdate?.isNotEmpty ??
                                        false)
                                      _buildDetailCard(
                                        S.of(context).birthdate,
                                        // "${widget.pet.birthdate!.substring(0, 10)} ${_calculateAge()}",
                                        widget.pet.birthdate!.substring(0, 10),
                                        Icons.cake_outlined,
                                        ColorManager.primaryColor,
                                      ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // QR Status
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).qrCodeStatus,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    QrStatusIndicator(pet: widget.pet),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // QR Action Buttons (styled like bottom nav bar)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                       isDark
                                            ? Colors.grey[850]
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: QrActionButtons(
                                    pet: widget.pet,
                                    petCubit: widget.cubit,
                                    c: widget.qrCubit,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Appointment Doctor Button - Moved here after QR status
                              if (!widget.selectionMode)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pop(bottomSheetContext);
                                        navigateToScreen(
                                          context,
                                          MySupplierScreen(
                                            petSelectFromIcon: widget.pet,
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        IconlyLight.calendar,
                                        size: 20,
                                      ),
                                      label: Text(
                                        S.of(context).appointmentDoctor,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorManager.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 20),

                              // Edit Button
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(bottomSheetContext);
                                      _navigateToEditPet(context);
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                    ),
                                    label: Text(
                                      S.of(context).editPet,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () => _showDeleteConfirmation(
                                          context,
                                          closeBottomSheet: true,
                                        ),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                    ),
                                    label: Text(
                                      S.of(context).deletePet,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:
            MainCubit.get(context).isDark
                ? Colors.grey[800]!.withOpacity(0.6)
                : Colors.white,
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color:
                      MainCubit.get(context).isDark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color:
                  MainCubit.get(context).isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGenderColor() {
    switch (widget.pet.gender) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData _getGenderIcon() {
    switch (widget.pet.gender) {
      case 1:
        return Icons.male;
      case 2:
        return Icons.female;
      default:
        return Icons.help_outline;
    }
  }

  String _getGenderText() {
    switch (widget.pet.gender) {
      case 1:
        return S.of(context).male;
      case 2:
        return S.of(context).female;
      default:
        return S.of(context).unknown;
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
        return "($years ${years == 1 ? S.of(context).year : S.of(context).years})";
      } else if (months > 0) {
        return "($months ${months == 1 ? S.of(context).month : S.of(context).months})";
      } else {
        final days = difference.inDays;
        return "($days ${days == 1 ? S.of(context).day : S.of(context).days})";
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

  void _showDeleteConfirmation(
    BuildContext context, {
    bool closeBottomSheet = false,
  }) {
    showCustomConfirmationDialog(
      context: context,
      description: Text.rich(
        TextSpan(
          text: S.of(context).deletePetConfirmation,
          children: [
            TextSpan(
              text: widget.pet.petName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '?'),
          ],
        ),
      ),
      imageUrl:
          'https://img.freepik.com/premium-vector/sad-dog_161669-74.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.2.131510781.1692744483&semt=ais',
      onConfirm: () async {
        Navigator.of(context).pop();
        await widget.cubit.deletePet(widget.pet.petId.toString());
        if (closeBottomSheet) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
