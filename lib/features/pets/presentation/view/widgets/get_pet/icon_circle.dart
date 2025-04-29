import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class IconCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const IconCircle({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: MainCubit.get(context).isDark
          ? ColorManager.myPetsBaseBlackColor
          : Colors.green.shade100.withOpacity(.4),
      child: IconButton(
        icon: Icon(icon),
        color: MainCubit.get(context).isDark ? Colors.white : Colors.black,
        onPressed: onPressed,
        iconSize: 20,
      ),
    );
  }
}