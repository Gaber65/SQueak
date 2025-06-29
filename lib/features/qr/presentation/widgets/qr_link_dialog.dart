import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/service/global_function/format_utils.dart';
import '../../../../core/service/global_widget/custom_text_form_field.dart';
import '../../../../core/service/global_widget/toast.dart';
import '../../../../core/service/service_locator/service_locator.dart';
import '../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../../pets/presentation/controller/pet_cubit.dart';
import '../controller/qr_cubit.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../view/new_scanner.dart';

class QrLinkDialog extends StatefulWidget {
  final PetEntities pet;
  final QrCubit cubit;
  final bool isDarkMode;

  const QrLinkDialog({
    super.key,
    required this.pet,
    required this.cubit,
    this.isDarkMode = false,
  });

  @override
  State<QrLinkDialog> createState() => _QrLinkDialogState();
}

class _QrLinkDialogState extends State<QrLinkDialog> with TickerProviderStateMixin {
  final TextEditingController qrController = TextEditingController();
  bool isScanning = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 16,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isDarkMode
                        ? [
                      Colors.grey.shade900,
                      Colors.grey.shade800,
                      Colors.grey.shade900,
                    ]
                        : [
                      ColorManager.primaryColor.withOpacity(0.05),
                      Colors.white,
                      Colors.blue.shade50,
                    ],
                  ),
                  border: widget.isDarkMode
                      ? Border.all(
                    color: Colors.grey.shade700,
                    width: 1,
                  )
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildQrIcon(),
                    const SizedBox(height: 20),
                    _buildDescription(),
                    const SizedBox(height: 24),
                    _buildQrInputSection(),
                    const SizedBox(height: 32),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? ColorManager.primaryColor.withOpacity(0.2)
                : ColorManager.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.link,
            color: ColorManager.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic() ? 'ربط رمز QR' : 'Link QR Code',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isArabic() ? "الأليف" : "Pet"}: ${widget.pet.petName}',
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close_rounded,
            color: widget.isDarkMode ? Colors.grey.shade400 : Colors.grey,
          ),
          splashRadius: 20,
        ),
      ],
    );
  }

  Widget _buildQrIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.grey.shade800
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.qr_code_2_rounded,
        size: 80,
        color: ColorManager.primaryColor,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.grey.shade800.withOpacity(0.5)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.grey.shade700
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: widget.isDarkMode
                ? Colors.blue.shade300
                : Colors.blue.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isArabic()
                  ? 'اربط الأليف الخاص بك برمز QR عن طريق مسحه '
                  : 'Link your pet to a QR code by scanning it ',
              style: TextStyle(
                fontSize: 13,
                color: widget.isDarkMode
                    ? Colors.grey.shade300
                    : Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.grey.shade800
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.grey.shade700
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic() ? 'رمز QR' : 'QR Code',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? Colors.grey.shade900
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: qrController.text.isNotEmpty
                          ? ColorManager.primaryColor
                          : (widget.isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade300),
                    ),
                  ),
                  child: TextField(
                    controller: qrController,
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      enabled:false,
                      hintText: isArabic()
                          ? 'أدخل معرف رمز QR'
                          : 'Enter QR code ID',
                      hintStyle: TextStyle(
                        color: widget.isDarkMode
                            ? Colors.grey.shade500
                            : Colors.grey.shade500,
                      ),
                      prefixIcon: Icon(
                        Icons.qr_code_2_rounded,
                        color: widget.isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildScanButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor,
            ColorManager.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
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
          onTap: isScanning ? null : _simulateScan,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: isScanning
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Icon(
              IconlyBold.camera,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 18),
            label: Text(isArabic() ? 'إلغاء' : 'Cancel'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: widget.isDarkMode
                    ? Colors.grey.shade600
                    : Colors.grey.shade300,
              ),
              foregroundColor: widget.isDarkMode
                  ? Colors.grey.shade300
                  : Colors.grey.shade700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: qrController.text.isNotEmpty
                  ? LinearGradient(
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor.withOpacity(0.8),
                ],
              )
                  : null,
              color: qrController.text.isEmpty
                  ? (widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300)
                  : null,
              borderRadius: BorderRadius.circular(12),
              boxShadow: qrController.text.isNotEmpty
                  ? [
                BoxShadow(
                  color: ColorManager.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: qrController.text.isNotEmpty
                    ? () => _linkQr(widget.cubit)
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.link,
                        size: 18,
                        color: qrController.text.isNotEmpty
                            ? Colors.white
                            : (widget.isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isArabic() ? 'ربط رمز QR' : 'Link QR Code',
                        style: TextStyle(
                          color: qrController.text.isNotEmpty
                              ? Colors.white
                              : (widget.isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500),
                          fontWeight: FontWeight.w600,
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
    );
  }

  Future<void> _simulateScan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        qrController.text = result;
      });
    }
  }

  void _linkQr(QrCubit cubit) {
    cubit.linkPetToQr(widget.pet.petId, qrController.text);
  }
  @override
  void dispose() {
    _animationController.dispose();
    qrController.dispose();
    super.dispose();
  }
}

