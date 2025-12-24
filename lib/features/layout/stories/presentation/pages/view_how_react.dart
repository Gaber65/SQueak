import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/network/end_points.dart';

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
    // Filter out reactions with type 0 (view-only, no reaction)
    final validReactions =
        reactions.toList();

    if (validReactions.isEmpty) {
      return _buildEmptyState();
    }

    _groupReactionsByType(validReactions);
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
            // Header with gradient
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
                    const Icon(Icons.favorite, color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'Reactions',
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

            // Reactions List with shimmer effect
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

  Widget _buildEmptyState() {
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
                    Icons.favorite_border,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No reactions yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to react to this story!',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildReactionItem(StoryReactionEntity reaction, ReactType type) {
    final isCurrentUser = reaction.petId == currentPetId;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle tap on reaction
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
              // Avatar with online indicator
              if (showAvatars) ...[
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(
                        imageUrl +
                            (reaction.petImage ?? reaction.userImage ?? ''),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
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
                        // Reaction Icon with tooltip
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
                        Text(
                          '• ${_formatTime(reaction.reactedAt)}',
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                isCurrentUser
                                    ? Colors.blue[600]
                                    : Colors.grey[600],
                          ),
                        ),
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

  Widget _buildCloseButton() {
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
            child: const Center(
              child: Text(
                'Close',
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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  Map<ReactType, List<StoryReactionEntity>> _groupReactionsByType(
    List<StoryReactionEntity> reactions,
  ) {
    final Map<ReactType, List<StoryReactionEntity>> grouped = {};

    for (final reaction in reactions) {
      final type = ReactType.fromInt(reaction.reactType);
      if (type != ReactType.none) {
        // Only group valid reactions
        grouped.putIfAbsent(type, () => []).add(reaction);
      }
    }

    return grouped;
  }
}

