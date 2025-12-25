import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/utils/enums/profile_type.dart';
import 'package:squeak/features/auth/get_started/presentation/widgets/find_friends/search_bar_widget.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/presentation/widgets/friends_tab.dart';
import 'package:squeak/features/mating/feeds/presentation/screens/feed_mating.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/features/layout/layout/presentation/widgets/browse_tab_items.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late TextEditingController _searchController;
  int _selectedTab = 0; 

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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _selectedTab == 0 ? 'Friend Requests' : 'Mating Requests',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: BlocBuilder<SwitchProfileCubit, SwitchProfileState>(
        builder: (context, state) {
          final switchProfileCubit = context.read<SwitchProfileCubit>();
          final activeProfile = switchProfileCubit.activeProfile;

          if (activeProfile == null || activeProfile.type != ProfileType.pet) {
            return Center(
              child: Text(
                'Please select a pet profile',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Tab buttons
              _buildTabBar(),

              // Search field - only show when Suggest tab is selected
              if (_selectedTab == 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchBarWidget(
                    controller: _searchController,
                    specieId: activeProfile.pet!.specieId!,
                    onChanged: (value) {
                      context.read<PetFriendsCubit>().loadSuggestedFriends(
                        specieId: activeProfile.pet!.specieId!,
                        name: value.isEmpty ? null : value,
                      );
                    },
                    onClear: () {
                      _searchController.clear();
                      context.read<PetFriendsCubit>().loadSuggestedFriends(
                        specieId: activeProfile.pet!.specieId!,
                      );
                    },
                  ),
                ),

              // Content area
              Expanded(
                child: _buildTabContent(context, activeProfile),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = Theme.of(context).colorScheme.primary;

    return Container(
      color: isDark ? Colors.black.withOpacity(0.1) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: BrowseTabItem(
              icon: IconlyBold.add_user,
              label: 'For Ever Friends',
              isSelected: _selectedTab == 0,
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                  _searchController.clear();
                });
                // Load suggested friends when switching to this tab
                final activeProfile = context.read<SwitchProfileCubit>().activeProfile;
                if (activeProfile?.pet != null) {
                  context.read<PetFriendsCubit>().loadSuggestedFriends(
                    specieId: activeProfile!.pet!.specieId!,
                  );
                }
              },
              selectedColor: selectedColor,
              isDark: isDark,
            ),
          ),
          Expanded(
            child: BrowseTabItem(
              icon: IconlyBold.heart,
              label: 'Mating Requests',
              isSelected: _selectedTab == 1,
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                  _searchController.clear();
                });
              },
              selectedColor: selectedColor,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, dynamic activeProfile) {
    switch (_selectedTab) {
      case 0:
        // Suggest Requests Tab - show suggested friends
        return BlocBuilder<PetFriendsCubit, PetFriendsState>(
          builder: (context, state) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;
            final cubit = context.read<PetFriendsCubit>();

            if (state is SuggestedFriendsLoading) {
              return DogLoadingStateWidget(
                theme: theme,
                isDark: isDark,
                s: S.of(context),
                text: S.of(context).loadingSuggestions,
              );
            }

            return SuggestedTab(suggested: cubit.suggestedFriends);
          },
        );
      case 1:
        // Mating Tab
        return PetFeedScreen();
      default:
        return Center(
          child: Text(
            'Unknown Tab',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.grey[700],
            ),
          ),
        );
    }
  }
}

