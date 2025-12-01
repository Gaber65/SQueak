// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/features/friendship/domain/entities/pet_friend_request_entity.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_cubit.dart';
import 'package:squeak/features/friendship/presentation/widgets/card_widgets/request_card.dart';
import 'package:squeak/features/friendship/presentation/widgets/section_header_widget.dart';
import 'package:squeak/features/friendship/presentation/widgets/card_widgets/sent_card.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import 'card_widgets/friend_card.dart';
import 'card_widgets/suggested_card.dart';

class AnimatedItem extends StatelessWidget {
  final Widget child;
  final int index;

  const AnimatedItem({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final safeValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 50 * (1 - safeValue)),
          child: Opacity(opacity: safeValue, child: child),
        );
      },
      child: child,
    );
  }
}

class AmazingEmptyList extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback onPressed;

  const AmazingEmptyList({
    super.key,
    required this.message,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(icon, size: 72, color: Colors.white),
            ),
            const SizedBox(height: 24),
            // النص برسالة لطيفة
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // زر CTA
            ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                isArabic() ? "تحديث" : "Refresh",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendsTab extends StatelessWidget {
  final List<PetEntities> friends;

  const FriendsTab({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () => context.read<PetFriendsCubit>().getFriends(
            petId: SwitchProfileCubit.get(context).activeProfile!.pet!.petId!,
          ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            icon: IconlyBold.heart,
            title: isArabic() ? 'أصدقائي' : 'My Pet Friends',
            count: friends.length,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          if (friends.isEmpty) ...[
            const SizedBox(height: 150),
            AmazingEmptyList(
              onPressed:
                  () => context.read<PetFriendsCubit>().getFriends(
                    petId:
                        SwitchProfileCubit.get(
                          context,
                        ).activeProfile!.pet!.petId!,
                  ),
              icon: Icons.pets,
              message:
                  isArabic() ? "لا يوجد أصدقاء بعد 🐾" : "No Friends Yet 🐾",
            ),
          ] else ...[
            ...friends.asMap().entries.map(
              (entry) => AnimatedItem(
                index: entry.key,
                child: FriendCard(pet: entry.value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SuggestedTab extends StatelessWidget {
  final List<PetEntities> suggested;

  const SuggestedTab({super.key, required this.suggested});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () => context.read<PetFriendsCubit>().loadSuggestedFriends(
            specieId: SwitchProfileCubit.get(context).specieId,
          ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            icon: Icons.pets,
            title: isArabic() ? 'الأصدقاء المقترحون' : 'Suggested Friends',
            count: suggested.length,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),

          if (suggested.isEmpty) ...[
            const SizedBox(height: 150),
            AmazingEmptyList(
              onPressed:
                  () => context.read<PetFriendsCubit>().loadSuggestedFriends(
                    specieId: SwitchProfileCubit.get(context).specieId,
                  ),
              icon: IconlyBold.search,
              message:
                  isArabic() ? "لا توجد اقتراحات حالياً" : "No Suggestions Yet",
            ),
          ] else ...[
            ...suggested.asMap().entries.map(
              (entry) => AnimatedItem(
                index: entry.key,
                child: SuggestedCard(pet: entry.value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ReceivedTab extends StatelessWidget {
  final List<PetFriendRequestEntity> requests;

  const ReceivedTab({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () => context.read<PetFriendsCubit>().loadReceivedFriends(
            petId: SwitchProfileCubit.get(context).activeProfile!.pet!.petId!,
          ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            icon: IconlyBold.add_user,
            title: isArabic() ? 'الطلبات المعلقة' : 'Pending Requests',
            count: requests.length,
            color: Colors.green,
          ),
          const SizedBox(height: 16),

          if (requests.isEmpty) ...[
            const SizedBox(height: 150),
            AmazingEmptyList(
              onPressed:
                  () => context.read<PetFriendsCubit>().loadReceivedFriends(
                    petId:
                        SwitchProfileCubit.get(
                          context,
                        ).activeProfile!.pet!.petId!,
                  ),
              icon: IconlyBold.activity,
              message:
                  isArabic() ? "لا توجد طلبات معلقة" : "No Pending Requests",
            ),
          ] else ...[
            ...requests.asMap().entries.map(
              (entry) => AnimatedItem(
                index: entry.key,
                child: RequestCard(pet: entry.value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SentTab extends StatelessWidget {
  final List<PetEntities> requests;

  const SentTab({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () => context.read<PetFriendsCubit>().loadSentFriends(
            petId: SwitchProfileCubit.get(context).activeProfile!.pet!.petId!,
          ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            icon: IconlyBold.send,
            title: isArabic() ? 'الطلبات المرسلة' : 'Sent Requests',
            count: requests.length,
            color: Colors.purple,
          ),
          const SizedBox(height: 16),

          if (requests.isEmpty) ...[
            const SizedBox(height: 150),
            AmazingEmptyList(
              onPressed:
                  () => context.read<PetFriendsCubit>().loadSentFriends(
                    petId:
                        SwitchProfileCubit.get(
                          context,
                        ).activeProfile!.pet!.petId!,
                  ),
              icon: IconlyBold.send,
              message: isArabic() ? "لا توجد طلبات مرسلة" : "No Sent Requests",
            ),
          ] else ...[
            ...requests.asMap().entries.map(
              (entry) => AnimatedItem(
                index: entry.key,
                child: SentCard(pet: entry.value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
