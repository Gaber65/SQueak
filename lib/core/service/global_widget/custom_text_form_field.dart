import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../utils/theme/fonts/font_styles.dart';
import '../global_function/format_utils.dart';
import '../main_service/presentation/controller/main_cubit/main_cubit.dart';

class MyTextForm extends StatefulWidget {

  const MyTextForm({
    super.key,
    required this.controller,
    required this.hintText,
     this.prefixIcon,
    this.obscureText,
    this.enable = false,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.validatorText,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final String? validatorText;
  final Widget? prefixIcon;
  final bool? obscureText;
  final int maxLines;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final GestureTapCallback? onTap;
  final bool enable;
  final bool enabled;

  @override
  State<MyTextForm> createState() => _MyTextFormState();
}

class _MyTextFormState extends State<MyTextForm> {
  String? _validatorText;
  bool _obscureText = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    // When losing focus, trim email inputs so UI reflects trimmed value
    if (!_focusNode.hasFocus) {
      try {
        final current = widget.controller.text;
        final trimmed = current.trim();
        if (current != trimmed) {
          widget.controller.text = trimmed;
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: trimmed.length),
          );
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _getTextDirection(context),
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: _obscureText,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        onTap: widget.onTap,
        onFieldSubmitted: widget.onFieldSubmitted,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardAppearance: MainCubit.get(context).isDark ? Brightness.dark : Brightness.light,
        style: FontStyleThame.textStyle(context: context, fontSize: 15),
        onChanged: (value) {
          widget.onChanged?.call(value);
          setState(() => _validatorText = null);
        },
        validator: (value) => _validateField(context, value),
        decoration: _buildInputDecoration(context),
      ),
    );
  }

  TextDirection _getTextDirection(BuildContext context) {
    if (widget.hintText == S.of(context).enterPhone) return TextDirection.ltr;
    return isArabic() ? TextDirection.rtl : TextDirection.ltr;
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    final isDark = MainCubit.get(context).isDark;
    return InputDecoration(
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.enable
          ? IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          size: 14,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      )
          : null,
      contentPadding: EdgeInsets.all(widget.maxLines != 1 ? 10 : 0),
      filled: true,
      fillColor: isDark ? Colors.black26 : Colors.grey.shade200,
      hintStyle: FontStyleThame.textStyle(
        context: context,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontColor: isDark ? Colors.white54 : const Color.fromRGBO(0, 0, 0, 0.3),
      ),
      counterStyle: FontStyleThame.textStyle(context: context, fontSize: 13),
      border: _borderStyle(),
      enabledBorder: _borderStyle(),
      focusedBorder: _borderStyle(),
      errorBorder: _borderStyle(),
      disabledBorder: _borderStyle(),
      focusedErrorBorder: _borderStyle(),
    );
  }

  OutlineInputBorder _borderStyle() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  );

  String? _validateField(BuildContext context, String? value) {
    final s = S.of(context);
    switch (widget.hintText) {
      case var hint when hint == s.enterUrEmail:
        return _validatorText ?? _validateEmail(value, s);
      case var hint when hint == s.comparePassword || hint == s.enterUrPassword || hint == s.password_hint:
        return _validatorText ?? _validatePassword(value, s);
      case var hint when hint == s.reminderOtherHintText:
        return _validatorText ?? _validateOther(value, s);
      default:
        return _validatorText ?? (value?.isEmpty == true ? widget.validatorText : null);
    }
  }

  String? _validateEmail(String? value, S s) {
    if (value == null || value.isEmpty) return s.email_valid;
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(value) ? null : s.email_validation;
  }

  String? _validatePassword(String? value, S s) {
    if (value == null || value.isEmpty) return s.enterUrPassword;
    if (value.length <= 6) return s.PASSWORD_MIN_LENGTH;
    return null;
  }

  String? _validateOther(String? value, S s) {
    if (value == null || value.isEmpty) return s.other_valid;
    if (value.length > 30) return s.other_valid_more_than_30_char;
    return null;
  }

  @override
  void dispose() {
    try {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    } catch (_) {}
    super.dispose();
  }
}
