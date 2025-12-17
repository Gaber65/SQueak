// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_cubit.dart';
import 'package:squeak/features/mating/profile/presentation/screens/view_pet_profile_screen.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_cubit.dart';

/// Original SentCard widget - now uses the reusable PetProfileCard
class SentCard extends StatelessWidget {
  final PetEntities pet;
  const SentCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return PetProfileCard(
      pet: pet,
      onTap: () {
        navigateToScreen(
          context,
          ViewPetProfileScreen(
            petId: pet.petId!,
            isDarkMode: MainCubit.get(context).isDark,
            isSent: true,
            activePetId:
                SwitchProfileCubit.get(context).activeProfile!.pet!.petId!,
          ),
        );
      },
      actions: [
        PetCardAction(
          icon: Icons.pets,
          label: S.of(context).viewProfile,
          colorType: PetCardActionColor.primary,
          onPressed: () {
            navigateToScreen(
              context,
              ViewPetProfileScreen(
                petId: pet.petId!,
                isDarkMode: MainCubit.get(context).isDark,
              ),
            );
          },
        ),
        PetCardAction(
          icon: Icons.cancel_outlined,
          label: S.of(context).cancelRequest,
          colorType: PetCardActionColor.danger,
          onPressed: () {
            context.read<PetFriendsCubit>().cancelRequest(
              pet,
              SwitchProfileCubit.get(context).activeProfile!.pet!.petId!,
            );
          },
        ),
      ],
    );
  }
}

class PetProfileCard extends StatelessWidget {
  final PetEntities pet;
  final VoidCallback? onTap;
  final List<PetCardAction> actions;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const PetProfileCard({
    super.key,
    required this.pet,
    this.onTap,
    this.actions = const [],
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.only(bottom: 16),
        padding: padding ?? EdgeInsets.all(size.width * 0.045),
        decoration: _buildCardDecoration(isDark),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PetHeader(pet: pet, size: size, isDark: isDark),
            const SizedBox(height: 16),
            // _PetInfoRow(pet: pet),
            if ((pet.mutualFriends ?? 0) > 0) ...[
              const SizedBox(height: 14),
              _MutualFriendsInfo(count: pet.mutualFriends!, isDark: isDark),
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 20),
              _ActionsRow(actions: actions, isDark: isDark),
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration(bool isDark) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors:
            isDark
                ? [const Color(0xFF1E1E1E), const Color(0xFF2A2A2A)]
                : [Colors.white, const Color(0xFFF9F9F9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color:
              isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _PetHeader extends StatelessWidget {
  final PetEntities pet;
  final Size size;
  final bool isDark;

  const _PetHeader({
    required this.pet,
    required this.size,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _PetAvatar(pet: pet, radius: size.width * 0.08, isDark: isDark),
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
                _buildSubtitle(),
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
    );
  }

  String _buildSubtitle() {
    final age =
        (pet.birthdate != null && pet.birthdate != '')
            ? formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))
            : null;
    final breed = pet.breed?.enBreed;

    if (age != null && breed != null) {
      return '$age • $breed';
    } else if (age != null) {
      return age;
    } else if (breed != null) {
      return breed;
    }
    return '';
  }
}

class _PetAvatar extends StatelessWidget {
  final PetEntities pet;
  final double radius;
  final bool isDark;

  const _PetAvatar({
    required this.pet,
    required this.radius,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors:
              isDark
                  ? [Colors.blueGrey[800]!, Colors.blueGrey[600]!]
                  : [Colors.blue[500]!, Colors.blue[300]!],
        ),
      ),
      padding: const EdgeInsets.all(3),
      child: CircleAvatar(
        radius: radius,
        backgroundImage:
            (pet.imageName?.isNotEmpty ?? false)
                ? NetworkImage(imageUrl + pet.imageName!)
                : null,
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
        child:
            (pet.imageName?.isNotEmpty ?? false)
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
    );
  }
}

// class _PetInfoRow extends StatelessWidget {
//   final PetEntities pet;

//   const _PetInfoRow({required this.pet});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _InfoPill(
//           icon: (pet.isSpayed ?? false)
//               ? Icons.check_circle_rounded
//               : Icons.warning_amber_rounded,
//           label: (pet.isSpayed ?? false)
//               ? (S.of(context).spayed)
//               : (S.of(context).notSpayed),
//           color: (pet.isSpayed ?? false) ? Colors.green : Colors.orange,
//         ),
//         _InfoPill(
//           icon: (pet.gender == 1) ? Icons.male : Icons.female,
//           label: (pet.gender == 1)
//               ? (S.of(context).male)
//               : (S.of(context).female),
//           color: (pet.gender == 1) ? Colors.blue : Colors.purple,
//         ),
//       ],
//     );
//   }
// }

// class _InfoPill extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final MaterialColor color;

//   const _InfoPill({
//     required this.icon,
//     required this.label,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 4),
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.5)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: color, size: 18),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: color[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _MutualFriendsInfo extends StatelessWidget {
  final int count;
  final bool isDark;

  const _MutualFriendsInfo({required this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                ? '$count صديق مشترك'
                : '$count mutual friend${count > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final List<PetCardAction> actions;
  final bool isDark;

  const _ActionsRow({required this.actions, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        actions.length,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index > 0 ? 6 : 0,
              right: index < actions.length - 1 ? 6 : 0,
            ),
            child: _ActionButton(action: actions[index], isDark: isDark),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final PetCardAction action;
  final bool isDark;

  const _ActionButton({required this.action, required this.isDark});

  Color _getColor() {
    switch (action.colorType) {
      case PetCardActionColor.primary:
        return isDark ? Colors.blue[300]! : Colors.blue[400]!;
      case PetCardActionColor.danger:
        return isDark ? Colors.red[300]! : Colors.red[400]!;
      case PetCardActionColor.success:
        return isDark ? Colors.green[300]! : Colors.green[400]!;
      case PetCardActionColor.warning:
        return isDark ? Colors.orange[300]! : Colors.orange[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return OutlinedButton.icon(
      onPressed: action.onPressed,
      icon: Icon(action.icon, size: 18, color: color),
      label: Text(
        action.label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: color,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 1.3),
        backgroundColor:
            isDark ? color.withOpacity(0.07) : color.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        elevation: 0,
      ),
    );
  }
}

class PetCardAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final PetCardActionColor colorType;

  const PetCardAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.colorType = PetCardActionColor.primary,
  });
}

enum PetCardActionColor { primary, danger, success, warning }
