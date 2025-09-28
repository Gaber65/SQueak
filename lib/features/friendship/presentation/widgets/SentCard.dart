import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/network/end-points.dart';
import 'package:squeak/core/service/global_function/time_format.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      (pet.birthdate != null && pet.birthdate != '')
                          ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))}${pet.breed?.enBreed != null ? " • ${pet.breed!.enBreed}" : ""}"
                          : pet.breed?.enBreed ?? "",
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
          const SizedBox(height: 8),
          if (pet.isSpayed ?? false)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Healthy',

                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ),
          if ((pet.mutualFriends ?? 0) > 0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                isArabic()  ?  '${pet.mutualFriends} صديق${pet.mutualFriends! > 1 ? 's' : ''}'  :  '${pet.mutualFriends} mutual friend${pet.mutualFriends! > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<PetFriendsCubit>().cancelRequest(
                  pet,
                  SwitchProfileCubit.get(context).specieId,
                );
              },
              icon: Icon(Icons.close, size: 16, color: isDark ? Colors.grey[300] : Colors.grey[700]),
              label: Text(
               isArabic()  ?  'إلغاء طلب الصداقة'  :  'Cancel Friendship Request',
                style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: isDark ? Colors.grey[900] : Colors.transparent,
                side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
