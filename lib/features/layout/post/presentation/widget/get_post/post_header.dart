import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../../../../mating/profile/presentation/screens/view_pet_profile_screen.dart';
import '../../../../../profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import '../../../domain/entities/post_entity.dart';
import '../../controller/post_cubit.dart';
import 'post_menu.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.postItem,
    required this.isDark,
    required this.petId,
    this.onMenuTap,
  });

  final PostEntity postItem;
  final String? petId;
  final bool isDark;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (postItem.petOwner == null) return;
              navigateToScreen(
                context,
                ViewPetProfileScreen(
                  petId: postItem.petOwner!.petId!,
                  isDarkMode: MainCubit.get(context).isDark,
                  isFriend: false,
                  activePetId:
                      SwitchProfileCubit.get(
                        context,
                      ).activeProfile!.pet!.petId!,
                ),
              );
            },
            child: _ClinicAvatar(
              imagePath: postItem.clinic?.image ?? postItem.petOwner?.imageName,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  postItem.clinic?.name ?? postItem.petOwner?.petName ?? '',
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  formatCustomTimePost(postItem.createdAt ?? ''),
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey[500],
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (petId != null && petId == postItem.petOwner?.petId)
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
              onPressed:
                  onMenuTap ??
                  () => _showPostMenu(context, PostCubit.get(context)),
              splashRadius: 20,
            ),
        ],
      ),
    );
  }

  void _showPostMenu(BuildContext context, PostCubit cubit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PostMenuSheet(postItem: postItem, cubit: cubit),
    );
  }
}

class _ClinicAvatar extends StatelessWidget {
  const _ClinicAvatar({required this.imagePath, required this.isDark});

  final String? imagePath;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: isDark ? Colors.grey[850] : Colors.grey[200],
        backgroundImage:
            imagePath != null && imagePath!.isNotEmpty
                ? SafeFastCachedImageProviderExtension.safe(imageUrl + imagePath!)
                : null,
        child:
            imagePath == null || imagePath!.isEmpty
                ? Icon(
                  Icons.business,
                  color: isDark ? Colors.white54 : Colors.grey[600],
                  size: 22,
                )
                : null,
      ),
    );
  }
}
