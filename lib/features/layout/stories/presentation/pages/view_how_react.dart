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
    if (reactions.isEmpty) {
      return _buildEmptyState();
    }

    // Group reactions by type
    final reactionsByType = _groupReactionsByType();
    final totalReactions = reactions.length;

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
          // Header
          _buildHeader(totalReactions),

          // Reactions Summary
          _buildReactionsSummary(reactionsByType),

          // Divider
          const Divider(height: 1, thickness: 0.5),

          // Reactions List
          _buildReactionsList(),

          // Close Button
          _buildCloseButton(),
        ],
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.favorite_border, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'No reactions yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildHeader(int totalReactions) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Text(
            'Reactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$totalReactions',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionsSummary(
    Map<ReactType, List<StoryReactionEntity>> reactionsByType,
  ) {
    final reactionTypes = reactionsByType.entries.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children:
            reactionTypes.map((entry) {
              final type = entry.key;
              final reactions = entry.value;
              final count = reactions.length;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Reaction Icon
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            ReactionData.facebookReactionIcon[type.value],
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Reaction Count
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildReactionsList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: reactions.length,
        itemBuilder: (context, index) {
          final reaction = reactions[index];
          final type = ReactType.fromInt(reaction.reactType);

          return _buildReactionItem(reaction, type);
        },
      ),
    );
  }

  Widget _buildReactionItem(StoryReactionEntity reaction, ReactType type) {
    final isCurrentUser = reaction.petId == currentPetId;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser ? Border.all(color: Colors.blue[100]!) : null,
      ),
      child: Row(
        children: [
          // Avatar
          if (showAvatars) ...[
            _buildAvatar(reaction),
            const SizedBox(width: 12),
          ],

          // User/Pet Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reaction.petName ?? reaction.userName ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isCurrentUser ? Colors.blue[800] : Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    // Reaction Icon
                    Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            ReactionData.facebookReactionIcon[type.value],
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Reaction Type & Time
                    Text(
                      '${ReactionData.facebookReactionText[type.value]} • ${_formatTime(reaction.reactedAt)}',
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            isCurrentUser ? Colors.blue[600] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // You Indicator
          if (isCurrentUser)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'You',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[800],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(StoryReactionEntity reaction) {
    final imagePath =
        imageUrl + (reaction.petImage ?? reaction.userImage ?? '');

    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey[200],
      backgroundImage: NetworkImage(imagePath),
    );
  }

  Widget _buildCloseButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 0.5)),
      ),
      child: TextButton(
        onPressed: onClose,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        child: const Text(
          'Close',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
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
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  Map<ReactType, List<StoryReactionEntity>> _groupReactionsByType() {
    final Map<ReactType, List<StoryReactionEntity>> grouped = {};

    for (final reaction in reactions) {
      final type = ReactType.fromInt(reaction.reactType);
      grouped.putIfAbsent(type, () => []).add(reaction);
    }

    return grouped;
  }
}

// Usage example in your StoryViewerPage:
class StoryReactionsOverlay extends StatelessWidget {
  final List<StoryReactionEntity> reactions;
  final String? currentPetId;
  final VoidCallback onClose;

  const StoryReactionsOverlay({
    super.key,
    required this.reactions,
    this.currentPetId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent bubbling
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StoryReactionsView(
                reactions: reactions,
                currentPetId: currentPetId,
                onClose: onClose,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
