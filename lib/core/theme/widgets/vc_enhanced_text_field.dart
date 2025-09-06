import 'package:flutter/material.dart';
import 'package:squeak/core/auth/enhanced_auth_validator.dart';

/// Enhanced text field with real-time validation and better UX
class VcEnhancedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValidationResult Function(String)? validator;
  final VoidCallback? onValidationChanged;
  final bool showValidationIcon;
  final bool enableRealTimeValidation;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final bool enabled;
  final Function(String)? onChanged;

  const VcEnhancedTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onValidationChanged,
    this.showValidationIcon = true,
    this.enableRealTimeValidation = true,
    this.contentPadding,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<VcEnhancedTextField> createState() => _VcEnhancedTextFieldState();
}

class _VcEnhancedTextFieldState extends State<VcEnhancedTextField> 
    with SingleTickerProviderStateMixin {
  ValidationResult? _validationResult;
  late AnimationController _validationAnimationController;
  late Animation<double> _validationAnimation;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _validationAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _validationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _validationAnimationController,
      curve: Curves.easeInOut,
    ));

    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _validationAnimationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!widget.enableRealTimeValidation || !_hasInteracted) return;
    
    setState(() {
      _validationResult = widget.validator?.call(widget.controller.text);
    });
    
    if (_validationResult != null) {
      _validationAnimationController.forward();
      widget.onValidationChanged?.call();
    }
  }

  void _onFieldInteraction() {
    if (!_hasInteracted) {
      setState(() {
        _hasInteracted = true;
      });
    }
  }

  Color _getBorderColor() {
    if (_validationResult == null) return Colors.grey[300]!;
    
    switch (_validationResult!.severity) {
      case ValidationSeverity.success:
        return Colors.green;
      case ValidationSeverity.warning:
        return Colors.orange;
      case ValidationSeverity.error:
        return Colors.red;
      default:
        return Colors.grey[300]!;
    }
  }

  Widget? _buildValidationIcon() {
    if (!widget.showValidationIcon || _validationResult == null) return null;
    
    IconData iconData;
    Color iconColor;
    
    switch (_validationResult!.severity) {
      case ValidationSeverity.success:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case ValidationSeverity.warning:
        iconData = Icons.warning;
        iconColor = Colors.orange;
        break;
      case ValidationSeverity.error:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.info;
        iconColor = Colors.blue;
    }
    
    return AnimatedBuilder(
      animation: _validationAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _validationAnimation.value,
          child: Icon(
            iconData,
            color: iconColor,
            size: 20,
          ),
        );
      },
    );
  }

  Widget? _buildValidationMessage() {
    if (_validationResult == null || !_hasInteracted) return null;
    
    return AnimatedBuilder(
      animation: _validationAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _validationAnimation.value,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _validationResult!.message,
              style: TextStyle(
                fontSize: 12,
                color: _getBorderColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getBorderColor(),
              width: _validationResult != null ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            onTap: _onFieldInteraction,
            onChanged: (value) {
              _onFieldInteraction();
              widget.onChanged?.call(value);
            },
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon ?? _buildValidationIcon(),
              border: InputBorder.none,
              contentPadding: widget.contentPadding ?? 
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              labelStyle: TextStyle(
                color: _getBorderColor(),
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        if (_buildValidationMessage() != null) _buildValidationMessage()!,
      ],
    );
  }
}
