import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/network/end-points.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/core/service/global_function/time_format.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_cubit.dart';

import '../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../controllers/pet_friend_cubit.dart';

class SuggestedCard extends StatelessWidget {
  final PetEntities pet;

  const SuggestedCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    final shadowColor =
        // ignore: deprecated_member_use
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
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.petName!,
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
          if (pet.mutualFriends! > 0) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: subTextColor),
                SizedBox(width: 4),
                Text(
                  '${pet.mutualFriends} mutual friends',
                  style: TextStyle(fontSize: 12, color: subTextColor),
                ),
              ],
            ),
          ],
          SizedBox(height: 12),
          FriendActionButton(
            onCancel: () {
              context.read<PetFriendsCubit>().cancelRequest(
                pet,
                SwitchProfileCubit.get(context).activeProfile!.pet!.petId!,
              );
            },
            pet: pet,
            onDismiss: () {
              context.read<PetFriendsCubit>().suggestedFriends.remove(pet);
              // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
              PetFriendsCubit.get(context).emit((SuggestedFriendsLoading()));
            },
            onSent: () {
              context.read<PetFriendsCubit>().sendFriendRequest(
                pet,
                SwitchProfileCubit.get(context).activeProfile!.pet!.petId!,
              );
            },
          ),
        ],
      ),
    );
  }
}

class FriendActionButton extends StatefulWidget {
  final VoidCallback onDismiss;
  final VoidCallback onCancel;
  final VoidCallback onSent;
  final PetEntities pet;

  const FriendActionButton({
    required this.onDismiss,
    required this.onSent,
    required this.onCancel,
    required this.pet,
    super.key,
  });

  @override
  State<FriendActionButton> createState() => _FriendActionButtonState();
}

class _FriendActionButtonState extends State<FriendActionButton> {
  bool _isRejectPressed = false;
  bool _isAcceptPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = MainCubit.get(context).isDark;

    final rejectGradient =
        isDark
            ? [Colors.grey[800]!, Colors.grey[700]!]
            : [Color(0xFFF5F5F5), Color(0xFFE8E8E8)];
    final acceptGradient =
        isDark
            ? [Colors.green[700]!, Colors.green[600]!]
            : [Colors.green[400]!, Colors.green[300]!];

    final unsentGradient =
        isDark
            ? [Colors.red[700]!, Colors.red[600]!]
            : [Colors.red[400]!, Colors.red[300]!];

    final rejectTextColor = isDark ? Colors.white70 : Colors.grey[700];
    final acceptTextColor = isDark ? Colors.white : Colors.white;

    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    _isAcceptPressed
                        ? (PetFriendsCubit.get(
                              context,
                            ).sentRequests.contains(widget.pet)
                            ? unsentGradient.reversed.toList()
                            : acceptGradient.reversed.toList())
                        : (PetFriendsCubit.get(
                              context,
                            ).sentRequests.contains(widget.pet)
                            ? unsentGradient
                            : acceptGradient),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap:
                    PetFriendsCubit.get(
                          context,
                        ).sentRequests.contains(widget.pet)
                        ? widget.onCancel
                        : widget.onSent,
                onHighlightChanged: (pressed) {
                  setState(() {
                    _isAcceptPressed = pressed;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PetFriendsCubit.get(
                              context,
                            ).sentRequests.contains(widget.pet)
                            ? Icons.close
                            : Icons.check,
                        size: 16,
                        color: acceptTextColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        PetFriendsCubit.get(
                              context,
                            ).sentRequests.contains(widget.pet)
                            ? (isArabic() ? "الغاء " : 'Cancel ')
                            : (isArabic() ? 'اضافة صديق' : 'Add friend'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: acceptTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 12),
        if (!PetFriendsCubit.get(context).sentRequests.contains(widget.pet))
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      _isRejectPressed
                          ? rejectGradient.reversed.toList()
                          : rejectGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey[600]! : Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: widget.onDismiss,
                  onHighlightChanged: (pressed) {
                    setState(() {
                      _isRejectPressed = pressed;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, size: 16, color: rejectTextColor),
                        SizedBox(width: 8),
                        Text(
                          isArabic() ? 'رفض' : 'Dismiss',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: rejectTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
