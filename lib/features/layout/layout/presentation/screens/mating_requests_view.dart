import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/feeds/presentation/screens/feed_mating.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/features/layout/layout/presentation/widgets/browse_tab_items.dart';
import 'package:squeak/features/mating/matingRequest/presentation/screens/mating_requests_screen.dart';

class MatingRequestsTab extends StatefulWidget {
  const MatingRequestsTab({super.key});

  @override
  State<MatingRequestsTab> createState() => _MatingRequestsTabState();
}

class _MatingRequestsTabState extends State<MatingRequestsTab> {
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

    return BlocProvider(
      create: (context) => sl<ManageRequestMatingCubit>(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _selectedTab == 0 ? S.of(context).availableForMating : S.of(context).mangeMatingRequests,
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

          

            return Column(
              children: [
                // Tab buttons
                _buildTabBar(),

                // Content area
                Expanded(
                  child: _buildTabContent(context, activeProfile),
                ),
              ],
            );
          },
        ),
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
              icon: IconlyBold.heart,
              label: S.of(context).availableForMating,
              isSelected: _selectedTab == 0,
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                  _searchController.clear();
                });
              },
              selectedColor: selectedColor,
              isDark: isDark,
            ),
          ),
          Expanded(
            child: BrowseTabItem(
              icon: IconlyBold.send,
              label: S.of(context).mangeMatingRequests,
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
        // Mating Requests Tab - show mating requests with loading
        return BlocBuilder<ManageRequestMatingCubit, ManageRequestMatingState>(
          builder: (context, state) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;

            if (state is GetMyMatingRequestLoading) {
              return DogLoadingStateWidget(
                theme: theme,
                isDark: isDark,
                s: S.of(context),
                text: S.of(context).loadingSuggestions,
              );
            }

            if (state is GetMyMatingRequestError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
              );
            }

            return PetFeedScreen();
          },
        );
      case 1:
        return MatingRequestsScreen();
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

