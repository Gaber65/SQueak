import 'package:flutter/material.dart';
import 'icon_container.dart';

/// Reusable popup menu item with icon and text
class MenuItemWidget extends PopupMenuItem<String> {
  MenuItemWidget({
    super.key,
    required IconData icon,
    required Color iconColor,
    required String text,
    required String value,
  }) : super(
         value: value,
         child: Container(
           padding: const EdgeInsets.symmetric(vertical: 8),
           child: Row(
             children: [
               IconContainer(
                 icon: icon,
                 iconColor: iconColor,
                 size: 32,
                 iconSize: 20,
                 padding: 6,
               ),
               const SizedBox(width: 12),
               Text(
                 text,
                 style: const TextStyle(
                   fontWeight: FontWeight.w500,
                   fontSize: 14,
                 ),
               ),
             ],
           ),
         ),
       );
}
