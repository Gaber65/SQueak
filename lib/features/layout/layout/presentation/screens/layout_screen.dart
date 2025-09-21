// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconly/iconly.dart';

// import 'package:squeak/core/utils/export_path/export_files.dart';
// import 'package:squeak/core/theme/app_theme.dart';
// import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
// import '../widgets/update_dialog.dart';

// class LayoutScreen extends StatefulWidget {
//   const LayoutScreen({super.key});

//   @override
//   State<LayoutScreen> createState() => _LayoutScreenState();
// }

// class _LayoutScreenState extends State<LayoutScreen>
//     with SingleTickerProviderStateMixin {
//   bool _isDialogShown = false;
//   int selectedIndex = 0;

//   late AnimationController _jumpController;
//   late Animation<double> _jumpAnimation;

//   @override
//   void initState() {
//     super.initState();

//     MainCubit.get(context).saveToken();
//     MainCubit.get(
//       context,
//     ).setLangInAPI(CacheHelper.getData('language') == 'ar' ? 1 : 0);

//     _jumpController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _jumpAnimation = TweenSequence([
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: 0,
//           end: -16,
//         ).chain(CurveTween(curve: Curves.easeOutBack)),
//         weight: 40,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: -16,
//           end: 0,
//         ).chain(CurveTween(curve: Curves.easeIn)),
//         weight: 30,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: 0,
//           end: -8,
//         ).chain(CurveTween(curve: Curves.easeOut)),
//         weight: 15,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: -8,
//           end: 0,
//         ).chain(CurveTween(curve: Curves.bounceOut)),
//         weight: 15,
//       ),
//     ]).animate(_jumpController);

//     Future.delayed(const Duration(milliseconds: 800), () {
//       _jumpController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _jumpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<LayoutCubit, LayoutState>(
//       listener: (context, state) async {
//         if (state is GetVersionSuccessState ||
//             state is GetCurrentVersionSuccessState) {
//           final cubit = context.read<LayoutCubit>();
//           if (!_isDialogShown &&
//               cubit.versionEntity != null &&
//               cubit.currentVersion.isNotEmpty) {
//             String serverVersion = cubit.versionEntity!.version;
//             String currentVersion = cubit.currentVersion;

//             if (isVersionGreater(serverVersion, currentVersion)) {
//               if (cubit.versionEntity!.version != cubit.currentVersion) {
//                 _isDialogShown = true;
//                 await showUpdateDialog(
//                   context,
//                   cubit.versionEntity!,
//                 ).whenComplete(() {
//                   _isDialogShown = false;
//                 });
//               }
//             }
//           }
//         }
//       },
//       builder: (context, state) {
//         final cubit = LayoutCubit.get(context);
//         selectedIndex = cubit.selectedIndex;

//         final icons = [
//           IconlyLight.home,
//           IconlyLight.search,
//           IconlyLight.add_user,
//           Icons.pets,
//           IconlyLight.time_circle,
//           IconlyLight.setting,
//         ];

//         return Scaffold(
//           extendBody: false,
//           resizeToAvoidBottomInset: false,
//           body: cubit.screens[selectedIndex],

//           bottomNavigationBar: BlocConsumer<MainCubit, MainState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               final theme = Theme.of(context);
//               return AnimatedBottomNavigationBar.builder(
//                 itemCount: icons.length,
//                 gapLocation: GapLocation.none,
//                 notchSmoothness: NotchSmoothness.softEdge,
//                 backgroundColor: theme.colorScheme.surface,
//                 activeIndex: selectedIndex,
//                 onTap: (index) {
//                   cubit.changeBottomNav(index);
//                   setState(() {
//                     selectedIndex = index;
//                   });
//                 },
//                 tabBuilder: (int index, bool isActive) {
//                   final icon = icons[index];
//                   if (icon == Icons.pets) {
//                     return AnimatedBuilder(
//                       animation: _jumpAnimation,
//                       builder: (context, child) {
//                         return Transform.translate(
//                           offset: Offset(0, _jumpAnimation.value),
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color:
//                                   isActive
//                                       ? Colors.orange.withOpacity(0.2)
//                                       : Colors.transparent,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               icon,
//                               size: isActive ? 32 : 28,
//                               color:
//                                   _jumpController.isAnimating
//                                       ? Colors.green
//                                       : isActive
//                                       ? Colors.orange
//                                       : Colors.grey,
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }

