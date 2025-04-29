import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';

import 'package:squeak/features/comments/domain/entities/comment_entity.dart';

import '../../../../../core/network/end-points.dart';
import '../../../../../core/service/cache/shared_preferences/cache_helper.dart';
import '../../../../../core/service/global_function/format_utils.dart';
import '../../../../../core/service/global_function/time_format.dart';
import '../../../../../core/service/global_widget/global_Image.dart';
import '../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../../../../core/service/service_locator/service_locator.dart';
import '../../../../../core/utils/theme/asset_image/asset_image.dart';
import '../../../../../core/utils/theme/fonts/font_styles.dart';
import '../../../../../core/utils/theme/navigation_helper/navigation.dart';
import '../../../../../generated/l10n.dart';

import '../../controller/comment_cubit.dart';
import '../../screens/build_edit_comment.dart';
import 'comment_item_card.dart';

class SuccessComment extends StatelessWidget {
  const SuccessComment({
    super.key,
    required this.scaffoldKey,
    required this.comments,
    required this.cubit,
    required this.isScrolle,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<CommentEntity> comments;
  final CommentCubit cubit;
  final bool isScrolle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: ListView.builder(
        itemCount: comments.length,
        shrinkWrap: !isScrolle,
        physics:
            isScrolle
                ? const BouncingScrollPhysics()
                : NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: CommentTreeWidget<CommentEntity, CommentEntity>(
              comments[index],
              comments[index].isSelected ? comments[index].replies : [],
              treeThemeData: TreeThemeData(
                lineColor: ColorManager.primaryColor,
                lineWidth: 1,
              ),
              avatarRoot: (context, data) {
                return buildPreferredSizeToAvatar(data);
              },
              contentRoot: (context, data) {
                return CommentItemCard(
                  data: data,
                  scaffoldKey: scaffoldKey,
                  cubit: cubit,
                  index: index,
                  comments: comments,
                  showReplies: true,
                );
              },
              contentChild: (context, value) {
                return CommentItemCard(
                  data: value,
                  scaffoldKey: scaffoldKey,
                  cubit: cubit,
                  index: index,
                  comments: comments,
                  showReplies: false,
                );
              },
              avatarChild: (context, data) {
                return buildPreferredSizeToAvatar(data);
              },
            ),
          );
        },
      ),
    );
  }

  PreferredSize buildPreferredSizeToAvatar(CommentEntity data) {
    return PreferredSize(
      preferredSize: Size.fromRadius(25),
      child: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          data.pet == null
              ? (data.user!.imageName != null &&
                      data.user!.imageName!.isNotEmpty)
                  ? "$imageUrl${data.user!.imageName}"
                  : AssetImageModel.defaultUserImage
              : (data.pet!.imageName != null && data.pet!.imageName!.isNotEmpty)
              ? "$imageUrl${data.pet!.imageName}"
              : AssetImageModel.defaultPetImage,
        ),
      ),
    );
  }
}
