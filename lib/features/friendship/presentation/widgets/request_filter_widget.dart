import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

class RequestFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final int sentCount;
  final int receivedCount;

  const RequestFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.sentCount,
    required this.receivedCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FilterButton(
              label: isArabic() ? 'الطلبات المعلقة' : 'Received',
              count: receivedCount,
              isSelected: selectedFilter == 'received',
              onTap:
                  () => context.read<PetFriendsCubit>().changeRequestFilter(
                    'received',
                  ),
              selectedColor: selectedColor,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _FilterButton(
              label: isArabic() ? 'الطلبات المرسلة' : 'Sent',
              count: sentCount,
              isSelected: selectedFilter == 'sent',
              onTap:
                  () => context.read<PetFriendsCubit>().changeRequestFilter(
                    'sent',
                  ),
              selectedColor: selectedColor,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final bool isDark;

  const _FilterButton({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? selectedColor
                  : (isDark ? Colors.grey[850] : Colors.white),
          borderRadius: BorderRadius.circular(10),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.grey[700]),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Colors.white.withOpacity(0.25)
                        : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color:
                      isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.grey[700]),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
