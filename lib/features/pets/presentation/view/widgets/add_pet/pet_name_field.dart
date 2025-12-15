import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';

class PetNameField extends StatefulWidget {
  const PetNameField({super.key, required this.cubit, required this.isDark});

  final PetCubit cubit;
  final bool isDark;

  @override
  State<PetNameField> createState() => _PetNameFieldState();
}

class _PetNameFieldState extends State<PetNameField> {
  bool _isFilled = false;
  bool _showError = false;

  String get _errorText =>
      isArabic() ? "من فضلك ادخل الاسم الاليف" : "Please enter a pet name";

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    final controller = widget.cubit.petNameController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          "${S.of(context).petName} *",
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: isArabic() ? 'ادخل الاسم الاليف' : 'Enter pet name',
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            enabledBorder: _border(
              _isFilled
                  ? Colors.blue
                  : (_showError ? Colors.red : Colors.grey.shade400),
            ),
            focusedBorder: _border(Colors.blue),
          ),
          onChanged: (value) {
            setState(() {
              _isFilled = value.isNotEmpty;
              if (_isFilled) _showError = false;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              setState(() => _showError = true);
              return _errorText;
            }
            return null;
          },
        ),

        // Show error only after validation
        if (_showError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
