import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/core/utils/enums/profile_type.dart';

import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../../../profile_switch/Presentation/widget/screens/profile_switcher_page.dart'; // مكان navigateAndFinish

Widget buildProfileSwitcher(BuildContext context) {
  return BlocConsumer<SwitchProfileCubit, SwitchProfileState>(
    listener: (context, state) {
      if (state is ProfileSwitcherPage &&
          state.profile.type == ProfileType.user) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigateAndFinish(context, LayoutScreen());
        });
      }
    },
    builder: (context, switchState) {
      final switchCubit = SwitchProfileCubit.get(context);

      return ProfileSwitcherButton(
        image: switchCubit.image,
        name: switchCubit.name,
      );
    },
  );
}
