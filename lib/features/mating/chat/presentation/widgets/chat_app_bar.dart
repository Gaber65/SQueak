import 'package:flutter/material.dart';

import '../../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../domain/entities/chat_entity.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChatEntity chat;

  const ChatAppBar({super.key, required this.chat});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.primaryColor.withOpacity(0.1),
                ),
                child: Icon(Icons.pets, color: ColorManager.primaryColor),
              ),
              if (chat.isOnline)
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.petBName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(
                  chat.isOnline ? 'Online' : 'Last seen recently',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [

        PopupMenuButton<String>(
          onSelected: (value) => _handleAction(context, value),
          icon: Icon(Icons.more_vert, color: Colors.grey[700], size: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'view_profile',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[50],
                      ),
                      child: Icon(Icons.person, color: Colors.blue[600], size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'View Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              value: 'start_mating',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pink[50],
                      ),
                      child: Icon(Icons.favorite, color: Colors.pink[500], size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Start Mating Process',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              value: 'block',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red[50],
                      ),
                      child: Icon(Icons.block, color: Colors.red[500], size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Block User',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              value: 'end_chat',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange[50],
                      ),
                      child: Icon(Icons.exit_to_app, color: Colors.orange[500], size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'End Chat',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, String value) {
    switch (value) {
      case 'view_profile':
      // Navigate to profile
        break;
      case 'start_mating':
        _showStartMatingDialog(context);
        break;
      case 'block':
        _showBlockDialog(context);
        break;
      case 'end_chat':
        _showEndChatDialog(context);
        break;
    }
  }

  void _showStartMatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Mating Process'),
        content: Text('Are you sure you want to start the mating process with ${chat.petBName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mating process started!')),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: ColorManager.primaryColor),
            child: const Text('Start', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block ${chat.petBName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User blocked')),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Block', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEndChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Chat'),
        content: const Text('Are you sure you want to end this chat? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat ended')),
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('End Chat', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}