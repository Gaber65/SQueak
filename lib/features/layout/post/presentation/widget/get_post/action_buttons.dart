import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/react/presentation/screens/reaction_button_widget.dart';
import '../../../domain/entities/post_entity.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({
    super.key,
    required this.postItm,
    required this.commentsCount,
    required this.isDark,
    required this.postId,
    required this.petID,
    required this.onComment,
  });

  final PostEntity postItm;
  final String postId;
  final String? petID;
  final int commentsCount;
  final bool isDark;
  final VoidCallback onComment;

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          ReactionButton(
            postId: widget.postId,
            petID: widget.petID,
            postItm: widget.postItm,
          ),
          ActionButton(
            icon: IconlyLight.chat,
            label:
                '${widget.commentsCount} ${isArabic() ? 'تعليق' : 'Comment'}',
            color: widget.isDark ? Colors.white70 : Colors.grey[700]!,
            onTap: widget.onComment,
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
