import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_avatar.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../domain/entities/mating_request_entity.dart';
import '../../domain/usecases/mating_parameters.dart';

class SendRequestDialog extends StatefulWidget {
  final PetEntities targetPet;
  final String senderPetId;
  final bool isDarkMode;
  final MatingFeedsCubit cubit;

  const SendRequestDialog({
    super.key,
    required this.targetPet,
    required this.cubit,
    required this.senderPetId,
    this.isDarkMode = false,
  });

  @override
  State<SendRequestDialog> createState() => _SendRequestDialogState();
}

class _SendRequestDialogState extends State<SendRequestDialog>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late AnimationController _heartController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _heartAnimation;

  // Enhanced Dark Mode Colors
  Color get _borderColor =>
      widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200;

  Color get _textPrimaryColor =>
      widget.isDarkMode ? Colors.white : Colors.black87;

  Color get _textSecondaryColor =>
      widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _heartAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _heartController.repeat(reverse: true);
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
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
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
                            : [Colors.white, Colors.blue.shade50],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color:
                        widget.isDarkMode
                            ? Colors.grey.shade700.withOpacity(0.5)
                            : Colors.blue.shade100,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          widget.isDarkMode
                              ? Colors.black.withOpacity(0.6)
                              : Colors.blue.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [_buildEnhancedContent(), _buildEnhancedActions()],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Lovely Animated Heart Container
          ScaleTransition(
            scale: _heartAnimation,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent.shade100, Colors.pink.shade400],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Lovely Title
          Text(
            S.of(context).sendLovelyRequestTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            S
                .of(context)
                .sendLovelyRequestSubtitle(widget.targetPet.petName ?? ''),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: _textSecondaryColor),
          ),
          const SizedBox(height: 24),

          // Pet Info Card (already beautiful)
          _buildTargetPetCard(),
        ],
      ),
    );
  }

  Widget _buildTargetPetCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              widget.isDarkMode
                  ? [Colors.grey.shade800, Colors.grey.shade800]
                  : [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                widget.isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          PetAvatar(pet: widget.targetPet, isDarkMode: widget.isDarkMode),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pets_rounded,
                      size: 16,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.targetPet.petName!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _textPrimaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Age / Breed pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            widget.isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (widget.targetPet.birthdate != null &&
                                widget.targetPet.birthdate != '')
                            ? "${formatAge(DateTime.parse(widget.targetPet.birthdate!.substring(0, 10)))}${widget.targetPet.breed?.enBreed != null ? " • ${widget.targetPet.breed!.enBreed}" : ""}"
                            : widget.targetPet.breed?.enBreed ?? "",
                        style: TextStyle(
                          color: _textSecondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                if (widget.targetPet.gender != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          widget.isDarkMode
                              ? Colors.grey.shade800
                              : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            widget.targetPet.gender == 1
                                ? Colors.blue.shade100
                                : Colors.pink.shade100,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            widget.isDarkMode ? 0.15 : 0.03,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.targetPet.gender == 1
                              ? Icons.male
                              : Icons.female,
                          size: 14,
                          color:
                              widget.targetPet.gender == 1
                                  ? Colors.blue
                                  : Colors.pink,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.targetPet.gender == 1
                              ? S.of(context).male
                              : S.of(context).female,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              widget.isDarkMode
                  ? [
                    Colors.grey.shade900.withOpacity(0.3),
                    Colors.grey.shade800.withOpacity(0.7),
                  ]
                  : [Colors.grey.shade50, Colors.blue.shade50],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color:
                widget.isDarkMode
                    ? Colors.grey.shade700.withOpacity(0.5)
                    : Colors.blue.shade100,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: _borderColor, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: _textSecondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).cancel,
                          style: TextStyle(
                            color: _textSecondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      _isLoading
                          ? [Colors.grey.shade400, Colors.grey.shade500]
                          : [Colors.blue.shade400, Colors.blue.shade400],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow:
                    _isLoading
                        ? null
                        : [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading ? null : () => _sendRequest(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        else ...[
                          const Icon(
                            Icons.favorite_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            S.of(context).sendRequest,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendRequest(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      final result = await widget.cubit.sendMatingRequest(
        SendMatingRequestParameters(
          message: '',
          senderPetId: widget.senderPetId,
          targetPetId: widget.targetPet.petId!,
        ),
      );

      result.fold(
        (errorMessage) {
          Navigator.pop(context, false);
          errorToast(context, errorMessage);
        },
        (status) {
          if (status == MatingRequestStatus.success) {
            Navigator.pop(context, true);
            successToast(
              context,
              'Mating request sent to ${widget.targetPet.petName}! 💕',
            );
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heartController.dispose();
    super.dispose();
  }
}
