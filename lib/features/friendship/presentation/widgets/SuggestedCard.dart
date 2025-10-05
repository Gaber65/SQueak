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
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive sizing
    final isTablet = screenWidth > 600;
    final cardPadding = isTablet ? 24.0 : 18.0;
    final avatarRadius = isTablet ? 36.0 : 32.0;
    final nameSize = isTablet ? 19.0 : 17.0;
    final subTextSize = isTablet ? 14.5 : 13.5;

    // Universal gender-neutral colors
    final cardColor = isDark 
        ? Color(0xFF1C1C1E) 
        : Colors.white;
    final cardGradientOverlay = isDark
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C2C2E).withOpacity(0.5),
              Color(0xFF1C1C1E).withOpacity(0.3),
            ],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFFAFBFC),
            ],
          );
    
    final shadowColor = isDark 
        ? Colors.black.withOpacity(0.4) 
        : Colors.black.withOpacity(0.06);
    final nameColor = isDark 
        ? Color(0xFFF5F5F7) 
        : Color(0xFF1C1C1E);
    final subTextColor = isDark 
        ? Color(0xFFAEAEB2) 
        : Color(0xFF636366);
    
    // Professional teal/blue accent - appeals to all
    final accentColor = isDark
        ? Color(0xFF5AC8FA) // iOS blue
        : Color(0xFF007AFF); // Classic blue
    
    final mutualBgColor = isDark
        ? Color(0xFF2C2C2E)
        : Color(0xFFF2F2F7);

    return Container(
      margin: EdgeInsets.only(
        bottom: isTablet ? 16 : 14,
        left: isTablet ? 8 : 4,
        right: isTablet ? 8 : 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowColor.withOpacity(0.5),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: cardGradientOverlay,
            border: Border.all(
              color: isDark 
                  ? Colors.white.withOpacity(0.08) 
                  : Colors.black.withOpacity(0.04),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Subtle decorative elements
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accentColor.withOpacity(0.08),
                        accentColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Icon(
                  Icons.pets_rounded,
                  size: 80,
                  color: accentColor.withOpacity(0.04),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Pet Avatar with modern gradient border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withOpacity(0.8),
                                accentColor.withOpacity(0.4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(3.5),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cardColor,
                            ),
                            padding: EdgeInsets.all(2.5),
                            child: CircleAvatar(
                              radius: avatarRadius,
                              backgroundColor: isDark 
                                  ? Color(0xFF3A3A3C) 
                                  : Color(0xFFE5E5EA),
                              backgroundImage: pet.imageName?.isNotEmpty == true
                                  ? NetworkImage(imageUrl + pet.imageName!)
                                  : null,
                              child: pet.imageName?.isNotEmpty != true
                                  ? Text(
                                      pet.petName!.substring(0, 1).toUpperCase(),
                                      style: TextStyle(
                                        fontSize: avatarRadius * 0.65,
                                        fontWeight: FontWeight.w700,
                                        color: accentColor,
                                        letterSpacing: 1,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: isTablet ? 18 : 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      pet.petName!,
                                      style: TextStyle(
                                        fontSize: nameSize,
                                        fontWeight: FontWeight.w700,
                                        color: nameColor,
                                        letterSpacing: 0.2,
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: accentColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.pets,
                                      size: isTablet ? 15 : 13,
                                      color: accentColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.cake_outlined,
                                    size: isTablet ? 15 : 13,
                                    color: subTextColor,
                                  ),
                                  SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      (pet.birthdate != null && pet.birthdate != '')
                                          ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))}${pet.breed?.enBreed != null ? " • ${pet.breed!.enBreed}" : ""}"
                                          : pet.breed?.enBreed ?? "Mixed breed",
                                      style: TextStyle(
                                        fontSize: subTextSize,
                                        color: subTextColor,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.1,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (pet.mutualFriends! > 0) ...[
                      SizedBox(height: isTablet ? 16 : 14),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 16 : 14,
                          vertical: isTablet ? 12 : 10,
                        ),
                        decoration: BoxDecoration(
                          color: mutualBgColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.06)
                                : Colors.black.withOpacity(0.04),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6),
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
                                    size: isTablet ? 18 : 16,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                '${pet.mutualFriends} ${isArabic() ? 'صديق مشترك' : 'mutual friend${pet.mutualFriends! > 1 ? 's' : ''}'}',
                                style: TextStyle(
                                  fontSize: isTablet ? 13.5 : 12.5,
                                  color: isDark ? Color(0xFFAEAEB2) : Color(0xFF48484A),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: isTablet ? 18 : 16),
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
                        PetFriendsCubit.get(context).emit((SuggestedFriendsLoading()));
                      },
                      onSent: () {
                        context.read<PetFriendsCubit>().sendFriendRequest(
                          pet,
                          SwitchProfileCubit.get(context).activeProfile!.pet!.petId!,
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
  bool _isRejectPressed = false;
  bool _isAcceptPressed = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
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
    final buttonHeight = widget.isTablet ? 54.0 : 50.0;
    final fontSize = widget.isTablet ? 15.5 : 15.0;
    final iconSize = widget.isTablet ? 20.0 : 18.0;

    // Professional color schemes
    final primaryColor = isDark ? Color(0xFF0A84FF) : Color(0xFF007AFF);
    final successColor = isDark ? Color(0xFF32D74B) : Color(0xFF34C759);
    final dangerColor = isDark ? Color(0xFFFF453A) : Color(0xFFFF3B30);
    final neutralColor = isDark ? Color(0xFF48484A) : Color(0xFFE5E5EA);

    final rejectGradient = isDark
        ? [Color(0xFF3A3A3C), Color(0xFF2C2C2E)]
        : [Color(0xFFF2F2F7), Color(0xFFE5E5EA)];
    
    final acceptGradient = [
      primaryColor,
      primaryColor.withOpacity(0.85),
    ];

    final unsentGradient = [
      dangerColor,
      dangerColor.withOpacity(0.85),
    ];

    final rejectTextColor = isDark ? Color(0xFFEBEBF5) : Color(0xFF48484A);
    final acceptTextColor = Colors.white;

    final isSent = PetFriendsCubit.get(context).sentRequests.contains(widget.pet);

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
                      colors: _isAcceptPressed
                          ? (isSent
                              ? unsentGradient.reversed.toList()
                              : acceptGradient.reversed.toList())
                          : (isSent ? unsentGradient : acceptGradient),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(widget.isTablet ? 16 : 14),
                    boxShadow: [
                      BoxShadow(
                        color: (isSent ? dangerColor : primaryColor)
                            .withOpacity(0.35),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(widget.isTablet ? 16 : 14),
                      onTap: isSent ? widget.onCancel : widget.onSent,
                      onHighlightChanged: (pressed) {
                        setState(() {
                          _isAcceptPressed = pressed;
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
                              isSent ? Icons.close_rounded : Icons.person_add_alt_1_rounded,
                              size: iconSize,
                              color: acceptTextColor,
                            ),
                            if (!isNarrow || !isSent) ...[
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  isSent
                                      ? (isArabic() ? "إلغاء الطلب" : 'Cancel')
                                      : (isArabic() ? 'إضافة صديق' : 'Add Friend'),
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
            if (!isSent) ...[
              SizedBox(width: widget.isTablet ? 14 : 12),
              Expanded(
                flex: 2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: buttonHeight,
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isRejectPressed
                          ? rejectGradient.reversed.toList()
                          : rejectGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(widget.isTablet ? 16 : 14),
                    border: Border.all(
                      color: isDark
                          ? Color(0xFF48484A)
                          : Color(0xFFD1D1D6),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(widget.isTablet ? 16 : 14),
                      onTap: widget.onDismiss,
                      onHighlightChanged: (pressed) {
                        setState(() {
                          _isRejectPressed = pressed;
                        });
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