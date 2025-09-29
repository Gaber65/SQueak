import 'package:flutter/material.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';

class AddPetAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AddPetAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Add Your Pet", style: TextStyle(color: Colors.white)),
      backgroundColor: ColorManager.editScreenTextFieldBaseColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}