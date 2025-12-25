import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/utils/enums/profile_type.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/presentation/widgets/friends_tab.dart';
import 'package:squeak/features/friendship/presentation/widgets/profile_switch_notification_screen.dart';
import 'package:squeak/features/friendship/presentation/widgets/tab_bar_widget.dart';
import 'package:squeak/features/friendship/presentation/widgets/request_filter_widget.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_app_cubit.dart';
import 'package:squeak/features/friendship/presentation/pages/block_list_screen.dart';

import '../../../auth/get_started/presentation/widgets/find_friends/search_bar_widget.dart';
import '../../../settings/persentaion/controller/setting_cubit.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PetFriendsCubit>()),
        BlocProvider(create: (_) => sl<SwitchProfileCubit>()..loadProfile()),
        BlocProvider(
          create: (_) => sl<PetCubit>()..getOwnerPets(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => sl<SettingCubit>()..getOwnerData(),
          lazy: true,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            S.of(context).friendsAndRequests,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? ColorManager.white : ColorManager.black87,
            ),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<PetFriendsCubit, PetFriendsState>(
              listener: (context, state) {},
            ),
            BlocListener<SwitchProfileCubit, SwitchProfileState>(
              listener: (context, state) {
                if (state is ProfileLoaded) {
                  if (state.profile.type == ProfileType.pet) {
                    PetFriendsCubit.get(context).getFriends(
                      petId:
                          SwitchProfileCubit.get(
                            context,
                          ).activeProfile!.pet!.petId!,
                    );
                  }
                }
              },
            ),
          ],
          child: BlocConsumer<PetFriendsCubit, PetFriendsState>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = PetFriendsCubit.get(context);

              final cubits = SwitchProfileCubit.get(context);
              final activeProfile = cubits.activeProfile;

              if (activeProfile == null) {
                return const ProfileSwitchNotificationScreen();
              } else if (activeProfile.type == ProfileType.pet) {
                final isChatsTab = cubit.selectedTab == 3;

                Widget content = Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchBarWidget(
                        controller: _searchController,
                        specieId:
                            context
                                .read<SwitchProfileCubit>()
                                .activeProfile!
                                .pet!
                                .specieId!,
                        onChanged: (value) {
                          cubit.loadSuggestedFriends(
                            specieId: activeProfile.pet!.specieId!,
                            name: value.isEmpty ? null : value,
                          );
                        },
                        onClear: () {
                          cubit.loadSuggestedFriends(
                            specieId: activeProfile.pet!.specieId!,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    TabBarPetFriend(
                      selectedTab: cubit.selectedTab,
                      friendsCount: cubit.friends.length,
                      suggestedCount: cubit.suggestedFriends.length,
                      receivedCount: cubit.pendingRequests.length,
                      sentCount: cubit.sentRequests.length,
                      chatsCount: 0,
                    ),
                    if (cubit.selectedTab == 2)
                      RequestFilterWidget(
                        selectedFilter: cubit.requestFilter,
                        sentCount: cubit.sentRequests.length,
                        receivedCount: cubit.pendingRequests.length,
                      ),
                    Expanded(child: buildTabContent(context, cubit)),
                  ],
                );

                // Only wrap with ChatAppCubit when on Chats tab
                if (isChatsTab) {
                  return BlocProvider(
                    create:
                        (context) => ChatAppCubit(
                          petId: activeProfile.pet!.petId!,
                          fullName: activeProfile.pet!.petName ?? '',
                          image: activeProfile.pet!.imageName ?? '',
                        )..initialize(),
                    child: content,
                  );
                }

                return content;
              } else {
                return const ProfileSwitchNotificationScreen();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildTabContent(BuildContext context, PetFriendsCubit cubit) {
    return BlocBuilder<PetFriendsCubit, PetFriendsState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        if (state is FriendsLoading && cubit.selectedTab == 0) {
          return DogLoadingStateWidget(
            theme: theme,
            isDark: isDark,
            s: S.of(context),
            text: S.of(context).loadingFriends,
          );
        }

        if (state is SuggestedFriendsLoading && cubit.selectedTab == 1) {
          return DogLoadingStateWidget(
            theme: theme,
            isDark: isDark,
            s: S.of(context),
            text: S.of(context).loadingSuggestions,
          );
        }

        if (state is SuggestedFriendsLoading && cubit.selectedTab == 2) {
          return DogLoadingStateWidget(
            theme: theme,
            isDark: isDark,
            s: S.of(context),
            text: S.of(context).loadingRequests,
          );
        }
        switch (cubit.selectedTab) {
          case 0:
            return FriendsTab(friends: cubit.friends);
          case 1:
            return SuggestedTab(suggested: cubit.suggestedFriends);
          case 2:
            if (cubit.requestFilter == 'received') {
              return ReceivedTab(requests: cubit.pendingRequests);
            } else {
              return SentTab(requests: cubit.sentRequests);
            }
          case 3:
            return BlockedPetsScreen(
              petId: SwitchProfileCubit.get(context).activeProfile?.pet?.petId,
            );
          default:
            return FriendsTab(friends: cubit.friends);
        }
      },
    );
  }
}
