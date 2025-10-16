// status_filter_item.dart
import 'package:flutter/material.dart';

import '../../../../../core/utils/theme/color_mangment/color_manager.dart';

class StatusFilterItem extends StatelessWidget {
  final String title;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const StatusFilterItem({
    super.key,
    required this.title,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isActive
                  ? LinearGradient(
                colors: [ColorManager.primaryColor,ColorManager.primaryColor.withOpacity(0.4)],
              )
                  : null,
              color: isActive ? null : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive ? ColorManager.primaryColor : Colors.grey[300]!,
                width: isActive ? 0 : 1,
              ),
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: ColorManager.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
                  : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTitle(title),
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : ColorManager.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: isActive ? ColorManager.primaryColor : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTitle(String title) {
    final emojis = {
      'All': '🐕',
      'active': '💬',
      'onMating': '❤️',
      'completed': '✅',
      'blocked': '🚫',
    };

    final formattedTitle = title == 'active' ? 'Active'
        : title == 'onMating' ? 'On Mating'
        : title[0].toUpperCase() + title.substring(1);

    return '${emojis[title] ?? ''} $formattedTitle';
  }
}