import 'dart:async';
import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../../controllers/chat_messages_state.dart';
import 'package:squeak/features/mating/chat/presentation/screens/rating_pet_mating.dart';
import '../../../../profile/presentation/screens/view_pet_profile_screen.dart';
import '../../../domain/entities/chat_entity.dart';
import 'chat_dialog_helper.dart';
import 'chat_app_bar_widgets/menu_item_widget.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ChatEntity chat;
  final ChatMessagesCubit cubit;
  final bool isOnline;
  final bool isTyping;

  const ChatAppBar({
    super.key,
    required this.chat,
    required this.cubit,
    this.isOnline = false,
    this.isTyping = false,
  });

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Chat cleared')));
      }

      if (state is ClearChatError) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.message)));
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
    if (widget.isOnline) return isArabic() ? 'متصل' : 'Online';
    return S.of(context).offline;
  }

  Color _getStatusColor() {
    if (_isBlockedByMe || _isBlockedByOther) return Colors.red;
    if (widget.chat.completeMarriageStatues) return const Color(0xFF6C63FF);
    if (widget.isOnline) return Colors.green;
    return Colors.grey;
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
          Stack(
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
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        : const Icon(
                          Icons.pets,
                          color: ColorManager.primaryColor,
                        ),
              ),
              if (widget.isOnline && !_isBlockedByMe && !_isBlockedByOther)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
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
            child: InkWell(
              onTap: () {
                ChatDialogHelper.showRenameDialog(
                  context,
                  currentName: widget.chat.name,
                  cubit: widget.cubit,
                  conversationId: widget.chat.id,
                  petId: widget.chat.petId,
                ).then((value) {
                  if (value != null && value[0] == true) {
                    setState(() {
                      newName = value[1];
                    });
                  }
                });
              },
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
                MenuItemWidget(
                  icon: Icons.person,
                  iconColor: ColorManager.primaryColor.withOpacity(0.5),
                  text: S.of(context).viewProfile,
                  value: 'view_profile',
                ),
                if (!widget.chat.completeMarriageStatues)
                  MenuItemWidget(
                    icon: Icons.favorite,
                    iconColor: Colors.pink[500]!,
                    text: S.of(context).finishMatingProcess,
                    value: 'finish_mating',
                  ),
                if (!_isBlockedByMe && !_isBlockedByOther)
                  MenuItemWidget(
                    icon: Icons.block,
                    iconColor: Colors.red[500]!,
                    text: S.of(context).blockUser,
                    value: 'block',
                  ),
                if (_isBlockedByMe)
                  MenuItemWidget(
                    icon: Icons.block,
                    iconColor: Colors.green[500]!,
                    text: S.of(context).unblockUser,
                    value: 'unBlock',
                  ),
                if (widget.chat.completeMarriageStatues)
                  MenuItemWidget(
                    icon: Icons.star,
                    iconColor: Colors.yellow[500]!,
                    text: S.of(context).ratingMating,
                    value: 'rating',
                  ),
                MenuItemWidget(
                  icon: Icons.delete_forever,
                  iconColor: Colors.orange[500]!,
                  text: S.of(context).clearChat,
                  value: 'clear_chat',
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
          ChatDialogHelper.showBlockedProfileDialog(
            context,
            isBlockedByMe: _isBlockedByMe,
          );
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
        ChatDialogHelper.showFinishMatingDialog(
          context,
          matingId: widget.chat.matingId,
          cubit: widget.cubit,
        );
        break;
      case 'block':
        ChatDialogHelper.showBlockDialog(
          context,
          userName: widget.chat.name,
          cubit: widget.cubit,
          conversationId: widget.chat.id,
        );
        break;
      case 'unBlock':
        ChatDialogHelper.showUnBlockDialog(
          context,
          userName: widget.chat.name,
          cubit: widget.cubit,
          conversationId: widget.chat.id,
        );
        break;
      case 'clear_chat':
        ChatDialogHelper.showClearChatDialog(
          context,
          cubit: widget.cubit,
          conversationId: widget.chat.id,
        );
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
}
