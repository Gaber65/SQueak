import 'package:flutter/material.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/global_function/time_format.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';

import '../../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../../../../core/utils/theme/decorations/decorations.dart';
import '../../../../../generated/l10n.dart';

class ChatListItem extends StatelessWidget {
  final ChatEntity chat;
  final VoidCallback onTap;

  const ChatListItem({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: Decorations.kDecorationBoxShadow(
          context: context,
          radius: 20,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ListTile(
          leading: Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.network(
                    imageUrl + chat.image!,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorManager.primaryColor.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.pets,
                          color: ColorManager.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            chat.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatFacebookTimePost(chat.lastMessageSendDateTime),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),

              if (chat.unreadedCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${chat.unreadedCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (chat.completeMarriageStatues)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, color: Colors.pink, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Mating',
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else if (chat.isBlock)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.block, color: Colors.red, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        S.of(context).block,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          onTap: onTap,
        ),
      ),
    );
  }


}
