import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/layoutMating/presentation/screens/widgets/profile_switcher_builder.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';

import '../../../../../core/utils/enums/profile_type.dart' show ProfileType;

import '../../../../settings/persentaion/controller/setting_cubit.dart';
import '../widgets/pet_profile_header.dart';
import '../widgets/pet_tabs_section.dart';

class PetProfileScreen extends StatelessWidget {
  final bool isDarkMode;

  const PetProfileScreen({super.key, this.isDarkMode = false});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProfileMatingCubit>()),
        BlocProvider(create: (_) => sl<PetCubit>()..getOwnerPets()),
        BlocProvider(create: (_) => sl<SettingCubit>()..getOwnerData()),
        BlocProvider(create: (_) => sl<SwitchProfileCubit>()..loadProfile()),
      ],
      child: BlocConsumer<ProfileMatingCubit, ProfileMatingState>(
        listener: (context, state) {
          if (state is ProfileChangeMatingError) {
            errorToast(context, state.message);
          }
          if (state is ProfileChangeMatingSuccess) {
            ProfileMatingCubit.get(context).getPetProfileMating(state.petId);
            ProfileMatingCubit.get(context).getPetProfileMatingHistory(state.petId);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = ProfileMatingCubit.get(context);
          return BlocSelector<
            SwitchProfileCubit,
            SwitchProfileState,
            PetEntities?
          >(
            selector: (state) {
              if (state is ProfileLoaded &&
                  state.profile.type == ProfileType.pet) {
                cubit.getPetProfileMating(state.profile.pet!.petId!);
                cubit.getPetProfileMatingHistory(state.profile.pet!.petId!);
                return state.profile.pet;
              }
              return null;
            },
            builder: (context, activePet) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    S.of(context).profile,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.transparent,
                  actions: [
                    buildProfileSwitcher(context),
                  ],
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            MainCubit.get(context).isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    ),
                    onPressed: () => navigateAndFinish(context, LayoutScreen()),
                  ),
                ),
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      if (cubit.petProfileMating != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PetProfileHeader(
                              pet: cubit.petProfileMating!,
                              cubit: cubit,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        ),
                    ];
                  },
                  body:
                      (cubit.petProfileMating != null)
                          ? PetTabsSection(
                            pet: cubit.petProfileMating!,
                            isDarkMode: isDarkMode,
                          )
                          : SizedBox(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
