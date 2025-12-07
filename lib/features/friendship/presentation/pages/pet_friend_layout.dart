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
import 'package:squeak/features/friendship/presentation/widgets/chats_tab.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_app_cubit.dart';

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
                // Conditionally provide ChatAppCubit only when on Chats tab
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
                      chatsCount: cubit.chats.length,
                    ),
                    // Show filter buttons when Requests tab is selected
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

        if (state is ChatsLoading && cubit.selectedTab == 3) {
          return DogLoadingStateWidget(
            theme: theme,
            isDark: isDark,
            s: S.of(context),
            text: S.of(context).loadingChats,
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
            return const ChatsTab();
          default:
            return FriendsTab(friends: cubit.friends);
        }
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:squeak/core/service/global_function/format_utils.dart';

// class FriendsScreen extends StatelessWidget {
//   const FriendsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final arabic = isArabic();
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
    
//     // Responsive sizing based on screen height
//     final isSmallScreen = screenHeight < 700;
//     final isTinyScreen = screenHeight < 600;
    
//     // Define colors based on theme
//     final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
//     final textColor = isDark ? Colors.white : Colors.grey.shade800;
//     final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
//     final primaryColor = isDark ? const Color(0xFFFFB74D) : Colors.amber.shade700;
//     final circleBackground = isDark ? const Color(0xFF2C2C2C) : Colors.amber.shade50;
//     final pawPrintColor = isDark ? const Color(0xFF3D3D3D) : Colors.amber.shade200;
    
//     // Responsive measurements
//     final pawSize1 = isTinyScreen ? 20.0 : (isSmallScreen ? 25.0 : 30.0);
//     final pawSize2 = isTinyScreen ? 28.0 : (isSmallScreen ? 35.0 : 40.0);
//     final pawSpacing = isTinyScreen ? 12.0 : (isSmallScreen ? 16.0 : 20.0);
    
//     final circleSize = isTinyScreen ? 120.0 : (isSmallScreen ? 150.0 : 200.0);
//     final iconSize = isTinyScreen ? 60.0 : (isSmallScreen ? 75.0 : 100.0);
    
//     final titleSize = isTinyScreen ? 24.0 : (isSmallScreen ? 28.0 : 32.0);
//     final badgeTextSize = isTinyScreen ? 11.0 : (isSmallScreen ? 12.0 : 14.0);
//     final descriptionSize = isTinyScreen ? 13.0 : (isSmallScreen ? 14.0 : 16.0);
//     final featureTextSize = isTinyScreen ? 13.0 : (isSmallScreen ? 14.0 : 16.0);
//     final buttonTextSize = isTinyScreen ? 14.0 : (isSmallScreen ? 15.0 : 16.0);
    
//     final verticalSpacing1 = isTinyScreen ? 16.0 : (isSmallScreen ? 24.0 : 40.0);
//     final verticalSpacing2 = isTinyScreen ? 8.0 : (isSmallScreen ? 10.0 : 12.0);
//     final verticalSpacing3 = isTinyScreen ? 12.0 : (isSmallScreen ? 16.0 : 24.0);
//     final featureSpacing = isTinyScreen ? 8.0 : (isSmallScreen ? 12.0 : 16.0);
    
//     final horizontalPadding = screenWidth < 360 ? 16.0 : 24.0;
    
//     return Directionality(
//       textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text(
//             arabic ? 'الأصدقاء والطلبات' : 'Friends & Requests',
//             style: TextStyle(
//               fontSize: isTinyScreen ? 18 : 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         backgroundColor: backgroundColor,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: horizontalPadding,
//                 vertical: isTinyScreen ? 16.0 : 24.0,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Animated paw prints decoration
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildPawPrint(size: pawSize1, rotation: -0.3, color: pawPrintColor),
//                       SizedBox(width: pawSpacing),
//                       _buildPawPrint(size: pawSize2, rotation: 0.2, color: pawPrintColor),
//                       SizedBox(width: pawSpacing),
//                       _buildPawPrint(size: pawSize1, rotation: -0.1, color: pawPrintColor),
//                     ],
//                   ),

//                   SizedBox(height: verticalSpacing1),

//                   // Main illustration
//                   Container(
//                     width: circleSize,
//                     height: circleSize,
//                     decoration: BoxDecoration(
//                       color: circleBackground,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(
//                       child: Icon(
//                         Icons.pets,
//                         size: iconSize,
//                         color: primaryColor,
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: verticalSpacing1),

//                   // Title
//                   Text(
//                     arabic ? 'الأصدقاء' : 'Friends Feature',
//                     style: TextStyle(
//                       fontSize: titleSize,
//                       fontWeight: FontWeight.bold,
//                       color: textColor,
//                     ),
//                   ),

