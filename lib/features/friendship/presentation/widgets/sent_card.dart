// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_cubit.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_cubit.dart';

class SentCard extends StatelessWidget {
  final PetEntities pet;
  const SentCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final shadowColor = isDark
        ? Colors.black.withOpacity(0.4)
        : Colors.grey.withOpacity(0.2);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(size.width * 0.045),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1E1E), const Color(0xFF2A2A2A)]
              : [Colors.white, const Color(0xFFF9F9F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.blueGrey[800]!, Colors.blueGrey[600]!]
                        : [Colors.blue[500]!, Colors.blue[300]!],
                  ),
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: size.width * 0.08,
                  backgroundImage: (pet.imageName?.isNotEmpty ?? false)
                      ? NetworkImage(imageUrl + pet.imageName!)
                      : null,
                  backgroundColor:
                      isDark ? Colors.grey[800] : Colors.grey[300],
                  child: (pet.imageName?.isNotEmpty ?? false)
                      ? null
                      : Text(
                          pet.petName!.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.petName ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (pet.birthdate != null && pet.birthdate != '')
                          ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))}${pet.breed?.enBreed != null ? " • ${pet.breed!.enBreed}" : ""}"
                          : pet.breed?.enBreed ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          // Spayed/Unspayed indicator - Hidden as requested
          /*
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: (pet.isSpayed ?? false)
                    ? [Colors.green.withOpacity(0.15), Colors.green.withOpacity(0.05)]
                    : [Colors.orange.withOpacity(0.15), Colors.orange.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (pet.isSpayed ?? false)
                    ? Colors.green.withOpacity(0.5)
                    : Colors.orange.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  (pet.isSpayed ?? false)
                      ? Icons.check_circle_rounded
                      : Icons.warning_amber_rounded,
                  color: (pet.isSpayed ?? false)
                      ? Colors.green
                      : Colors.orange,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  (pet.isSpayed ?? false)
                      ? (isArabic() ? 'معقم' : 'Spayed')
                      : (isArabic() ? 'غير معقم' : 'Unspayed'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: (pet.isSpayed ?? false)
                        ? Colors.green[700]
                        : Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
          */

          /// 🫂 Mutual Friends
          if ((pet.mutualFriends ?? 0) > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  size: 18,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    isArabic()
                        ? '${pet.mutualFriends} صديق مشترك'
                        : '${pet.mutualFriends} mutual friend${pet.mutualFriends! > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<PetFriendsCubit>().cancelRequest(
                      pet,
                      SwitchProfileCubit.get(context)
                          .activeProfile!
                          .pet!
                          .petId!,
                    );
              },
              icon: Icon(
                Icons.cancel_outlined,
                size: 18,
                color: isDark ? Colors.red[300] : Colors.red[400],
              ),
              label: Text(
                isArabic()
                    ? 'إلغاء طلب الصداقة'
                    : 'Cancel Friendship Request',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: isDark ? Colors.red[300] : Colors.red[400],
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark ? Colors.red[300]! : Colors.red[400]!,
                  width: 1.3,
                ),
                backgroundColor: isDark
                    ? Colors.red.withOpacity(0.07)
                    : Colors.red.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
