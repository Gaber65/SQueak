import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/utils/enums/profile_type.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_cubit.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/presentation/widgets/FriendsTab.dart';
import 'package:squeak/features/friendship/presentation/widgets/ProfileSwitchNotificationScreen.dart';
import 'package:squeak/features/friendship/presentation/widgets/tab_bar_widget.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';

import '../../../auth/get_started/presentation/widgets/find_friends/search_bar_widget.dart';

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
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            isArabic() ? 'الأصدقاء والطلبات' : 'Friends & Requests',
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
                    PetFriendsCubit.get(context).loadSuggestedFriends(
                      specieId:
                          SwitchProfileCubit.get(
                            context,
                          ).activeProfile!.pet!.specieId!,
                    );
                    PetFriendsCubit.get(context).loadSentFriends(
                      petId:
                          SwitchProfileCubit.get(
                            context,
                          ).activeProfile!.pet!.petId!,
                    );
                    PetFriendsCubit.get(context).loadReceivedFriends(
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
                return Column(
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
                    ),
                    Expanded(child: buildTabContent(context, cubit)),
                  ],
                );
              } else {
                return const ProfileSwitchNotificationScreen();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildTabContent(BuildContext context, PetFriendsCubit state) {
    switch (state.selectedTab) {
      case 0:
        return FriendsTab(friends: state.friends);
      case 1:
        return SuggestedTab(suggested: state.suggestedFriends);
      case 2:
        return ReceivedTab(requests: state.pendingRequests);
      case 3:
        return SentTab(requests: state.sentRequests);
      default:
        return FriendsTab(friends: state.friends);
    }
  }
}
