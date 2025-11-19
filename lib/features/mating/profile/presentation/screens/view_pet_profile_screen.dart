import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
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
  final bool? isReceived;
  final bool? isSent;
  final String? activePetId;
  final String? conversationId;

  const ViewPetProfileScreen({
    super.key,
    this.isDarkMode = false,
    required this.petId,
    this.isFriend,
    this.isReceived,
    this.isSent,
    this.activePetId,
    this.conversationId,
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
              if (state is BlockFriendshipSuccess) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } else if (state is DeleteFriendShipSuccess) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                context.read<PetFriendsCubit>().loadSentFriends(
                  petId: activePetId ?? '',
                );
              } else if (state is FriendRequestCancelled) {
                if (context.mounted) {
                  Navigator.of(context).pop();
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
                                isDarkMode,
                              ),
                            if (isFriend == false && isSent != true)
                              _buildFriendRequestButtons(
                                context,
                                cubit.petProfileMating!,
                                isDarkMode,
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

  Widget _buildSentRequestButtons(
    BuildContext context,
    PetEntities pet,
    bool isDarkMode,
  ) {
    final dangerColor =
        isDarkMode ? const Color(0xFFFF453A) : const Color(0xFFFF3B30);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<PetFriendsCubit>().cancelRequest(
                  pet,
                  activePetId ?? '',
                );
              },
              icon: Icon(Icons.cancel_outlined, size: 18, color: dangerColor),
              label: Text(
                S.of(context).cancelRequest,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isDarkMode
                            ? [const Color(0xFF2A2A2A), const Color(0xFF1E1E1E)]
                            : [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (isDarkMode
                              ? Colors.black
                              : Theme.of(context).primaryColor)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder:
                          (context) =>
                              PetInfoPopup(pet: pet, isDarkMode: isDarkMode),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.pets, size: 20),
                ),
              ),
             ],
      ),
    );
  }

  Widget _buildFriendRequestButtons(
    BuildContext context,
    PetEntities pet,
    bool isDarkMode,
  ) {
    return BlocBuilder<PetFriendsCubit, PetFriendsState>(
      builder: (context, state) {
        final petFriendsCubit = context.read<PetFriendsCubit>();
        final isSent = petFriendsCubit.sentRequests.contains(pet);

        final primaryColor = isDarkMode ? Color(0xFF0A84FF) : Color(0xFF007AFF);
        final dangerColor = isDarkMode ? Color(0xFFFF453A) : Color(0xFFFF3B30);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: isSent ? 1 : 3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isSent
                              ? [dangerColor, dangerColor.withOpacity(0.85)]
                              : [primaryColor, primaryColor.withOpacity(0.9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (isSent ? dangerColor : primaryColor)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isSent) {
                        petFriendsCubit.cancelRequest(pet, activePetId ?? '');
                      } else {
                        petFriendsCubit.sendFriendRequest(
                          pet,
                          activePetId ?? '',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      isSent ? Icons.close_rounded : Icons.pets,
                      size: 20,
                    ),
                    label: Text(
                      isSent
                          ? (isArabic() ? "إلغاء الطلب" : 'Cancel')
                          : (isArabic() ? 'إضافة صديق' : 'Furry Friend'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isDarkMode
                            ? [const Color(0xFF2A2A2A), const Color(0xFF1E1E1E)]
                            : [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (isDarkMode
                              ? Colors.black
                              : Theme.of(context).primaryColor)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder:
                          (context) =>
                              PetInfoPopup(pet: pet, isDarkMode: isDarkMode),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.pets, size: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
