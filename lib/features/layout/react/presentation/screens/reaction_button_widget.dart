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
  ReactType _currentReactType = ReactType.none;
  int _totalReact = 0;

  @override
  void initState() {
    super.initState();

    // Initialize with current reaction state
    _updateReactionState();

    // Calculate total reactions
    _totalReact = _calculateTotalReactions();
  }

  void _updateReactionState() {
    if (widget.postItm.userArereactedWithThisPost == true) {
      _currentReactType = ReactType.fromInt(widget.postItm.userReactType);
    } else if (widget.postItm.petArereactedWithThisPost == true) {
      _currentReactType = ReactType.fromInt(widget.postItm.petReactType);
    } else {
      _currentReactType = ReactType.none;
    }
  }

  int _calculateTotalReactions() {
    return (widget.postItm.reactHappyCount ?? 0) +
        (widget.postItm.reactSadCount ?? 0) +
        (widget.postItm.reactLoveCount ?? 0) +
        (widget.postItm.reactAngryCount ?? 0) +
        (widget.postItm.reactLikeCount ?? 0);
  }

  void _handleSingleTap() {
    if (_currentReactType == ReactType.none) {
      // If no reaction, set to "like" (5)
      _currentReactType = ReactType.like;
    } else {
      // If already reacted, remove reaction
      _currentReactType = ReactType.none;
    }

    _sendReactionToApi();
    setState(() {
      _updateTotalReactions();
    });
  }

  void _handleReactionFromOverlay(int uiIndex) {
    // Convert UI index to ReactType
    // UI: 0=happy, 1=sad, 2=love, 3=angry, 4=like
    // Backend: 1=happy, 2=sad, 3=love, 4=angry, 5=like
    final reactTypeValue = uiIndex + 1;
    _currentReactType = ReactType.fromInt(reactTypeValue);

    _sendReactionToApi();
    setState(() {
      _updateTotalReactions();
    });
  }

  void _sendReactionToApi() {
    final cubit = PostCubit.get(context);

    cubit
        .reactOnPost(
          ReactParams(
            postId: widget.postId,
            petId: widget.petID,
            reactType:
                _currentReactType.value, // Send 0 for none, 1-5 for reactions
          ),
        )
        .then((_) {
          // You might want to refresh the post data here
          // or update based on the API response
        });
  }

  void _updateTotalReactions() {
    // Simple logic: increment/decrement based on reaction change
    // In a real app, you'd update this based on API response
    if (_currentReactType == ReactType.none) {
      // Removing reaction
      if (_totalReact > 0) _totalReact--;
    } else {
      // Adding/changing reaction
      // This is simplified - in reality, you need to check if it was previously reacted
      _totalReact++;
    }
  }

  String _getCurrentReactionImage() {
    if (_currentReactType == ReactType.none) {
      return ReactionData.unActiveReactionImage;
    }

    return ReactionData.getImageForReactType(
      ReactType.fromInt(_currentReactType.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        // Handle API response states if needed
        if (state is CreateReactionSuccess) {
          // Update based on API response
          setState(() {
            _totalReact = _calculateTotalReactions();
          });
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
                  onTap: _handleSingleTap,
                  onLongPress: () {
                    AnimatedFlutterReaction().showOverlay(
                      context: context,
                      key: keyGlobal,
                      reactions: ReactionData.facebookReactionIcon,
                      onReaction: _handleReactionFromOverlay,
                    );
                  },
                  child: CircleAvatar(
                    radius: 15.0,
                    backgroundColor:
                        MainCubit.get(context).isDark
                            ? Colors.black
                            : Colors.white,
                    backgroundImage: AssetImage(_getCurrentReactionImage()),
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
                          (_) => ReactionDetailsSheet(postId: widget.postId),
                    );
                  },
                  child: Text('$_totalReact'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
