import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

class BlockUserDialog extends StatelessWidget {
  final PetEntities pet;
  final VoidCallback onConfirmBlock;

  const BlockUserDialog({
    super.key,
    required this.pet,
    required this.onConfirmBlock,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerGradient = isDark
        ? [const Color(0xFF2B2F36), const Color(0xFF1B1D20)]
        : [Colors.orange[300]!, Colors.orange[500]!];
    final infoColor = Colors.orange[400]!;
    final contentTextColor = isDark ? Colors.grey[200]! : Colors.grey[800]!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF141414) : null,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, isDark, headerGradient),
          _buildContent(context, isDark, infoColor, contentTextColor),
        ],
      ),
      actions: [
        _buildActionButtons(context, isDark),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, List<Color> headerGradient) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: headerGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.pets,
              color: isDark ? Colors.orange[300] : Colors.orange[700],
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).blockUser,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark, Color infoColor, Color contentTextColor) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).areYouSureYouWantToBlock,
            style: TextStyle(
              fontSize: 16,
              color: contentTextColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          BlockInfoItem(
            icon: Icons.chat_bubble_outline_rounded,
            text: S.of(context).chatWillBeEnded,
            color: infoColor,
            textColor: contentTextColor,
          ),
          const SizedBox(height: 14),
          BlockInfoItem(
            icon: Icons.person_remove_rounded,
            text: S.of(context).removedFromFreiendList,
            color: infoColor,
            textColor: contentTextColor,
          ),
          const SizedBox(height: 14),
          BlockInfoItem(
            icon: Icons.block_rounded,
            text: S.of(context).addedToBlockedList,
            color: infoColor,
            textColor: contentTextColor,
          ),
          const SizedBox(height: 14),
          BlockInfoItem(
            icon: Icons.cancel_rounded,
            text: S.of(context).YouCannotContactAgain,
            color: infoColor,
            textColor: contentTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor:
                  isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
            ),
            child: Text(
              S.of(context).cancel,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[200] : Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.orange[300]!, Colors.orange[500]!]
                    : [Colors.orange[400]!, Colors.orange[600]!],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onConfirmBlock,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                S.of(context).block,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BlockInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color textColor;

  const BlockInfoItem({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.18), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
