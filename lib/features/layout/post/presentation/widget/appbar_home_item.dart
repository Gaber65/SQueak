import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/layout/notification/NotificationAPI/presentation/screens/notificationPage.dart';
import 'package:squeak/features/layout/search/presentation/screens/search_screen.dart';

AppBar buildAppBarHome(context) {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: false,
    title: ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          ColorManager.primaryColor,
          ColorManager.secondColor,
        ],
        tileMode: TileMode.decal,
      ).createShader(bounds),
      child: const Text(
        'SQueak',
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.white, // ignored, shaded by gradient
        ),
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          navigateToScreen(context, SearchScreen());
        },
        icon: const Icon(IconlyLight.search),
      ),
      IconButton(
        iconSize: 32,
        onPressed: () {
          navigateToScreen(context, NotificationScreen());
        },
        icon:
            (CacheHelper.getData('notificationsNum') != null)
                ? Badge.count(
                  alignment: AlignmentDirectional.topCenter,
                  count: CacheHelper.getData('notificationsNum'),
                  textColor: Colors.white,
                  child: const Icon(IconlyLight.notification),
                )
                : const Icon(IconlyLight.notification),
      ),
    ],
  );
}
