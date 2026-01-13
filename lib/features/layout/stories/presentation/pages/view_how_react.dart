import 'package:flutter/material.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:squeak/generated/l10n.dart';

import '../../../react/domain/repo/base_react_repo.dart';
import '../../../react/presentation/animated_reaction/reaction_data.dart';
import '../../domain/entities/story_reaction_entity.dart';

class StoryReactionsView extends StatelessWidget {
  final List<StoryReactionEntity> reactions;
  final String? currentPetId;
  final VoidCallback? onClose;
  final bool showAvatars;

  const StoryReactionsView({
    super.key,
    required this.reactions,
    this.currentPetId,
    this.onClose,
    this.showAvatars = true,
  });

  @override
  Widget build(BuildContext context) {
    final validReactions = reactions.toList();

    if (validReactions.isEmpty) {
      return _buildEmptyState(context);
    }

    final totalReactions = validReactions.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4267B2), Color(0xFF898F9C)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    const Icon(Icons.visibility, color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      S.of(context).viewsAndReactions,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$totalReactions',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, thickness: 0.5),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: validReactions.length,
                itemBuilder: (context, index) {
                  final reaction = validReactions[index];
                  final type = ReactType.fromInt(reaction.reactType);

                  return _buildReactionItem(reaction, type);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.visibility_off_outlined,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).noViewsYet,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildReactionItem(StoryReactionEntity reaction, ReactType type) {
    final isCurrentUser = reaction.petId == currentPetId;

    final isViewOnly = type == ReactType.none;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigate to profile
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue[50] : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border:
                isCurrentUser
                    ? Border.all(color: Colors.blue[100]!, width: 1)
                    : null,
          ),
          child: Row(
            children: [
              // Avatar
              if (showAvatars) ...[
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: SafeFastCachedImageProviderExtension.safe(
                    imageUrl + (reaction.petImage ?? reaction.userImage ?? ''),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reaction.petName ?? reaction.userName ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color:
                                  isCurrentUser
                                      ? Colors.blue[800]
                                      : Colors.grey[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentUser)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'You',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (isViewOnly)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.visibility_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                          )
                        else
                          // 2. Show Emoji Image for Reactions
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  ReactionData.getIconForReactType(type),
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                        // // Time Text
                        // Text(
                        //   '• ${_formatTime(reaction.reactedAt)}',
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     color:
                        //         isCurrentUser
                        //             ? Colors.blue[600]
                        //             : Colors.grey[600],
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClose,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                S.of(context).close,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4267B2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
