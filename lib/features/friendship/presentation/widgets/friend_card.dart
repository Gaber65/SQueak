// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/core/service/global_function/time_format.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/mating/chat/presentation/screens/chat_screen.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_cubit.dart';

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

          SizedBox(
            width: double.infinity,
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
                  final switchProfileCubit = context.read<SwitchProfileCubit>();
                  final activePet = switchProfileCubit.activeProfile?.pet;

                  if (activePet == null || activePet.petId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isArabic()
                              ? 'لا يوجد صغير أليف نشط'
                              : 'No active pet found',
                        ),
                      ),
                    );
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
                    lastMessageSendDateTime: DateTime.now().toIso8601String(),
                    isBlock: chat?.isBlock ?? false,
                    isBlockedByMe: chat?.isBlockedByMe ?? false,
                    isBlockedByOther: chat?.isBlockedByOther ?? false,
                    isReadOnly: chat?.isReadOnly ?? false,
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
                  isArabic() ? 'الرسالة' : 'Message',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