//                   SizedBox(height: verticalSpacing2),

//                   // Coming Soon badge
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: isTinyScreen ? 16 : 20,
//                       vertical: isTinyScreen ? 6 : 8,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: isDark
//                             ? [const Color(0xFFFFB74D), const Color(0xFFFF9800)]
//                             : [Colors.amber.shade400, Colors.orange.shade400],
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       arabic ? 'قريبًا' : 'COMING SOON',
//                       style: TextStyle(
//                         fontSize: badgeTextSize,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: verticalSpacing3),

//                   // Description
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: screenWidth < 360 ? 8.0 : 16.0,
//                     ),
//                     child: Text(
//                       arabic
//                           ? 'تواصل مع أصحاب الصغار الأليفة، وشارك لحظاتك اللطيفة، وابنِ مجتمعًا من محبي الصغار الأليفة!'
//                           : 'Connect with fellow pet parents, share adorable moments, and build a community of pet lovers!',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: descriptionSize,
//                         color: subtitleColor,
//                         height: 1.5,
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: verticalSpacing1),

//                   // Features preview
//                   _buildFeatureItem(
//                     icon: Icons.people_outline,
//                     text: arabic ? 'تواصل مع أصحاب الصغار الأليفة' : 'Connect with pet owners',
//                     color: isDark ? const Color(0xFF64B5F6) : Colors.blue.shade400,
//                     isDark: isDark,
//                     isSmallScreen: isTinyScreen,
//                     fontSize: featureTextSize,
//                   ),
//                   SizedBox(height: featureSpacing),
//                   _buildFeatureItem(
//                     icon: Icons.photo_library_outlined,
//                     text: arabic ? 'شارك صور وقصص الصغار ' : 'Share pet photos & stories',
//                     color: isDark ? const Color(0xFFF06292) : Colors.pink.shade400,
//                     isDark: isDark,
//                     isSmallScreen: isTinyScreen,
//                     fontSize: featureTextSize,
//                   ),
//                   SizedBox(height: featureSpacing),
//                   _buildFeatureItem(
//                     icon: Icons.chat_bubble_outline,
//                     text: arabic ? 'الدردشة وتبادل النصائح' : 'Chat and exchange tips',
//                     color: isDark ? const Color(0xFF81C784) : Colors.green.shade400,
//                     isDark: isDark,
//                     isSmallScreen: isTinyScreen,
//                     fontSize: featureTextSize,
//                   ),

//                   SizedBox(height: verticalSpacing1),

//                   // Notify button
//                   ElevatedButton(
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             arabic ? 'سنخبرك عندما تصبح متاحة! 🐾' : 'We\'ll notify you when it\'s ready! 🐾',
//                           ),
//                           backgroundColor: primaryColor,
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isTinyScreen ? 32 : 40,
//                         vertical: isTinyScreen ? 12 : 16,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: arabic
//                           ? [
//                               Text(
//                                 'أعلمني',
//                                 style: TextStyle(
//                                   fontSize: buttonTextSize,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Icon(
//                                 Icons.notifications_outlined,
//                                 size: isTinyScreen ? 18 : 20,
//                               ),
//                             ]
//                           : [
//                               Icon(
//                                 Icons.notifications_outlined,
//                                 size: isTinyScreen ? 18 : 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Notify Me',
//                                 style: TextStyle(
//                                   fontSize: buttonTextSize,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                     ),
//                   ),
                  
//                   SizedBox(height: isTinyScreen ? 16.0 : 24.0),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPawPrint({
//     required double size,
//     required double rotation,
//     required Color color,
//   }) {
//     return Transform.rotate(
//       angle: rotation,
//       child: Icon(Icons.pets, size: size, color: color),
//     );
//   }

//   Widget _buildFeatureItem({
//     required IconData icon,
//     required String text,
//     required Color color,
//     required bool isDark,
//     required bool isSmallScreen,
//     required double fontSize,
//   }) {
//     final textColor = isDark ? Colors.grey.shade300 : Colors.grey.shade700;
//     final iconSize = isSmallScreen ? 20.0 : 24.0;
//     final padding = isSmallScreen ? 12.0 : 16.0;
//     final iconPadding = isSmallScreen ? 6.0 : 8.0;
    
//     return Container(
//       padding: EdgeInsets.all(padding),
//       decoration: BoxDecoration(
//         color: color.withOpacity(isDark ? 0.15 : 0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: color.withOpacity(isDark ? 0.4 : 0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(iconPadding),
//             decoration: BoxDecoration(
//               color: color.withOpacity(isDark ? 0.25 : 0.2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: color, size: iconSize),
//           ),
//           SizedBox(width: isSmallScreen ? 12 : 16),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: fontSize,
//                 color: textColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }