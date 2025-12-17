import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Modern Material 3 text field component for Squeak app
class VcTextField extends StatefulWidget {
  const VcTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.debounceMs = 300,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final int debounceMs;

  /// Factory for search text field
  factory VcTextField.search({
    Key? key,
    TextEditingController? controller,
    String? hintText = 'Search...',
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onClear,
    bool autofocus = false,
  }) {
    return VcTextField(
      key: key,
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      prefixIcon: const Icon(Icons.search),
      suffixIcon:
          controller?.text.isNotEmpty == true
              ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
              : null,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      autofocus: autofocus,
      debounceMs: 250,
    );
  }

  /// Factory for password text field
  static Widget password({
    Key? key,
    TextEditingController? controller,
    String? labelText = 'Password',
    String? hintText,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? Function(String?)? validator,
    bool autofocus = false,
  }) {
    return _VcPasswordTextField(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      autofocus: autofocus,
    );
  }

  /// Factory for multiline text field
  factory VcTextField.multiline({
    Key? key,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    int maxLines = 4,
    int? minLines = 2,
    int? maxLength,
  }) {
    return VcTextField(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  @override
  State<VcTextField> createState() => _VcTextFieldState();
}

class _VcTextFieldState extends State<VcTextField> {
  Timer? _debounceTimer;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (widget.onChanged == null) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: widget.debounceMs), () {
      widget.onChanged!(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          textCapitalization: widget.textCapitalization,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            counter: widget.maxLength != null ? null : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

/// Internal password text field with visibility toggle
class _VcPasswordTextField extends StatefulWidget {
  const _VcPasswordTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final bool autofocus;

  @override
  State<_VcPasswordTextField> createState() => _VcPasswordTextFieldState();
}

class _VcPasswordTextFieldState extends State<_VcPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return VcTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      obscureText: _obscureText,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () => setState(() => _obscureText = !_obscureText),
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      ),
      debounceMs: 0, // No debounce for password fields
    );
  }
}

/// Specialized text field for pet-related inputs
class VcPetTextField extends StatelessWidget {
  const VcPetTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.petType,
    this.onChanged,
    this.validator,
    this.helpTooltip,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final PetType? petType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? helpTooltip;

  @override
  Widget build(BuildContext context) {
    return VcTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      validator: validator,
      prefixIcon: petType != null ? Icon(_getPetIcon(petType!)) : null,
      suffixIcon:
          helpTooltip != null
              ? Tooltip(
                message: helpTooltip!,
                child: const Icon(Icons.help_outline, size: 20),
              )
              : null,
    );
  }

  IconData _getPetIcon(PetType type) {
    switch (type) {
      case PetType.dog:
        return Icons.pets;
      case PetType.cat:
        return Icons.pets;
      case PetType.bird:
        return Icons.air;
      case PetType.fish:
        return Icons.water;
      case PetType.rabbit:
        return Icons.pets;
      case PetType.other:
        return Icons.pets;
    }
  }
}

/// Pet type enum for specialized inputs
enum PetType { dog, cat, bird, fish, rabbit, other }
