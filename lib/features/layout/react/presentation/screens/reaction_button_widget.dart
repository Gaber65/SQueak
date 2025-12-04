import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/global_widget/toast.dart';
import 'package:squeak/features/layout/post/domain/entities/post_entity.dart';
import 'package:squeak/features/layout/react/presentation/animated_reaction/flutter_animated_reaction.dart';
import 'package:squeak/features/layout/react/presentation/screens/reaction_details_sheet.dart';

import '../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../../../../core/service/service_locator/service_locator.dart';
import '../../../stories/presentation/controllers/story_cubit.dart';
import '../../domain/entities/react_entities.dart';
import '../../domain/repo/base_react_repo.dart';
import '../animated_reaction/reaction_data.dart';
import '../controller/react_cubit.dart';

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

    bool re =
        (widget.postItm.userArereactedWithThisPost ?? false) ||
        (widget.postItm.petArereactedWithThisPost ?? false);
    reactionIndex =
        re
            ? getReactionTypeInvers(
              widget.postItm.userReactType ?? widget.postItm.petReactType,
            )
            : null;

    totalReact = [
      widget.postItm.reactAngryCount,
      widget.postItm.reactHappyCount,
      widget.postItm.reactSadCount,
      widget.postItm.reactLoveCount,
      widget.postItm.reactLikeCount,
    ].map((e) => e ?? 0).fold(0, (a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReactCubit>(),
      child: BlocConsumer<ReactCubit, ReactState>(
        listener: (context, state) {
          if (state is CreateReactionFailure) {
            errorToast(context, state.error);
          }
          if (state is CreateReactionSuccess) {
            setState(() {
              totalReact = reactionIndex == null ? totalReact : ++totalReact;
            });
          }
        },
        builder: (context, state) {
          final cubit = ReactCubit.get(context);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    key: keyGlobal,

                    onTap: () {
                      if (reactionIndex != null) {
                        reactionIndex = null;
                      } else {
                        reactionIndex = 0;
                      }
                      setState(() {});
                      cubit.reactOnPost(
                        ReactParams(
                          postId: widget.postId,
                          petId: widget.petID,
                          reactType: reactionIndex == null ? 0 : 1,
                        ),
                        reactionIndex,
                      );
                    },
                    onLongPress: () {
                      // Show reaction overlay
                      AnimatedFlutterReaction().showOverlay(
                        context: context,
                        key: keyGlobal,
                        onReaction: (val) {
                          reactionIndex = val;
                          setState(() {});
                          cubit.reactOnPost(
                            ReactParams(
                              postId: widget.postId,
                              petId: widget.petID,
                              reactType: reactionIndex!,
                            ),
                            reactionIndex,
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 15.0,
                      backgroundColor:
                          MainCubit.get(context).isDark
                              ? Colors.black
                              : Colors.white,
                      backgroundImage: AssetImage(
                        reactionIndex == null
                            ? ReactionData.unActiveReactionImage
                            : reactionIndex == 0
                            ? ReactionData.activeReactionImage
                            : ReactionData
                                .facebookReactionImage[reactionIndex!],
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
                        builder:
                            (_) => BlocProvider.value(
                              value: ReactCubit.get(context),
                              child: ReactionDetailsSheet(
                                postId: widget.postId,
                              ),
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
      ),
    );
  }
}
