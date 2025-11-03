import 'dart:async';
import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../../../../../core/utils/enums/profile_type.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../controllers/chat_messages_state.dart';
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
  late bool _isBlocked;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _isBlocked = widget.chat.isBlock;
    _subscription = widget.cubit.stream.listen((state) {
      if (state is BlockChatSuccess) {
        if (!mounted) return;
        setState(() {
          _isBlocked = !_isBlocked;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  String _getStatusText(context) {
    if (_isBlocked) return S.of(context).block;
    if (widget.chat.completeMarriageStatues) return S.of(context).completed;
    return S.of(context).active;
  }

  Color _getStatusColor() {
    if (_isBlocked) return Colors.red;
    if (widget.chat.completeMarriageStatues) return const Color(0xFF6C63FF);
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
        onPressed: () {
          Navigator.pop(context);
          // Reload chat list after navigation completes
          Future.delayed(const Duration(milliseconds: 100), () {
            try {
              final profileState =
                  SwitchProfileCubit.get(navigatorKey.currentContext!).state;
              if (profileState is ProfileLoaded &&
                  profileState.profile.type == ProfileType.pet) {
                final petId = profileState.profile.pet?.petId;
                if (petId != null) {
                  ChatListCubit.get(
                    navigatorKey.currentContext!,
                  ).loadChats(petId);
                }
              }
            } catch (_) {}
          });
        },
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
            child:
                (widget.chat.image != null && widget.chat.image!.isNotEmpty)
                    ? ClipOval(
                      child: Image.network(
                        imageUrl + widget.chat.image!,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.pets,
                            color: ColorManager.primaryColor,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                    : const Icon(Icons.pets, color: ColorManager.primaryColor),
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
                        Text(
                          S.of(context).viewProfile,
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
                          Text(
                            S.of(context).finishMatingProcess,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!_isBlocked)
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
                          Text(
                            S.of(context).blockUser,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_isBlocked)
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
                          Text(
                            S.of(context).unblockUser,
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
                          Text(
                            S.of(context).ratingMating,
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
                        Text(
                          S.of(context).endChat,
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
    final s = S.of(context);

    MatingCompleteStatues? selectedStatus;

    final List<Map<String, dynamic>> statuses = [
      {
        'status': MatingCompleteStatues.complete,
        'title': s.completed,
        'description': 'Description for completed',
      },
      {
        'status': MatingCompleteStatues.notComplete,
        'title': s.not_completed,
        'description': 'Description for not completed',
      },
    ];
    bool sharePost = true;

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
                            S.of(context).sharePost,
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
                          Expanded(
                            flex: 2,
                            child: OutlinedButton(
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
                              child: Text(
                                S.of(context).cancel,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                if (selectedStatus != null) {
                                  widget.cubit
                                      .finishMating(
                                        FinishMatingParameters(
                                          matingId: widget.chat.matingId,
                                          matingCompleteStatues:
                                              selectedStatus!,
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
                              child: Text(
                                S.of(context).finish,
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cute icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pets,
                    size: 40,
                    color: Colors.orange.shade400,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  '${S.of(context).wantBlockUser} ${widget.chat.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  S.of(context).youWontReceiveMessagesAnymore,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              // Block button
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  S.of(context).blockUser,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
            title: Text(S.of(context).unblockUser),
            content: Text(
              '${S.of(context).areYouSureYouWantToUnblock} ${widget.chat.name}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
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
                child: Text(
                  S.of(context).unblockUser,
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
          (context) => StatefulBuilder(
            builder: (context, setDialogState) {
              bool isEmpty = controller.text.trim().isEmpty;

              return Dialog(
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
                        onChanged: (value) {
                          setDialogState(() {
                            isEmpty = value.trim().isEmpty;
                          });
                        },
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
                      if (isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Text(
                            S.of(context).nameCannotBeEmpty,
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 12,
                            ),
                          ),
                        ),

                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: Text(
                                S.of(context).cancel,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Rename Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  isEmpty
                                      ? null
                                      : () {
                                        String newName = controller.text.trim();
                                        if (newName.isNotEmpty) {
                                          widget.cubit
                                              .renameChat(
                                                RenameChatParameters(
                                                  conversationId:
                                                      widget.chat.id,
                                                  petId: widget.chat.petId,
                                                  newName: newName,
                                                  conversationType: 1,
                                                ),
                                              )
                                              .then((value) {
                                                if (!context.mounted) return;
                                                Navigator.pop(context, [
                                                  value,
                                                  newName,
                                                ]);
                                              });
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isEmpty
                                        ? Colors.grey[300]
                                        : Colors.blue[600],
                                foregroundColor:
                                    isEmpty ? Colors.grey[500] : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: isEmpty ? 0 : 2,
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
              );
            },
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
            title: Text(S.of(context).endChat),
            content: Text(S.of(context).endChatConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
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
                child: Text(
                  S.of(context).endChat,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
