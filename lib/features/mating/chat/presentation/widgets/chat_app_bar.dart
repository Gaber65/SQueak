import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/chat/presentation/screens/rating_pet_mating.dart';
import '../../../profile/presentation/screens/view_pet_profile_screen.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/parameters.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ChatEntity chat;
  final ChatMessagesCubit cubit;

  const ChatAppBar({super.key, required this.chat, required this.cubit});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  String? newName;

  String _getStatusText(context) {
    if (widget.chat.isBlock) return S.of(context).block;
    if (widget.chat.completeMarriageStatues) return S.of(context).completed;
    return S.of(context).active;
  }

  Color _getStatusColor() {
    if (widget.chat.isBlock) return Colors.red;
    if (widget.chat.isBlock) return const Color(0xFF6C63FF);
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                MainCubit.get(context).isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ColorManager.primaryColor.withOpacity(0.3),
                  ColorManager.primaryColor.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: ColorManager.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(Icons.pets, color: ColorManager.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap:
                  () =>
                      _showRenameDialog(context, currentName: widget.chat.name),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newName ?? widget.chat.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    _getStatusText(context),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) => _handleAction(context, value),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  MainCubit.get(context).isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.more_vert_rounded, size: 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          itemBuilder:
              (BuildContext context) => [
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
                            color: ColorManager.primaryColor.withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.person,
                            color: ColorManager.primaryColor.withOpacity(0.5),
                            size: 20,
                          ),
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

                if (!widget.chat.completeMarriageStatues)
                  PopupMenuItem(
                    value: 'finish_mating',
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
                            child: Icon(
                              Icons.favorite,
                              color: Colors.pink[500],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Finish Mating Process',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (!widget.chat.isBlock)
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
                            child: Icon(
                              Icons.block,
                              color: Colors.red[500],
                              size: 20,
                            ),
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

                if (widget.chat.isBlock)
                  PopupMenuItem(
                    value: 'unBlock',
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green[50],
                            ),
                            child: Icon(
                              Icons.block,
                              color: Colors.green[500],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'unBlock User',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (widget.chat.completeMarriageStatues)
                  PopupMenuItem(
                    value: 'rating',
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[50],
                            ),
                            child: Icon(
                              Icons.star,
                              color: Colors.yellow[500],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Rating Mating',
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
                          child: Icon(
                            Icons.exit_to_app,
                            color: Colors.orange[500],
                            size: 20,
                          ),
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
        navigateToScreen(
          context,
          ViewPetProfileScreen(
            petId: widget.chat.petId,
            isDarkMode: MainCubit.get(context).isDark,
          ),
        );
        break;
      case 'finish_mating':
        _showFinishMatingDialog(context);
        break;
      case 'block':
        _showBlockDialog(context);
        break;
      case 'unBlock':
        _showUnBlockDialog(context);
        break;
      case 'end_chat':
        _showEndChatDialog(context);
        break;
      case 'rating':
        _showRatingDialog(context);
        break;
    }
  }

  void _showRatingDialog(BuildContext context) {
    navigateToScreen(
      context,
      PetMatingRatingScreen(
        matingId: widget.chat.matingId,
        cubit: widget.cubit,
      ),
    );
  }

  void _showFinishMatingDialog(BuildContext context) {
    final s = S.of(context); // Your localization

    MatingCompleteStatues? selectedStatus;

    final List<Map<String, dynamic>> statuses = [
      {
        'status': MatingCompleteStatues.complete,
        'title': s.completed,
        'description':
            'Description for completed', // make sure you have descriptions
      },
      {
        'status': MatingCompleteStatues.notComplete,
        'title': s.not_completed,
        'description': 'Description for not completed',
      },
    ];
    bool sharePost = true; // initial value for checkbox

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.all(16),
                child: Form(
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(
                            Icons.pets,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            s.update_pet_status,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Status Options
                      Expanded(
                        child: ListView.builder(
                          itemCount: statuses.length,
                          itemBuilder: (context, index) {
                            final statusData = statuses[index];
                            final status =
                                statusData['status'] as MatingCompleteStatues;
                            final isSelected = selectedStatus == status;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap:
                                    () =>
                                        setState(() => selectedStatus = status),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? ColorManager.primaryColor
                                              : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        isSelected
                                            ? ColorManager.primaryColor
                                                .withAlpha(50)
                                            : Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              statusData['title'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    isSelected
                                                        ? ColorManager
                                                            .primaryColor
                                                            .withAlpha(255)
                                                        : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              statusData['description'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ColorManager.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Text(
                                            s.selected,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Row(
                        children: [
                          Text(
                            'Share post', // replace with actual pet name
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const Spacer(),
                          Checkbox(
                            value: sharePost,
                            onChanged: (value) {
                              setState(() {
                                sharePost = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                      // Action Buttons
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedStatus != null) {
                                widget.cubit
                                    .finishMating(
                                      FinishMatingParameters(
                                        matingId: widget.chat.matingId,
                                        matingCompleteStatues: selectedStatus!,
                                        sharePost: sharePost,
                                      ),
                                    )
                                    .then((value) {
                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();
                                    });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Finish',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Block User'),
            content: Text(
              'Are you sure you want to block ${widget.chat.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.cubit
                      .blockChat(
                        BlockChatParameters(
                          conversationType: 1,
                          statues: 0,
                          conversationId: widget.chat.id,
                        ),
                      )
                      .then((value) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Block',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showUnBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Unblock User'),
            content: Text(
              'Are you sure you want to unblock ${widget.chat.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.cubit
                      .blockChat(
                        BlockChatParameters(
                          conversationType: 1,
                          statues: 1,
                          conversationId: widget.chat.id,
                        ),
                      )
                      .then((value) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'Unblock',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showRenameDialog(BuildContext context, {String currentName = ''}) {
    final TextEditingController controller = TextEditingController(
      text: currentName,
    );

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 8,
            backgroundColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    S.of(context).renameChat,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  const SizedBox(height: 24),

                  // Text Field
                  TextField(
                    controller: controller,
                    autofocus: true,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: S.of(context).enterNewName,
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.blue[400]!,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14.0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Buttons Row
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Rename Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            String newName = controller.text.trim();
                            if (newName.isNotEmpty) {
                              widget.cubit
                                  .renameChat(
                                    RenameChatParameters(
                                      conversationId: widget.chat.id,
                                      petId: widget.chat.petId,
                                      newName: newName,
                                      conversationType: 1,
                                    ),
                                  )
                                  .then((value) {
                                    if (!context.mounted) return;
                                    Navigator.pop(context, [value, newName]);
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 2,
                          ),
                          child: Text(
                            S.of(context).save,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    ).then((value) {
      if (value != null && value[0] == true) {
        setState(() {
          newName = value[1];
        });
      }
    });
  }

  void _showEndChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('End Chat'),
            content: const Text(
              'Are you sure you want to end this chat? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Chat ended')));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'End Chat',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
