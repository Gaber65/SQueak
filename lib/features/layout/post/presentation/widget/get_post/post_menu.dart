import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../../domain/entities/post_entity.dart';
import '../../controller/post_cubit.dart';

import '../../screens/edit_post_screen.dart';
import 'delete_dialog.dart';

class PostMenuSheet extends StatelessWidget {
  const PostMenuSheet({super.key, required this.postItem, required this.cubit});

  final PostEntity postItem;
  final PostCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuItem(
            icon: Icons.edit,
            title: isArabic() ? 'تعديل المنشور' : 'Edit post',
            onTap: () {
              Navigator.pop(context);
              _navigateToEditPost(context);
            },
          ),
          MenuItem(
            icon: Icons.delete_outline,
            title: isArabic() ? 'حذف المنشور' : 'Delete post',
            isDestructive: true,
            onTap: () {
              Navigator.pop(context);
              _showDeleteDialog(context, cubit);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _navigateToEditPost(BuildContext context) {
    navigateToScreen(
      context,
      EditPostScreen(postEntity: postItem),
    );
  }

  void _showDeleteDialog(BuildContext context, PostCubit postCubit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: DeleteDialogContent(
            postCubit: postCubit,
            context: context,
            postItem: postItem,
          ),
        );
      },
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : null;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}