// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/friendship/domain/entities/friend_request_stats.dart';
import 'package:squeak/features/friendship/domain/entities/pet_friend_request_entity.dart';

class RequestCard extends StatelessWidget {
  final PetFriendRequestEntity pet;

  const RequestCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    final shadowColor =
    isDark ? Colors.black26 : Colors.black.withOpacity(0.05);

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
          /// 🐶 Pet Info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  imageUrl + (pet.friendPetImage),
                ),
                child: (pet.friendPetImage.isEmpty)
                    ? Text(
                  pet.friendPetName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.friendPetName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      formatAge(DateTime.parse(
                        pet.friendPetAge.substring(0, 10),
                      )),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),

          const SizedBox(height: 16),

          /// 🎯 Action Buttons
          Row(
            children: [
              Expanded(
                child: FriendActionButton(
                  label:isArabic() ? "دعنا نلعب!" : "Let's Pawty!",
                  icon: Icons.pets,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<PetFriendsCubit>().updateFriendRequest(
                      pet,
                      FriendshipStatus.accepted,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FriendActionButton(
                  label: isArabic() ? "لا الآن" : "Not Now",
                  icon: Icons.close,
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]!
                      : Colors.grey[700]!,
                  outlined: true,
                  onPressed: () {
                    context.read<PetFriendsCubit>().updateFriendRequest(
                      pet,
                      FriendshipStatus.rejected,
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FriendActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final bool outlined;

  const FriendActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rejectGradient =
    isDark
        ? [Colors.grey[800]!, Colors.grey[700]!]
        : [Color(0xFFF5F5F5), Color(0xFFE8E8E8)];
    if (outlined) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
            rejectGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Color(0xFFE0E0E0),
            width: 2,
          ),
        ),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 16, color: textColor),
          label: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: textColor,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: textColor),
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: textColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        shadowColor: backgroundColor.withOpacity(0.3),
      ),
    );
  }
}
