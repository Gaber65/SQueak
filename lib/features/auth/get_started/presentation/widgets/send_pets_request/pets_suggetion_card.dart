// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../../../core/utils/export_path/export_files.dart';
import '../../../../../friendship/presentation/controllers/pet_friend_cubit.dart';
import '../../../../../friendship/presentation/controllers/pet_friend_state.dart';

class PetsSuggetionRequestCard extends StatelessWidget {
  final PetEntities pet;
  final String activePetId; // إضافة معرف الحيوان النشط

  const PetsSuggetionRequestCard({
    super.key,
    required this.pet,
    required this.activePetId, // مطلوب الآن
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final primaryGradient = [Color(0xFF6366F1), Color(0xFF8B5CF6)];
    final petFriendsCubit = context.watch<PetFriendsCubit>();
    final isSentRequest = petFriendsCubit.sentRequests.contains(pet);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.008,
        horizontal: size.width * 0.04,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDark
                  ? [Color(0xFF1a1a2e), Color(0xFF16213e)]
                  : [Colors.white, Color(0xFFF8F9FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.blue).withOpacity(
              isDark ? 0.3 : 0.08,
            ),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: (isDark ? Colors.white : Colors.blue).withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with gradient border
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: primaryGradient),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGradient[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: size.width * 0.095,
                    backgroundImage:
                        pet.imageName?.isNotEmpty == true
                            ? NetworkImage(imageUrl + pet.imageName!)
                            : null,
                    backgroundColor: Colors.white,
                    child:
                        pet.imageName?.isNotEmpty == true
                            ? null
                            : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: primaryGradient,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  pet.petName?.substring(0, 1) ?? "?",
                                  style: TextStyle(
                                    fontSize: size.width * 0.08,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Color(0xFF1a1a2e) : Colors.white,
                        width: 2.5,
                      ),
                    ),
                    child: Icon(
                      Icons.pets,
                      size: size.width * 0.035,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.petName ?? "Unknown",
                          style: TextStyle(
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Color(0xFF1F2937),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("🐾", style: TextStyle(fontSize: 14)),
                    ],
                  ),

                  SizedBox(height: size.height * 0.006),
                  Row(
                    children: [
                      Icon(
                        Icons.cake_outlined,
                        size: size.width * 0.035,
                        color: isDark ? Color(0xFF9CA3AF) : Color(0xFF6B7280),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          (pet.birthdate != null && pet.birthdate!.isNotEmpty)
                              ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))} • ${pet.breed?.enBreed ?? ""}"
                              : pet.breed?.enBreed ?? "",
                          style: TextStyle(
                            fontSize: size.width * 0.033,
                            color:
                                isDark ? Color(0xFF9CA3AF) : Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  if (pet.mutualFriends != null && pet.mutualFriends! > 0)
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.006),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF6366F1).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: size.width * 0.032,
                              color: Color(0xFF6366F1),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "${pet.mutualFriends} mutual friends",
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                color: Color(0xFF6366F1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  SizedBox(height: size.height * 0.012),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isSentRequest
                                  ? [Color(0xFFEF4444), Color(0xFFDC2626)]
                                  : [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (isSentRequest
                                        ? Color(0xFFEF4444)
                                        : Color(0xFF6366F1))
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.012,
                              ),
                              minimumSize: const Size(0, 38),
                            ),
                            icon: Icon(
                              isSentRequest
                                  ? Icons.close
                                  : Icons.person_add_alt_1_rounded,
                              size: size.width * 0.045,
                            ),
                            label: Text(
                              isSentRequest
                                  ? (isArabic() ? "إلغاء" : "Cancel")
                                  : (isArabic() ? "إضافة" : "Add"),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                            onPressed: () {
                              if (isSentRequest) {
                                context.read<PetFriendsCubit>().cancelRequest(
                                      pet,
                                      activePetId,
                                    );
                              } else {
                                context
                                    .read<PetFriendsCubit>()
                                    .sendFriendRequest(
                                      pet,
                                      activePetId,
                                    );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.025),
                      if (!isSentRequest)
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color:
                                    isDark
                                        ? Color(0xFFEF4444).withOpacity(0.8)
                                        : Color(0xFFEF4444),
                                width: 1.8,
                              ),
                              foregroundColor: Color(0xFFEF4444),
                              backgroundColor:
                                  isDark
                                      ? Color(0xFFEF4444).withOpacity(0.05)
                                      : Color(0xFFEF4444).withOpacity(0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.012,
                              ),
                              minimumSize: const Size(0, 38),
                            ),
                            icon: Icon(
                              Icons.close_rounded,
                              size: size.width * 0.045,
                            ),
                            label: Text(
                              isArabic() ? "رفض" : "Remove",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                            onPressed: () {
                              context
                                  .read<PetFriendsCubit>()
                                  .suggestedFriends
                                  .remove(pet);
                              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                              PetFriendsCubit.get(
                                context,
                              ).emit(SuggestedFriendsLoading());
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}