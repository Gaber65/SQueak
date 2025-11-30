import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



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
  });
  TextEditingController controller;
  String hintText;
  Widget prefixIcon;
  bool? obscureText;
  Function(String)? onChanged;
  bool? enable;
  bool? enabled;
  @override
  State<MyTextForm> createState() => _MyTextFormState();
}

class _MyTextFormState extends State<MyTextForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText ?? false,
        onChanged: widget.onChanged,
        enabled: widget.enabled ?? true,
        validator: (value) {
          return '';
        },

        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.enable!
              ? IconButton(
                  onPressed: () {
                    widget.obscureText = !widget.obscureText!;
                    setState(() {});
                  },
                  icon: Icon(
                    widget.obscureText!
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 14,
                  ),
                )
              : null,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}

Widget myBottom(Widget widget) {
  return Container(
    width: double.infinity,
    height: 52,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadiusDirectional.circular(12),
    ),
    child: Center(
      child: widget,
    ),
  );
}
