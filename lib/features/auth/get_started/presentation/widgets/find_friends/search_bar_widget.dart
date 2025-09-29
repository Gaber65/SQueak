// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged; 
  final VoidCallback? onClear;
  final String specieId; 

  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    required this.specieId, 
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search pets, breeds...',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.white70 : Colors.black54,
            size: 22,
          ),
          suffixIcon:
              (controller != null && controller!.text.isNotEmpty)
                  ? IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                    onPressed: () {
                      controller?.clear();
                      if (onClear != null) onClear!();
                      // Optionally trigger search with empty string on clear
                      if (onChanged != null) onChanged!('');
                    },
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
