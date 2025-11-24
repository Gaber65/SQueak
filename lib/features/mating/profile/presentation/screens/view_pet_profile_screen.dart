import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/domain/entities/friend_request_stats.dart';
import 'package:squeak/features/friendship/domain/entities/pet_friend_request_entity.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../widgets/pet_profile_header.dart';
import '../widgets/pet_tabs_section.dart';
import '../widgets/message_and_info_buttons.dart';
import '../widgets/more_options_bottom_sheet.dart';
import '../widgets/pet_info_popup.dart';

class ViewPetProfileScreen extends StatelessWidget {
  final bool isDarkMode;
  final String petId;
  final bool? isFriend;
  final bool? fromMating;
  final bool? isReceived;
  final bool? isSent;
  final String? activePetId;
  final String? conversationId;
  final PetFriendRequestEntity? requestEntity;

  const ViewPetProfileScreen({
    super.key,
    this.isDarkMode = false,
    required this.petId,
    this.isFriend,
    this.fromMating,
    this.isReceived,
    this.isSent,
    this.activePetId,
    this.conversationId,
    this.requestEntity,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<ProfileMatingCubit>()
                    ..getPetProfileMating(petId)
                    ..getPetProfileMatingHistory(petId),
        ),
        BlocProvider(create: (context) => sl<PetFriendsCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileMatingCubit, ProfileMatingState>(
            listener: (context, state) {
              if (state is ProfileChangeMatingError) {
                errorToast(context, state.message);
              }
              if (state is ProfileChangeMatingSuccess) {
                ProfileMatingCubit.get(
                  context,
                ).getPetProfileMating(state.petId);
                ProfileMatingCubit.get(
                  context,
                ).getPetProfileMatingHistory(state.petId);
                Navigator.pop(context);
              }
            },
          ),
          BlocListener<PetFriendsCubit, PetFriendsState>(
            listener: (context, state) {
              if (state is BlockFriendshipSuccess ||
                  state is FriendRequestUpdated) {
                if (context.mounted) Navigator.of(context).pop();
              } else if (state is DeleteFriendShipSuccess) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  // Refresh the previous screen
                  context.read<PetFriendsCubit>().loadSentFriends(
                    petId: activePetId ?? '',
                  );
                }
              } else if (state is FriendRequestCancelled) {
                if (context.mounted && isSent == true) {
                  Navigator.of(context).pop();
                  context.read<PetFriendsCubit>().loadSentFriends(
                    petId: activePetId ?? '',
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileMatingCubit, ProfileMatingState>(
          builder: (context, state) {
            final cubit = ProfileMatingCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(S.of(context).viewProfile),
                backgroundColor: Colors.transparent,
                actions:
                    isFriend == true
                        ? [
                          IconButton(
                            icon: _buildMoreOptionsIcon(isDarkMode),
                            onPressed: () => _showMoreOptions(context, cubit),
                          ),
                          const SizedBox(width: 8),
                        ]
                        : null,
              ),
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    if (cubit.petProfileMating != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PetProfileHeader(
                            pet: cubit.petProfileMating!,
                            cubit: cubit,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                  ];
                },
                body:
                    (cubit.petProfileMating != null)
                        ? Column(
                          children: [
                            if (isFriend == true)
                              MessageAndInfoButtons(
                                pet: cubit.petProfileMating!,
                                isDarkMode: isDarkMode,
                                activePetId: activePetId,
                                conversationId: conversationId,
                              ),
                            if (isSent == true)
                              _buildSentRequestButtons(
                                context,
                                cubit.petProfileMating!,
                              ),
                            if (isReceived == true)
                              _buildReceivedRequestButtons(
                                context,
                                cubit.petProfileMating!,
                              ),
                            if (isFriend == false &&
                                isSent != true &&
                                isReceived != true)
                              _buildFriendRequestButtons(
                                context,
                                cubit.petProfileMating!,
                              ),
                            if (fromMating == true)
                              _buildFullWidthPetInfoButton(
                                context,
                                cubit.petProfileMating!,
                              ),
                            Expanded(
                              child: PetTabsSection(
                                pet: cubit.petProfileMating!,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        )
                        : DogLoadingStateWidget(
                          theme: Theme.of(context),
                          isDark:
                              Theme.of(context).brightness == Brightness.dark,
                          s: S.of(context),
                          text: S.of(context).loadingProfile,
                        ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMoreOptionsIcon(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDarkMode
                  ? [Color(0xFF2A2A2A), Color(0xFF1E1E1E)]
                  : [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.more_vert,
        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
        size: 20,
      ),
    );
  }

  void _showMoreOptions(BuildContext context, ProfileMatingCubit cubit) {
    if (cubit.petProfileMating == null) return;

    final pet = cubit.petProfileMating!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final petFriendsCubit = context.read<PetFriendsCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: petFriendsCubit,
          child: MoreOptionsBottomSheet(
            pet: pet,
            isDark: isDark,
            activePetId: activePetId,
          ),
        );
      },
    );
  }

  Widget _buildReceivedRequestButtons(BuildContext context, PetEntities pet) {
    if (requestEntity == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: AcceptRequestButton(
              onPressed: () {
                context.read<PetFriendsCubit>().updateFriendRequest(
                  requestEntity!,
                  FriendshipStatus.accepted,
                );
              },
              label: isArabic() ? "دعنا نلعب!" : "Let's Pawty!",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RejectRequestButton(
              onPressed: () {
                context.read<PetFriendsCubit>().updateFriendRequest(
                  requestEntity!,
                  FriendshipStatus.rejected,
                );
              },
              label: isArabic() ? "ليس الآن" : "Not Now",
              isDarkMode: isDarkMode,
            ),
          ),
          const SizedBox(width: 8),
          PetInfoButton(pet: pet, isDarkMode: isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSentRequestButtons(BuildContext context, PetEntities pet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CancelRequestButton(
              onPressed: () {
                context.read<PetFriendsCubit>().cancelRequest(
                  pet,
                  activePetId ?? '',
                );
              },
              label: S.of(context).cancelRequest,
              isDarkMode: isDarkMode,
            ),
          ),
          const SizedBox(width: 12),
          PetInfoButton(pet: pet, isDarkMode: isDarkMode),
        ],
      ),
    );
  }

  Widget _buildFriendRequestButtons(BuildContext context, PetEntities pet) {
    return BlocBuilder<PetFriendsCubit, PetFriendsState>(
      builder: (context, state) {
        final petFriendsCubit = context.read<PetFriendsCubit>();
        final isSent = petFriendsCubit.sentRequests.contains(pet);

        final primaryColor =
            isDarkMode ? const Color(0xFF0A84FF) : const Color(0xFF007AFF);
        final dangerColor =
            isDarkMode ? const Color(0xFFFF453A) : const Color(0xFFFF3B30);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: isSent ? 1 : 3,
                child: GradientIconButton(
                  onPressed: () {
                    if (isSent) {
                      petFriendsCubit.cancelRequest(pet, activePetId ?? '');
                    } else {
                      petFriendsCubit.sendFriendRequest(pet, activePetId ?? '');
                    }
                  },
                  icon: isSent ? Icons.close_rounded : Icons.pets,
                  label:
                      isSent
                          ? (S.of(context).cancel)
                          : (S.of(context).furryFriend),
                  isDarkMode: isDarkMode,
                  gradientColors:
                      isSent
                          ? [dangerColor, dangerColor.withOpacity(0.85)]
                          : [primaryColor, primaryColor.withOpacity(0.9)],
                ),
              ),
              const SizedBox(width: 12),
              PetInfoButton(pet: pet, isDarkMode: isDarkMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFullWidthPetInfoButton(BuildContext context, PetEntities pet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: GradientButtonContainer(
          isDarkMode: isDarkMode,
          child: PetInfoButton(
            showLabel: true,
            pet: pet, isDarkMode: isDarkMode),
      ),
      ),
    );
  }
}

/// Reusable gradient container wrapper for buttons
class GradientButtonContainer extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  final List<Color>? gradientColors;
  final BorderRadius? borderRadius;
  final double blurRadius;
  final Offset shadowOffset;

  const GradientButtonContainer({
    super.key,
    required this.child,
    required this.isDarkMode,
    this.gradientColors,
    this.borderRadius,
    this.blurRadius = 8,
    this.shadowOffset = const Offset(0, 4),
  });

  @override
  Widget build(BuildContext context) {
    final defaultGradient =
        isDarkMode
            ? [const Color(0xFF2A2A2A), const Color(0xFF1E1E1E)]
            : [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ?? defaultGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (gradientColors?.first ??
                    (isDarkMode
                        ? Colors.black
                        : Theme.of(context).primaryColor))
                .withOpacity(0.3),
            blurRadius: blurRadius,
            offset: shadowOffset,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Reusable pet info button (the paw icon button)
class PetInfoButton extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;
  final bool? showLabel;

  const PetInfoButton({super.key, required this.pet, required this.isDarkMode, this.showLabel});

  @override
  Widget build(BuildContext context) {
    return GradientButtonContainer(
      isDarkMode: isDarkMode,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder:
                (context) => PetInfoPopup(pet: pet, isDarkMode: isDarkMode),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pets, size: 20),
            if (showLabel == true) ...[
              const SizedBox(width: 8),
              Text(
                S.of(context).petDetails,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Reusable gradient button with icon
class GradientIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isDarkMode;
  final List<Color>? gradientColors;
  final Color? foregroundColor;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;

  const GradientIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isDarkMode,
    this.gradientColors,
    this.foregroundColor,
    this.iconSize = 20,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return GradientButtonContainer(
      isDarkMode: isDarkMode,
      gradientColors: gradientColors,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: foregroundColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, size: iconSize),
        label: Text(
          label,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
      ),
    );
  }
}

/// Reusable action button row with info button
class ActionButtonRow extends StatelessWidget {
  final Widget actionButton;
  final PetEntities pet;
  final bool isDarkMode;
  final EdgeInsets padding;

  const ActionButtonRow({
    super.key,
    required this.actionButton,
    required this.pet,
    required this.isDarkMode,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: actionButton),
          const SizedBox(width: 12),
          PetInfoButton(pet: pet, isDarkMode: isDarkMode),
        ],
      ),
    );
  }
}

/// Cancel request button (outlined style)
class CancelRequestButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isDarkMode;

  const CancelRequestButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final dangerColor =
        isDarkMode ? const Color(0xFFFF453A) : const Color(0xFFFF3B30);

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.cancel_outlined, size: 18, color: dangerColor),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: dangerColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: dangerColor, width: 1.3),
        backgroundColor:
            isDarkMode
                ? dangerColor.withOpacity(0.07)
                : dangerColor.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        elevation: 0,
      ),
    );
  }
}

/// Accept request button (green style)
class AcceptRequestButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const AcceptRequestButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.pets, size: 16, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        shadowColor: Colors.green.withOpacity(0.3),
      ),
    );
  }
}

/// Reject request button (outlined gray style)
class RejectRequestButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isDarkMode;

  const RejectRequestButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final rejectGradient =
        isDarkMode
            ? [Colors.grey[800]!, Colors.grey[700]!]
            : [const Color(0xFFF5F5F5), const Color(0xFFE8E8E8)];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: rejectGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[600]! : const Color(0xFFE0E0E0),
          width: 2,
        ),
      ),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.close,
          size: 16,
          color: isDarkMode ? Colors.grey[300]! : Colors.grey[700]!,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDarkMode ? Colors.grey[300]! : Colors.grey[700]!,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
