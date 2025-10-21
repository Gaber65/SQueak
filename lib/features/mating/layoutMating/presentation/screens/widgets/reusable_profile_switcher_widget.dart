import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../../../../core/utils/enums/profile_type.dart';
import '../../../../../profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../../../../../profile_switch/Presentation/widget/screens/profile_switcher_page.dart';
import '../../../../../settings/persentaion/controller/setting_cubit.dart';


/// A reusable Profile Switcher Widget
/// [onProfileSwitcher] is called when the state is ProfileSwitcherPage
class ProfileSwitcher extends StatelessWidget {
  final void Function(BuildContext context, SwitchProfileState state)? onProfileSwitcher;

  const ProfileSwitcher({super.key, this.onProfileSwitcher});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<PetCubit>()..getOwnerPets(),
            lazy: false,
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
            if (state is ProfileSwitcherPage) {
              if (state.profile.type == ProfileType.user) {
                navigateAndFinish(context, LayoutScreen());
              }
            }
            onProfileSwitcher!(context, state);

          },
          builder: (context, state) {
            final cubit = SwitchProfileCubit.get(context);
            return ProfileSwitcherButton(
              image: cubit.image,
              name: cubit.name,
            );
          },
        ),
      ),
    );
  }
}
