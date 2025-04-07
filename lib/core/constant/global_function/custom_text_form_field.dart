import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../helper/build_service/main_cubit/main_cubit.dart';
import '../../thames/styles.dart';
import 'global_function.dart';

class MyTextForm extends StatefulWidget {
  MyTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText,
    this.enable,
    this.enabled,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.validatorText,
    this.keyboardType,
    this.maxLines = 1,
  });

  TextInputType? keyboardType;
  TextEditingController controller;
  String hintText;
  String? validatorText;
  Widget prefixIcon;
  bool? obscureText;
  int? maxLines;
  Function(String)? onChanged;
  Function(String)? onFieldSubmitted;
  bool? enable;
  bool? enabled;
  GestureTapCallback? onTap;

  @override
  State<MyTextForm> createState() => _MyTextFormState();
}

class _MyTextFormState extends State<MyTextForm> {
  String? _validatorText; // State variable to track validation error

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enterUrPassword;
    }
    if (value.length < 6) {
      return S.of(context).PASSWORD_MIN_LENGTH;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.hintText == S.of(context).enterPhone
          ? TextDirection.ltr
          : isArabic()
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: TextFormField(
        onTap: widget.onTap,
        controller: widget.controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: widget.obscureText ?? false,
        onChanged: (value) {
          widget.onChanged?.call(value); // Call the passed onChanged if any
          // Reset validation message when user starts typing
          setState(() {
            _validatorText = null;
          });
        },
        enabled: widget.enabled ?? true,
        validator: (value) {
          if (S.of(context).enterUrEmail == widget.hintText) {
            return _validatorText ?? _validateEmail(value);
          } else if (S.of(context).comparePassword == widget.hintText ||
              S.of(context).enterUrPassword == widget.hintText ||
              S.of(context).password_hint == widget.hintText) {
            return _validatorText ?? _validatePassword(value);
          } else if (S.of(context).reminderOtherHintText == widget.hintText) {
            return _validatorText ?? _validateOtherTextField(value);
          }
          {
            return _validatorText ??
                (value!.isEmpty ? widget.validatorText : null);
          }
        },
        style: FontStyleThame.textStyle(
          context: context,
          fontSize: 15,
        ),
        keyboardAppearance:
            MainCubit.get(context).isDark ? Brightness.dark : Brightness.light,
        onFieldSubmitted: widget.onFieldSubmitted,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        decoration: buildInputDecoration(context),
      ),
    );
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.enable!
          ? IconButton(
              onPressed: () {
                widget.obscureText = !widget.obscureText!;
                setState(() {});
              },
              icon: Icon(
                widget.obscureText! ? Icons.visibility : Icons.visibility_off,
                size: 14,
              ),
            )
          : null,
      contentPadding: EdgeInsets.all(widget.maxLines != 1 ? 10 : 0),
      filled: true,
      counterStyle: FontStyleThame.textStyle(
        context: context,
        fontSize: 13,
      ),
      hintStyle: FontStyleThame.textStyle(
          context: context,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontColor: MainCubit.get(context).isDark
              ? Colors.white54
              : Color.fromRGBO(0, 0, 0, .3)),
      fillColor:
          MainCubit.get(context).isDark ? Colors.black26 : Colors.grey.shade200,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusColor: Colors.grey.shade200,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).email_valid;
    }
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return S.of(context).email_validation;
    } else {
      return null;
    }
  }

  String? _validateOtherTextField(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).other_valid;
    }
    if (value.length > 30) {
      return S.of(context).other_valid_more_than_30_char;
    }
    return null;
  }
}
