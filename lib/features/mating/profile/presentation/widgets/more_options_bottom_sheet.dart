import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/friendship/presentation/widgets/cancel_daialog.dart';
import 'option_menu_item.dart';
import 'block_user_dialog.dart';

class MoreOptionsBottomSheet extends StatelessWidget {
  final PetEntities pet;
  final bool isDark;
  final String? activePetId;

  const MoreOptionsBottomSheet({
    super.key,
    required this.pet,
    required this.isDark,
    this.activePetId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          OptionMenuItem(
            icon: Icons.block,
            label: S.of(context).block,
            gradientColors: isDark
                ? [const Color(0xFF3B3F46), const Color(0xFF1F2430)]
                : [const Color(0xFFFF6B35), const Color(0xFFFF8E53)],
            onTap: () {
              Navigator.pop(context);
              _showBlockDialog(context);
            },
          ),
          const SizedBox(height: 12),
          OptionMenuItem(
            icon: Icons.person_remove,
            label: S.of(context).cancelFriend,
            gradientColors: isDark
                ? [const Color(0xFF3B3F46), const Color(0xFF1F2430)]
                : [const Color(0xFFB91C1C), const Color(0xFFEF4444)],
            onTap: () {
              Navigator.pop(context);
              _showCancelFriendDialog(context);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showBlockDialog(BuildContext context) {
    // Get all required references before showing dialog
    String? matingPetId = activePetId;
    if (matingPetId == null) {
      try {
        final switchProfileCubit = context.read<SwitchProfileCubit>();
        matingPetId = switchProfileCubit.activeProfile?.pet?.petId;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    
    if (matingPetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Capture references before async operations
    final petFriendsCubit = context.read<PetFriendsCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final capturedMatingPetId = matingPetId;
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlockUserDialog(
          pet: pet,
          onConfirmBlock: () async {
            // Close the block dialog first
            Navigator.of(dialogContext).pop();
            
            // Show loading dialog using root navigator
            showDialog(
              context: dialogContext,
              barrierDismissible: false,
              useRootNavigator: true,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            try {
              await petFriendsCubit.blockFriend(pet, capturedMatingPetId);
              
              rootNavigator.pop(); // Close loading
              
              // Navigate back to the layout/home screen
              rootNavigator.popUntil((route) => route.isFirst);
              
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('Blocked successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              rootNavigator.pop(); // Close loading
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('Failed to block user'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  void _showCancelFriendDialog(BuildContext context) {
    String? matingPetId = activePetId;
    if (matingPetId == null) {
      try {
        final switchProfileCubit = context.read<SwitchProfileCubit>();
        matingPetId = switchProfileCubit.activeProfile?.pet?.petId;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    
    if (matingPetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Capture references before async operations
    final petFriendsCubit = context.read<PetFriendsCubit>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final capturedMatingPetId = matingPetId;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CancelFriendDialog(
          pet: pet,
          onConfirmCancel: () async {
            try {
              await petFriendsCubit.deleteFriendship(
                pet,
                capturedMatingPetId,
              );
              
              // Wait a bit for the state to update
              await Future.delayed(const Duration(milliseconds: 100));
              
              // Navigate back to the layout/home screen
              navigator.popUntil((route) => route.isFirst);
              
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('Friend removed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              return true;
            } catch (e) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('Failed to remove friend: $e'),
                  backgroundColor: Colors.red,
                ),
              );
              return false;
            }
          },
        );
      },
    );
  }
}
