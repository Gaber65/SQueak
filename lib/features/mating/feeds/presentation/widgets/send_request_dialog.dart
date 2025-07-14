import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/features/mating/feeds/domain/entities/pet_mating_model.dart';

class SendRequestDialog extends StatefulWidget {
  final PetMating targetPet;
  final bool isDarkMode;

  const SendRequestDialog({
    super.key,
    required this.targetPet,
    this.isDarkMode = false,
  });

  @override
  State<SendRequestDialog> createState() => _SendRequestDialogState();
}

class _SendRequestDialogState extends State<SendRequestDialog>
    with TickerProviderStateMixin {
  final _messageController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late AnimationController _heartController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _heartAnimation;

  // Enhanced Dark Mode Colors
  Color get _backgroundColor => widget.isDarkMode
      ? Colors.grey.shade900
      : Colors.white;

  Color get _surfaceColor => widget.isDarkMode
      ? Colors.grey.shade800
      : Colors.grey.shade50;

  Color get _cardColor => widget.isDarkMode
      ? Colors.grey.shade800
      : Colors.white;

  Color get _borderColor => widget.isDarkMode
      ? Colors.grey.shade700
      : Colors.grey.shade200;

  Color get _textPrimaryColor => widget.isDarkMode
      ? Colors.white
      : Colors.black87;

  Color get _textSecondaryColor => widget.isDarkMode
      ? Colors.grey.shade400
      : Colors.grey.shade600;

  Color get _hintColor => widget.isDarkMode
      ? Colors.grey.shade500
      : Colors.grey.shade500;

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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _heartAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));

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
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
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
                      Colors.white,
                      Colors.blue.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: widget.isDarkMode
                        ? Colors.grey.shade700.withOpacity(0.5)
                        : Colors.blue.shade100,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode
                          ? Colors.black.withOpacity(0.6)
                          : Colors.blue.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEnhancedContent(),
                    _buildEnhancedActions(),
                  ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTargetPetCard(),
          const SizedBox(height: 24),
          _buildMessageSection(),
        ],
      ),
    );
  }

  Widget _buildTargetPetCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [
            Colors.grey.shade800,
            Colors.grey.shade800,
          ]
              : [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.grey.shade700
              : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade300,
                  Colors.purple.shade300,
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.targetPet.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
                      child: Text(
                        widget.targetPet.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.targetPet.breed} • ${widget.targetPet.age}',
                    style: TextStyle(
                      color: _textSecondaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: Colors.blue.shade400,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.message_rounded,
              size: 20,
              color: Colors.purple.shade400,
            ),
            const SizedBox(width: 8),
            Text(
              'Message (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? Colors.grey.shade800
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _messageController.text.isNotEmpty
                  ? Colors.purple.shade300
                  : _borderColor,
              width: _messageController.text.isNotEmpty ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: _messageController,
            style: TextStyle(color: _textPrimaryColor),
            decoration: InputDecoration(
              hintText: 'Write a message to introduce your pet...',
              hintStyle: TextStyle(color: _hintColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterStyle: TextStyle(color: _textSecondaryColor),
            ),
            maxLines: 4,
            maxLength: 200,
            onChanged: (value) => setState(() {}),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? Colors.blue.shade900.withOpacity(0.2)
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isDarkMode
                  ? Colors.blue.shade700.withOpacity(0.3)
                  : Colors.blue.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: widget.isDarkMode
                    ? Colors.blue.shade300
                    : Colors.blue.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'A friendly message increases your chances of a positive response!',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isDarkMode
                        ? Colors.blue.shade300
                        : Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [
            Colors.grey.shade900.withOpacity(0.3),
            Colors.grey.shade800.withOpacity(0.7),
          ]
              : [
            Colors.grey.shade50,
            Colors.blue.shade50,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: widget.isDarkMode
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
                border: Border.all(
                  color: _borderColor,
                  width: 2,
                ),
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
                          'Cancel',
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
                  colors: _isLoading
                      ? [Colors.grey.shade400, Colors.grey.shade500]
                      : [
                    Colors.blue.shade400,
                    Colors.blue.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isLoading
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
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else ...[
                          const Icon(
                            Icons.favorite_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Send Request',
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
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Mating request sent to ${widget.targetPet.name}! 💕',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heartController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

// Usage functions
void showBeautifulSendRequestDialog(
    BuildContext context,
    PetMating targetPet, {
      bool isDarkMode = false,
    }) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: isDarkMode ? Colors.black87 : Colors.black54,
    builder: (context) => SendRequestDialog(
      targetPet: targetPet,
      isDarkMode: isDarkMode,
    ),
  );
}

// Auto-detect theme version
void showThemeAwareSendRequestDialog(
    BuildContext context,
    PetMating targetPet,
    ) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showBeautifulSendRequestDialog(context, targetPet, isDarkMode: isDark);
}
