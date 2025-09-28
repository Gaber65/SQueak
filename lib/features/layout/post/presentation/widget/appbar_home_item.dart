import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/layout/notification/NotificationAPI/presentation/screens/notificationPage.dart';
import 'package:squeak/features/layout/search/presentation/screens/search_screen.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/features/profile_switch/Presentation/widget/screens/profile_switcher_page.dart';
import 'package:squeak/features/settings/persentaion/controller/setting_cubit.dart';

import '../../../../../core/utils/enums/profile_type.dart';
import '../../../../profile_switch/domain/entities/profile_type_entity.dart';
import '../../../../profile_switch/source/data/profile_local_data_source.dart';

AppBar buildAppBarHome(context) {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: false,
    title: ShaderMask(
      shaderCallback:
          (bounds) => const LinearGradient(
            colors: [ColorManager.primaryColor, ColorManager.secondColor],
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

      Padding(
        padding: EdgeInsets.only(right: 12),

        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<PetCubit>()..getOwnerPets(),
              lazy: true,
            ),
            BlocProvider(
              create: (_) => sl<SettingCubit>()..getOwnerData(),
              lazy: true,
            ),
            BlocProvider(
              create: (_) => sl<SwitchProfileCubit>()..loadProfile(),
              lazy: true,
            ),
          ],
          child: BlocConsumer<SwitchProfileCubit, SwitchProfileState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              var cubit = SwitchProfileCubit.get(context);
              return ProfileSwitcherButton(
                image: cubit.image,
                name: cubit.name,
              );
            },
          ),
        ),
      ),
    ],
  );
}
