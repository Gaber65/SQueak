import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/mating/layoutMating/presentation/screens/mating_layout.dart';
import 'package:squeak/features/mating/layoutMating/presentation/screens/widgets/mating_pet_feature_switch.dart';
import 'package:squeak/features/mating/layoutMating/presentation/screens/widgets/pet_profile_is_not_complete.dart';
import 'package:squeak/features/mating/layoutMating/presentation/screens/widgets/reusable_profile_switcher_widget.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../../../core/utils/enums/profile_type.dart';
import '../../../../settings/persentaion/controller/setting_cubit.dart';

class ProfileComplete extends StatelessWidget {
  const ProfileComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
            navigateAndFinish(context, ProfileComplete());
          }
        },
        builder: (context, state) {
          var cubit = SwitchProfileCubit.get(context);
          if (state is ProfileLoaded) {
            if (cubit.activeProfile!.type == ProfileType.user) {
              return Scaffold(
                appBar: AppBar(title: Text(S.of(context).switchTitle)),
                body: ProfileSwitchMatingNotificationScreen(),
              );
            } else if (cubit.activeProfile!.pet!.isValid) {
              return MatingLayoutScreen();
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(S.of(context).CompletePetProfile),
                  actions: [
                    ProfileSwitcher(onProfileSwitcher: (context, state) {}),
                  ],
                ),
                body: PetProfileIncompleteScreen(
                  pet: cubit.activeProfile!.pet!,
                ),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(title: Text(S.of(context).switchTitle)),
              body: ProfileSwitchMatingNotificationScreen(),
            );
          }
        },
      ),
    );
  }
}
