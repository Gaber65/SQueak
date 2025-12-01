// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/core/service/global_function/time_format.dart';
import 'package:squeak/core/utils/theme/navigation_helper/navigation.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/mating/profile/presentation/screens/view_pet_profile_screen.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import 'package:squeak/generated/l10n.dart';

import '../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../controllers/pet_friend_cubit.dart';

class SuggestedCard extends StatelessWidget {
  final PetEntities pet;

  const SuggestedCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing
    final isTablet = screenWidth > 600;
    final cardPadding = isTablet ? 24.0 : 20.0;
    final avatarRadius = isTablet ? 40.0 : 36.0;
    final nameSize = isTablet ? 20.0 : 18.0;
    final subTextSize = isTablet ? 14.0 : 13.0;

    // Modern color scheme
    final cardColor = isDark ? Color(0xFF1C1C1E) : Colors.white;
    final shadowColor =
        isDark ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.08);
    final nameColor = isDark ? Color(0xFFF5F5F7) : Color(0xFF1C1C1E);
    final subTextColor = isDark ? Color(0xFFAEAEB2) : Color(0xFF8E8E93);
    final accentColor = isDark ? Color(0xFF0A84FF) : Color(0xFF007AFF);
    final mutualBgColor = isDark ? Color(0xFF2C2C2E) : Color(0xFFF2F2F7);
    final dividerColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);

    return GestureDetector(
      onTap: (){
        navigateToScreen(
                    context,
                    ViewPetProfileScreen(
                      petId:pet.petId!,
                      isDarkMode: MainCubit.get(context).isDark,
                      isFriend: false,
                      activePetId: SwitchProfileCubit.get(context)
                          .activeProfile!
                          .pet!
                          .petId!,
                    ),
                  );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: isTablet ? 20 : 16,
          left: isTablet ? 12 : 8,
          right: isTablet ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
          border: Border.all(
            color:
                isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 24,
              offset: Offset(0, 8),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: shadowColor.withOpacity(0.5),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
          child: Stack(
            children: [
              // Gradient overlay for depth
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          isDark
                              ? [
                                Color(0xFF2C2C2E).withOpacity(0.3),
                                Colors.transparent,
                              ]
                              : [Colors.white, Color(0xFFFAFBFC)],
                    ),
                  ),
                ),
              ),
      
              // Decorative background elements
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accentColor.withOpacity(0.1),
                        accentColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
      
              Positioned(
                bottom: -30,
                left: -30,
                child: Icon(
                  Icons.pets_rounded,
                  size: 100,
                  color: accentColor.withOpacity(0.05),
                ),
              ),
      
              // Main content
              Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar and basic info section
                    Row(
                      children: [
                        // Enhanced pet avatar
                        _buildPetAvatar(
                          pet: pet,
                          isDark: isDark,
                          avatarRadius: avatarRadius,
                          accentColor: accentColor,
                          cardColor: cardColor,
                        ),
      
                        SizedBox(width: isTablet ? 18 : 16),
      
                        // Pet info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name with badge
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      pet.petName!,
                                      style: TextStyle(
                                        fontSize: nameSize,
                                        fontWeight: FontWeight.w800,
                                        color: nameColor,
                                        letterSpacing: 0.3,
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          accentColor.withOpacity(0.2),
                                          accentColor.withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.pets,
                                      size: isTablet ? 16 : 14,
                                      color: accentColor,
                                    ),
                                  ),
                                ],
                              ),
      
                              SizedBox(height: 8),
      
                              // Age and breed
                              _buildInfoRow(
                                icon: Icons.cake_outlined,
                                text:
                                    (pet.birthdate != null && pet.birthdate != '')
                                        ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))}${pet.breed?.enBreed != null ? " • ${pet.breed!.enBreed}" : ""}"
                                        : pet.breed?.enBreed ?? "Mixed breed",
                                color: subTextColor,
                                fontSize: subTextSize,
                                isTablet: isTablet,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
      
                    SizedBox(height: isTablet ? 20 : 18),
      
                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            dividerColor,
                            dividerColor.withOpacity(0.1),
                            dividerColor,
                          ],
                        ),
                      ),
                    ),
      
                    SizedBox(height: isTablet ? 20 : 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusChip(
                          icon:
                              pet.isSpayed == true
                                  ? Icons.check_circle_rounded
                                  : Icons.info_rounded,
                          label:
                              pet.isSpayed == true
                                  ? S.of(context).spayed
                                  : S.of(context).notSpayed,
                          color:
                              pet.isSpayed == true
                                  ? Color(0xFF34C759)
                                  : Color(0xFFFF3B30),
                          isTablet: isTablet,
                        ),
      
                        SizedBox(width: 12),
                        _buildStatusChip(
                          icon: pet.gender == 1 ? Icons.male : Icons.female,
                          label:
                              pet.gender == 1
                                  ? S.of(context).male
                                  : S.of(context).female,
                          color:
                              pet.gender == 1
                                  ? Color(0xFF007AFF)
                                  : Color(0xFFFF2D55),
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                    if (pet.mutualFriends! > 0) ...[
                      SizedBox(height: isTablet ? 20 : 18),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 16 : 14,
                          vertical: isTablet ? 14 : 12,
                        ),
                        decoration: BoxDecoration(
                          color: mutualBgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: dividerColor, width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    accentColor.withOpacity(0.2),
                                    accentColor.withOpacity(0.1),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.people_rounded,
                                size: isTablet ? 20 : 18,
                                color: accentColor,
                              ),
                            ),
                            SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                '${pet.mutualFriends} ${isArabic() ? 'صديق مشترك' : 'mutual friend${pet.mutualFriends! > 1 ? 's' : ''}'}',
                                style: TextStyle(
                                  fontSize: isTablet ? 14.0 : 13.0,
                                  color:
                                      isDark
                                          ? Color(0xFFAEAEB2)
                                          : Color(0xFF48484A),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
      
                    SizedBox(height: isTablet ? 24 : 20),
                    FriendActionButton(
                      onCancel: () {
                        context.read<PetFriendsCubit>().cancelRequest(
                          pet,
                          SwitchProfileCubit.get(
                            context,
                          ).activeProfile!.pet!.petId!,
                        );
                      },
                      pet: pet,
                      onDismiss: () {
                        context.read<PetFriendsCubit>().suggestedFriends.remove(
                          pet,
                        );
                        PetFriendsCubit.get(
                          context,
                        ).emit((SuggestedFriendsLoading()));
                      },
                      onSent: () {
                        context.read<PetFriendsCubit>().sendFriendRequest(
                          pet,
                          SwitchProfileCubit.get(
                            context,
                          ).activeProfile!.pet!.petId!,
                        );
                      },
                      isTablet: isTablet,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetAvatar({
    required PetEntities pet,
    required bool isDark,
    required double avatarRadius,
    required Color accentColor,
    required Color cardColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.8), accentColor.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.4),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(3.5),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: cardColor),
        padding: EdgeInsets.all(3),
        child: CircleAvatar(
          radius: avatarRadius,
          backgroundColor: isDark ? Color(0xFF3A3A3C) : Color(0xFFE5E5EA),
          backgroundImage:
              pet.imageName?.isNotEmpty == true
                  ? NetworkImage(imageUrl + pet.imageName!)
                  : null,
          child:
              pet.imageName?.isNotEmpty != true
                  ? Text(
                    pet.petName!.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: avatarRadius * 0.7,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                      letterSpacing: 1,
                    ),
                  )
                  : null,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color color,
    required double fontSize,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Icon(icon, size: isTablet ? 16 : 14, color: color),
        SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required Color color,
    required bool isTablet,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: isTablet ? 24 : 20, color: color),
        SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 16.5 : 14.5,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class FriendActionButton extends StatefulWidget {
  final VoidCallback onDismiss;
  final VoidCallback onCancel;
  final VoidCallback onSent;
  final PetEntities pet;
  final bool isTablet;

  const FriendActionButton({
    required this.onDismiss,
    required this.onSent,
    required this.onCancel,
    required this.pet,
    this.isTablet = false,
    super.key,
  });

  @override
  State<FriendActionButton> createState() => _FriendActionButtonState();
}

class _FriendActionButtonState extends State<FriendActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MainCubit.get(context).isDark;
    final buttonHeight = widget.isTablet ? 56.0 : 52.0;
    final fontSize = widget.isTablet ? 16.0 : 15.0;
    final iconSize = widget.isTablet ? 22.0 : 20.0;

    final primaryColor = isDark ? Color(0xFF0A84FF) : Color(0xFF007AFF);
    final dangerColor = isDark ? Color(0xFFFF453A) : Color(0xFFFF3B30);
    final rejectBgColor = isDark ? Color(0xFF2C2C2E) : Color(0xFFF2F2F7);
    final rejectTextColor = isDark ? Color(0xFFEBEBF5) : Color(0xFF48484A);
    final acceptTextColor = Colors.white;

    final isSent = PetFriendsCubit.get(
      context,
    ).sentRequests.contains(widget.pet);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 350;
        return Row(
          children: [
            Expanded(
              flex: isSent ? 1 : 3,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: buttonHeight,
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isSent
                              ? [dangerColor, dangerColor.withOpacity(0.85)]
                              : [primaryColor, primaryColor.withOpacity(0.9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      widget.isTablet ? 18 : 16,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isSent ? dangerColor : primaryColor)
                            .withOpacity(0.4),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        widget.isTablet ? 18 : 16,
                      ),
                      onTap: isSent ? widget.onCancel : widget.onSent,
                      onHighlightChanged: (pressed) {
                        setState(() {
                          if (pressed) {
                            _scaleController.forward();
                          } else {
                            _scaleController.reverse();
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 12 : 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSent ? Icons.close_rounded : Icons.pets,
                              size: iconSize,
                              color: acceptTextColor,
                            ),
                            if (!isNarrow || !isSent) ...[
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  isSent
                                      ? (isArabic() ? "إلغاء الطلب" : 'Cancel')
                                      : (isArabic()
                                          ? 'إضافة صديق'
                                          : 'Furry Friend'),
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w700,
                                    color: acceptTextColor,
                                    letterSpacing: 0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        
            // Dismiss button (only shown when not sent)
            if (!isSent) ...[
              SizedBox(width: widget.isTablet ? 14 : 12),
              Expanded(
                flex: 2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: buttonHeight,
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: rejectBgColor,
                    borderRadius: BorderRadius.circular(
                      widget.isTablet ? 18 : 16,
                    ),
                    border: Border.all(
                      color: isDark ? Color(0xFF48484A) : Color(0xFFD1D1D6),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        widget.isTablet ? 18 : 16,
                      ),
                      onTap: widget.onDismiss,
                      onHighlightChanged: (pressed) {
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 12 : 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.block_rounded,
                              size: iconSize,
                              color: rejectTextColor,
                            ),
                            if (!isNarrow) ...[
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  isArabic() ? 'رفض' : 'Dismiss',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                    color: rejectTextColor,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
