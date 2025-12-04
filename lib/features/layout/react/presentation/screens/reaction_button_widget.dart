import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/layout/post/domain/entities/post_entity.dart';
import 'package:squeak/features/layout/react/presentation/animated_reaction/flutter_animated_reaction.dart';
import 'package:squeak/features/layout/react/presentation/screens/reaction_details_sheet.dart';
import '../animated_reaction/reaction_data.dart';


class ReactionButton extends StatefulWidget {
  final String postId;
  final String? petID;
  final PostEntity postItm;

  const ReactionButton({
    super.key,
    required this.postId,
    required this.petID,
    required this.postItm,
  });

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  final keyGlobal = GlobalKey();

  int? reactionIndex;
  int totalReact = 0;

  @override
  void initState() {
    super.initState();

    // Initialize reaction index based on post data
    bool reacted = (widget.postItm.userArereactedWithThisPost ?? false) ||
        (widget.postItm.petArereactedWithThisPost ?? false);

    reactionIndex = reacted
        ? getReactionTypeInvers(
        widget.postItm.userReactType ?? widget.postItm.petReactType)
        : null;

    totalReact = [
      widget.postItm.reactAngryCount,
      widget.postItm.reactHappyCount,
      widget.postItm.reactSadCount,
      widget.postItm.reactLoveCount,
      widget.postItm.reactLikeCount,
    ].map((e) => e ?? 0).fold(0, (a, b) => a + b);
  }

  void _handleReact(BuildContext context, int? newIndex) {
    final cubit = PostCubit.get(context);

    // Update local UI immediately
    setState(() {
      if (reactionIndex == null && newIndex != null) {
        totalReact++;
      } else if (reactionIndex != null && newIndex == null) {
        totalReact--;
      }
      reactionIndex = newIndex;
    });

    // Call cubit safely
    cubit.reactOnPost(
      ReactParams(
        postId: widget.postId,
        petId: widget.petID,
        reactType: reactionIndex ?? 0,
      ),
      reactionIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is CreateReactionFailure) {
          errorToast(context, state.error);
        }
      },
      builder: (context, state) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  key: keyGlobal,
                  onTap: () {
                    _handleReact(context, reactionIndex == null ? 0 : null);
                  },
                  onLongPress: () {
                    AnimatedFlutterReaction().showOverlay(
                      context: context,
                      key: keyGlobal,
                      onReaction: (val) {
                        _handleReact(context, val);
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 15.0,
                    backgroundColor:
                    MainCubit.get(context).isDark ? Colors.black : Colors.white,
                    backgroundImage: AssetImage(
                      reactionIndex == null
                          ? ReactionData.unActiveReactionImage
                          : reactionIndex == 0
                          ? ReactionData.activeReactionImage
                          : ReactionData.facebookReactionImage[reactionIndex!],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ReactionDetailsSheet(
                        postId: widget.postId,
                      ),
                    );
                  },
                  child: Text('$totalReact'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
