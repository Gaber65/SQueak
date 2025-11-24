import 'dart:async';
import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
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
  late bool _isBlockedByMe;
  late bool _isBlockedByOther;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _isBlocked = widget.chat.isBlock;
    _isBlockedByMe = widget.chat.isBlockedByMe;
    _isBlockedByOther = widget.chat.isBlockedByOther;
    _subscription = widget.cubit.stream.listen((state) {
      if (state is BlockChatSuccess) {
        if (!mounted) return;
        setState(() {
          _isBlocked = !_isBlocked;
          if (_isBlocked) {
            _isBlockedByMe = true;
            _isBlockedByOther = false;
          } else {
            _isBlockedByMe = false;
            _isBlockedByOther = false;
          }
        });
      }

      // Handle clear chat result to show feedback
      if (state is ClearChatSuccess) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chat cleared')),
        );
      }

      if (state is ClearChatError) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  String _getStatusText(context) {
    if (_isBlockedByMe) return S.of(context).block;
    if (_isBlockedByOther) return S.of(context).block;
    if (widget.chat.completeMarriageStatues) return S.of(context).completed;
    return S.of(context).active;
  }

  Color _getStatusColor() {
    if (_isBlockedByMe || _isBlockedByOther) return Colors.red;
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
                if (!_isBlockedByMe && !_isBlockedByOther)
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
                if (_isBlockedByMe)
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
                  value: 'clear_chat',
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
                            Icons.delete_forever,
                            color: Colors.orange[500],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          S.of(context).clearChat,
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

        if (_isBlockedByMe || _isBlockedByOther) {
          _showBlockedProfileDialog(context);
        } else {
          navigateToScreen(
            context,
            ViewPetProfileScreen(
              fromMating: true,
              petId: widget.chat.petId,
              isDarkMode: MainCubit.get(context).isDark,
            ),
          );
        }
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
      case 'clear_chat':
        _showClearChatDialog(context);
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
                Text(
                  S.of(context).youWontReceiveMessagesAnymore,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
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

  void _showBlockedProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red.shade50,
                Colors.orange.shade50,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade200,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.block_rounded,
                  size: 50,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                S.of(context).profileBlocked,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _isBlockedByMe
                    ? S.of(context).youBlockedThisUserCannotViewProfile
                    : S.of(context).thisUserBlockedYouCannotViewProfile,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    S.of(context).okay,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  void _showClearChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.pets, color: Colors.orange[700], size: 28),
            SizedBox(width: 12),
            Expanded(child: Text(S.of(context).clearChatMessages)),
          ],
        ),
        content: Text(S.of(context).clearChatConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.cubit.clearMessages(
                ClearChatParameters(
                  conversationId: widget.chat.id,
                  onlyFromMe: true,
                ),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.cleaning_services, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Clearing chat...'),
                      ],
                    ),
                    backgroundColor: Colors.orange[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_sweep, size: 20),
                SizedBox(width: 8),
                Text(
                  S.of(context).clearChat,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
