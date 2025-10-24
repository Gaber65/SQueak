import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/layout/post/presentation/controller/post_cubit.dart';
import 'package:squeak/features/layout/post/presentation/widget/appbar_home_item.dart';
import 'package:squeak/features/layout/post/presentation/widget/get_posts_when_user_follow.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/theme/widgets/pet_teaching/did_you_know_card.dart';
import 'package:squeak/core/theme/widgets/pet_teaching/pet_tips_repository.dart';
import 'package:squeak/core/theme/widgets/vc_card.dart';
import 'package:squeak/core/theme/widgets/pet_teaching/pet_avatar.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
import '../widget/build_search_box.dart';
import '../widget/loading_posts.dart';
import 'package:squeak/features/profile_switch/Presentation/widget/component/profile_switcher_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ProfileSwitcherController controller;

  @override
  void initState() {
    super.initState();
    controller = ProfileSwitcherController(context, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _closeProfileList() {
    // Close the local controller
    controller.closeDropdown();

    // Also try to close the service locator instance if it exists
    try {
      final globalController = sl<ProfileSwitcherController>();
      globalController.closeDropdown();
    } catch (e) {
      // Service locator instance might not exist, that's okay
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostCubit>(),
      child: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = PostCubit.get(context);

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeProfileList,
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  _closeProfileList();
                }
              },
              onPointerDown: (_) => _closeProfileList(),
              child: Scaffold(
                appBar: buildAppBarHome(context),
                body: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    // Close profile list on any scroll event
                    if (notification is ScrollStartNotification ||
                        notification is UserScrollNotification ||
                        notification is ScrollUpdateNotification) {
                      _closeProfileList();
                    }
                    return false;
                  },
                  child: Column(
                    children: [
                      const _PetTipBanner(),
                      const _ActivePetSummary(),
                      Expanded(child: _buildBody(cubit, state)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(PostCubit cubit, PostState state) {
    if (state is GetPostLoadingState && cubit.userPosts.isEmpty) {
      return buildShimmerLoading();
    }

    if (cubit.userPosts.isEmpty) {
      return buildSearchBox(cubit);
    }

    return buildNotificationListenerUserPosts(cubit, state);
  }
}

class _PetTipBanner extends StatefulWidget {
  const _PetTipBanner();

  @override
  _PetTipBannerState createState() => _PetTipBannerState();
}

class _PetTipBannerState extends State<_PetTipBanner> {
  bool _isDismissed = false;
  late final Future<List<PetTip>> _tipsFuture;
  late final Random _random;
  static final Set<int> _recentlyShownTips = <int>{};
  static const int _maxRecentTips = 5; // Remember last 5 tips to avoid repetition

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) {
      return const SizedBox(height: 0);
    }

    return FutureBuilder<List<PetTip>>(
      future: _tipsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(height: 0);
        }
        final tips = snapshot.data ?? const <PetTip>[];
        if (tips.isEmpty) {
          return const SizedBox(height: 0);
        }
        
        final tip = _getSmartRandomTip(tips);
        return DidYouKnowCard(
          title: tip.title,
          content: tip.content,
          category: tip.category,
          isDismissible: true,
          onDismiss: () {
            setState(() {
              _isDismissed = true;
            });
          },
        );
      },
    );
  }

  /// Enhanced random tip selection that avoids recently shown tips
  /// and considers time-based weighting for variety
  PetTip _getSmartRandomTip(List<PetTip> tips) {
    if (tips.isEmpty) {
      throw StateError('Tips list cannot be empty');
    }

    // If we have fewer tips than our recent memory, just pick randomly
    if (tips.length <= _maxRecentTips) {
      final randomIndex = _random.nextInt(tips.length);
      return tips[randomIndex];
    }

    // Create a list of available tips (not recently shown)
    final availableTips = <int>[];
    for (int i = 0; i < tips.length; i++) {
      if (!_recentlyShownTips.contains(i)) {
        availableTips.add(i);
      }
    }

    // If no tips are available (all were recently shown), clear the recent list
    if (availableTips.isEmpty) {
      _recentlyShownTips.clear();
      availableTips.addAll(List.generate(tips.length, (index) => index));
    }

    // Enhanced randomization with time-based seed for better variety
    final timeBasedSeed = DateTime.now().millisecondsSinceEpoch;
    final enhancedRandom = Random(timeBasedSeed);
    
    // Add extra randomness by shuffling the available tips
    availableTips.shuffle(enhancedRandom);
    
    final selectedIndex = availableTips[enhancedRandom.nextInt(availableTips.length)];
    
    // Remember this tip to avoid showing it again soon
    _recentlyShownTips.add(selectedIndex);
    
    // Keep only the most recent tips in memory
    if (_recentlyShownTips.length > _maxRecentTips) {
      final sortedRecent = _recentlyShownTips.toList()..sort();
      _recentlyShownTips.clear();
      _recentlyShownTips.addAll(sortedRecent.skip(sortedRecent.length - _maxRecentTips));
    }

    return tips[selectedIndex];
  }

  @override
  void initState() {
    super.initState();
    // Initialize random with time-based seed for better entropy
    final seed = DateTime.now().millisecondsSinceEpoch + 
                 DateTime.now().microsecond + 
                 hashCode;
    _random = Random(seed);
    _tipsFuture = const PetTipsRepository().loadTips();
  }
}

class _ActivePetSummary extends StatelessWidget {
  const _ActivePetSummary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return VcCard(
      onTap: () {
        try {
          ProfileSwitcherController? controller =
              sl<ProfileSwitcherController>();
          controller.closeDropdown();
        } catch (e) {
          // Controller might not be registered
        }
        navigateToScreen(context, const PetScreen());
      },
      child: Row(
        children: [
          PetAvatar.small(petName: 'Pet'),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your pets',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tap to view and manage pets",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
