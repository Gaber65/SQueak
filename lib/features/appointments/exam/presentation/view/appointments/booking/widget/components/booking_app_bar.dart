// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

class BookingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookingAppBar({
    super.key,
    required this.isLoading,
    required this.onBookingPressed,
  });

  final bool isLoading;
  final VoidCallback onBookingPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(S.of(context).startAppointment),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 100,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorManager.primaryColor.withOpacity(.2),
              ),
              onPressed: isLoading ? null : onBookingPressed,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                S.of(context).booking,
                style: FontStyleThame.textStyle(
                  context: context,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontColor: ColorManager.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}