//                   return Icon(
//                     icon,
//                     size: isActive ? 30 : 26,
//                     color:
//                         isActive
//                             ? theme.colorScheme.primary
//                             : theme.colorScheme.onSurfaceVariant,
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/update_dialog.dart';

class LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const LazyIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late List<bool> _activated;

  @override
  void initState() {
    super.initState();
    _activated = List<bool>.filled(widget.children.length, false);
    _activated[widget.index] = true;
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _activated[widget.index] = true;
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: [
        for (int i = 0; i < widget.children.length; i++)
          _activated[i] ? widget.children[i] : const SizedBox.shrink(),
      ],
    );
  }
}

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  bool _isDialogShown = false;
  int selectedIndex = 0;

  late AnimationController _jumpController;
  late Animation<double> _jumpAnimation;

  @override
  void initState() {
    print(CacheHelper.getData('havePets'));
    super.initState();

    MainCubit.get(context).saveToken();
    MainCubit.get(
      context,
    ).setLangInAPI(CacheHelper.getData('language') == 'ar' ? 1 : 0);

    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    _jumpAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -8,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -10,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -8,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -8,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -6,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 7,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -6,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 7,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -4,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 6,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -4,
          end: 0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 6,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 4,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -2,
          end: 0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 4,
      ),
    ]).animate(_jumpController);

    if (CacheHelper.getData('havePets') == '[]' ||
        CacheHelper.getData('havePets') == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _jumpController.forward();
      });
    }
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) async {
        if (state is GetVersionSuccessState ||
            state is GetCurrentVersionSuccessState) {
          final cubit = context.read<LayoutCubit>();
          if (!_isDialogShown &&
              cubit.versionEntity != null &&
              cubit.currentVersion.isNotEmpty) {
            String serverVersion = cubit.versionEntity!.version;
            String currentVersion = cubit.currentVersion;

            if (isVersionGreater(serverVersion, currentVersion)) {
              if (cubit.versionEntity!.version != cubit.currentVersion) {
                _isDialogShown = true;
                await showUpdateDialog(
                  context,
                  cubit.versionEntity!,
                ).whenComplete(() {
                  _isDialogShown = false;
                });
              }
            }
          }
        }
      },
      builder: (context, state) {
        final cubit = LayoutCubit.get(context);
        selectedIndex = cubit.selectedIndex;

        final icons = [
          IconlyLight.home,
          FontAwesomeIcons.bone,
          IconlyLight.add_user,
          Icons.pets,
          IconlyLight.time_circle,
          IconlyLight.setting,
        ];

        return Scaffold(
          extendBody: false,
          resizeToAvoidBottomInset: false,

          body: LazyIndexedStack(index: selectedIndex, children: cubit.screens),

          bottomNavigationBar: BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {},
            builder: (context, state) {
              final theme = Theme.of(context);
              return AnimatedBottomNavigationBar.builder(
                itemCount: icons.length,
                gapLocation: GapLocation.none,
                notchSmoothness: NotchSmoothness.softEdge,
                backgroundColor: theme.colorScheme.surface,
                activeIndex: selectedIndex,
                onTap: (index) {
                  cubit.changeBottomNav(index);
                  setState(() {
                    selectedIndex = index;
                  });
                },
                tabBuilder: (int index, bool isActive) {
                  final icon = icons[index];
                  final labels = [
                    'Home',
                    'Friends',
                    'Add User',
                    'Pets',
                    'History',
                    'Settings',
                  ];

                  Widget iconWidget;
                  if (icon == Icons.pets) {
                    iconWidget = AnimatedBuilder(
                      animation: _jumpAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _jumpAnimation.value),
                          child: Icon(
                            icon,
                            size: isActive ? 32 : 28,
                            color:
                                _jumpController.isAnimating
                                    ? Colors.green
                                    : isActive
                                    ? theme.colorScheme.primary
                                    : Colors.grey,
                          ),
                        );
                      },
                    );
                  } else {
                    iconWidget = Icon(
                      icon,
                      size: isActive ? 30 : 26,
                      color:
                          isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconWidget,
                      const SizedBox(height: 2),
                      Flexible(
                        child: Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
