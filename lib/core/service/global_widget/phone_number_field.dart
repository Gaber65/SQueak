import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onChanged;
  final bool isValid;
  final String hintText;

  const PhoneNumberField({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.isValid = false,
    this.hintText = 'Enter phone number',
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  bool _hasValidInput = false;

  @override
  void initState() {
    super.initState();
    _hasValidInput = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (_hasValidInput != hasText) {
      setState(() {
        _hasValidInput = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      onChanged: (value) {
        _onTextChanged();
        widget.onChanged?.call();
      },
      style: const TextStyle(height: 1.0), // Ensure consistent height
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(
          Icons.phone_outlined,
          size: 18,
        ),
        suffixIcon: _hasValidInput && widget.isValid
            ? const Icon(
                Icons.check_circle,
                color: ColorManager.green,
                size: 16,
              )
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18, // Adjusted for better vertical centering
        ),
        isDense: true, // Reduces the height of the input field
      ),
    );
  }
}
