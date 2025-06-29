import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/service/global_function/format_utils.dart';
import '../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../controller/qr_cubit.dart';
import '../../../pets/domain/entities/pet_entity.dart';

class QrUnlinkDialog extends StatefulWidget {
  final PetEntities pet;
  final QrCubit cubit;
  final bool isDarkMode;

  const QrUnlinkDialog({
    super.key,
    required this.pet,
    required this.cubit,
    this.isDarkMode = false,
  });

  @override
  State<QrUnlinkDialog> createState() => _QrUnlinkDialogState();
}

class _QrUnlinkDialogState extends State<QrUnlinkDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _shakeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeAnimation;
  bool _isUnlinking = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

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
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 24,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        widget.isDarkMode
                            ? [
                              Colors.grey.shade900,
                              Colors.grey.shade800,
                              Colors.grey.shade900,
                            ]
                            : [
                              Colors.red.shade50.withOpacity(0.3),
                              Colors.white,
                              Colors.orange.shade50.withOpacity(0.5),
                            ],
                  ),
                  border:
                      widget.isDarkMode
                          ? Border.all(color: Colors.grey.shade700, width: 1)
                          : Border.all(color: Colors.red.shade100, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color:
                          widget.isDarkMode
                              ? Colors.black.withOpacity(0.4)
                              : Colors.red.shade200.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildWarningIcon(),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    _buildWarningMessage(),
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade400, Colors.red.shade600],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(IconlyBold.delete, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic() ? 'إلغاء ربط رمز QR' : 'Unlink QR Code',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      widget.isDarkMode
                          ? Colors.red.shade900.withOpacity(0.3)
                          : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isArabic() ? 'تحذير' : 'Warning',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        widget.isDarkMode
                            ? Colors.red.shade300
                            : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
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
          splashRadius: 22,
        ),
      ],
    );
  }

  Widget _buildWarningIcon() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value * 10 * (1 - _shakeAnimation.value),
            0,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade100, Colors.orange.shade100],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color:
                      widget.isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.red.shade200.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.link_off_rounded,
              size: 64,
              color: Colors.red.shade600,
            ),
          ),
        );
      },
    );
  }



  Widget _buildWarningMessage() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            widget.isDarkMode
                ? Colors.red.shade900.withOpacity(0.2)
                : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDarkMode ? Colors.red.shade800 : Colors.red.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color:
                    widget.isDarkMode
                        ? Colors.orange.shade300
                        : Colors.orange.shade600,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isArabic()
                      ? 'هل أنت متأكد من أنك تريد إلغاء ربط ${widget.pet.petName} من رمز QR الخاص به؟'
                      : 'Are you sure you want to unlink ${widget.pet.petName} from its QR code?',
                  style: TextStyle(
                    fontSize: 15,
                    color:
                        widget.isDarkMode
                            ? Colors.red.shade300
                            : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  widget.isDarkMode
                      ? Colors.red.shade800.withOpacity(0.3)
                      : Colors.red.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color:
                      widget.isDarkMode
                          ? Colors.red.shade300
                          : Colors.red.shade600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isArabic()
                        ? 'لن يتمكن الآخرون من العثور على معلومات الأليف عبر رمز QR'
                        : 'Others won\'t be able to find pet information via QR code',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          widget.isDarkMode
                              ? Colors.red.shade300
                              : Colors.red.shade600,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isUnlinking ? null : () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 18),
            label: Text(isArabic() ? 'إلغاء' : 'Cancel'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(
                color:
                    widget.isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
              ),
              foregroundColor:
                  widget.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.grey.shade700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade500, Colors.red.shade600],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isUnlinking ? null : _handleUnlink,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isUnlinking)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      else
                        const Icon(
                          IconlyBold.delete,
                          size: 18,
                          color: Colors.white,
                        ),
                      const SizedBox(width: 10),
                      Text(
                        _isUnlinking
                            ? (isArabic() ? 'جاري الإلغاء...' : 'Unlinking...')
                            : (isArabic() ? 'إلغاء الربط' : 'Unlink'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
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

  Future<void> _handleUnlink() async {
    setState(() {
      _isUnlinking = true;
    });

    // Add shake animation for dramatic effect
    _shakeController.forward();

    try {
      // Simulate processing time
      await Future.delayed(const Duration(milliseconds: 800));

      // Perform the actual unlink
      widget.cubit.unlinkPetFromQr(widget.pet.petId, widget.pet.qrCodeId!);

      // Close dialog
      if (mounted) {
        Navigator.pop(context);

        // Show success feedbac
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUnlinking = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }
}
