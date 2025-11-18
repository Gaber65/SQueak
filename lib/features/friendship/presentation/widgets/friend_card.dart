// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/global_function/time_format.dart';
import 'package:squeak/features/friendship/presentation/widgets/cancel_daialog.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/mating/chat/presentation/screens/chat_screen.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_cubit.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/generated/l10n.dart';

import '../../../../core/network/end_points.dart';

class FriendCard extends StatelessWidget {
  final PetEntities pet;
  final ChatEntity? chat;

  const FriendCard({super.key, required this.pet, this.chat});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    final shadowColor =
        isDark ? Colors.black26 : Colors.black.withOpacity(0.05);
    final nameColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  imageUrl +
                      (pet.imageName?.isNotEmpty == true ? pet.imageName! : ""),
                ),
                child: Text(
                  pet.imageName?.isNotEmpty == true
                      ? ""
                      : pet.petName!.substring(0, 1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.petName ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: nameColor,
                      ),
                    ),
                    Text(
                      (pet.birthdate != null && pet.birthdate != '')
                          ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))}${pet.breed?.enBreed != null ? " • ${pet.breed!.enBreed}" : ""}"
                          : pet.breed?.enBreed ?? "",
                      style: TextStyle(fontSize: 14, color: subTextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final switchProfileCubit =
                          context.read<SwitchProfileCubit>();
                      final activePet = switchProfileCubit.activeProfile?.pet;

                      if (activePet == null || activePet.petId == null) {
                        return;
                      }
                      final chatEntity = ChatEntity(
                        id: pet.conversationId ?? '',
                        isGroup: false,
                        isPetChat: true,
                        name: pet.petName ?? '',
                        image: pet.imageName,
                        groupImage: null,
                        petId: pet.petId ?? '',
                        matingId: activePet.petId!,
                        completeMarriageStatues: false,
                        createdAt: DateTime.now().toIso8601String(),
                        lastMessageSendDateTime:
                            DateTime.now().toIso8601String(),
                        isBlock: chat?.isBlock ?? false,
                        isBlockedByMe: chat?.isBlockedByMe ?? false,
                        isBlockedByOther: chat?.isBlockedByOther ?? false,
                        isReadOnly: chat?.isReadOnly ?? false,
                        unreadedCount: 0,
                        
                      );
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MatingChatDetailScreen(chat: chatEntity),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            var begin = const Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(IconlyBold.chat, size: 18),
                    label: Text(
                      S.of(context).sendMessage,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          Theme.of(context).brightness == Brightness.dark
                              ? [Color(0xFF3B3F46), Color(0xFF1F2430)]
                              : [Color(0xFF232323), Color(0xFF414243)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        _showBlockDialog(context, pet);
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.block, size: 18),
                    label: Text(
                      S.of(context).block,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [Color(0xFF3B3F46), Color(0xFF1F2430)]
                      : [Color(0xFFB91C1C), Color(0xFFEF4444)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
                child: ElevatedButton(
                onPressed: () {
                  final switchProfileCubit = context.read<SwitchProfileCubit>();
                  final activePet = switchProfileCubit.activeProfile?.pet;
                  final petFriendsCubit = PetFriendsCubit.get(context);

                  _showCancelFriendDialog(context, pet, () async {
                    if (activePet == null || activePet.petId == null) {
                      return false;
                    }

                    try {
                      final resultFuture = petFriendsCubit.stream.firstWhere(
                        (s) => s is DeleteFriendShipSuccess || s is DeleteFriendShipFailed,
                      ).timeout(
                        const Duration(seconds: 10),
                        onTimeout: () => DeleteFriendShipFailed(message: 'Request timeout'),
                      );
                      await petFriendsCubit.deleteFriendship(pet, activePet.petId!);
                      final state = await resultFuture;
                      return state is DeleteFriendShipSuccess;
                    } catch (e) {
                      return false;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  S.of(context).cancelFriend,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showBlockDialog(BuildContext context, PetEntities pet) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return BlockUserDialog(
        onConfirmBlock: () async {
          Navigator.of(dialogContext).pop();
          final switchProfileCubit = context.read<SwitchProfileCubit>();
          final activePet = switchProfileCubit.activeProfile?.pet;
          if (activePet == null || activePet.petId == null) {
            return;
          }
          final petFriendsCubit = PetFriendsCubit.get(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          try {
            await petFriendsCubit.blockFriend(pet, activePet.petId!);
            await petFriendsCubit.getFriends(petId: activePet.petId!);
          } finally {
            try {
              final NavigatorState nav = Navigator.of(context, rootNavigator: true);
              if (nav.canPop()) {
                nav.pop();
              } else if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            } catch (_) {
            }
          }
        },
      );
    },
  );
}



void _showCancelFriendDialog(BuildContext context, PetEntities pet, Future<bool> Function()? onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CancelFriendDialog(pet: pet, onConfirmCancel: onConfirm);
    },
  );
}


class BlockUserDialog extends StatelessWidget {
  final VoidCallback onConfirmBlock;

  const BlockUserDialog({super.key, required this.onConfirmBlock});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerGradient =
        isDark
            ? [Color(0xFF2B2F36), Color(0xFF1B1D20)]
            : [Colors.orange[300]!, Colors.orange[500]!];
    final infoColor = Colors.orange[400]!;
    final contentTextColor = isDark ? Colors.grey[200]! : Colors.grey[800]!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF141414) : null,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: headerGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.pets,
                    color: isDark ? Colors.orange[300] : Colors.orange[700],
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).blockUser,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).areYouSureYouWantToBlock,
                  style: TextStyle(
                    fontSize: 16,
                    color: contentTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildInfoItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  text:
                    S.of(context).chatWillBeEnded,
                  color: infoColor,
                  textColor: contentTextColor,
                ),
                const SizedBox(height: 14),
                _buildInfoItem(
                  icon: Icons.person_remove_rounded,
                  text:
                      S.of(context).removedFromFreiendList,
                  color: infoColor,
                  textColor: contentTextColor,
                ),
                const SizedBox(height: 14),
                _buildInfoItem(
                  icon: Icons.block_rounded,
                  text:
                   S.of(context).addedToBlockedList,
                  color: infoColor,
                  textColor: contentTextColor,
                ),
                const SizedBox(height: 14),
                _buildInfoItem(
                  icon: Icons.cancel_rounded,
                  text:
                     S.of(context).YouCannotContactAgain,
                  color: infoColor,
                  textColor: contentTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor:
                      isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
                ),
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[200] : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isDark
                            ? [Colors.orange[300]!, Colors.orange[500]!]
                            : [Colors.orange[400]!, Colors.orange[600]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onConfirmBlock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    S.of(context).block,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.18), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
