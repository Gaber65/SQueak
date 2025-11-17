import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import '../widgets/pet_profile_header.dart';
import '../widgets/pet_tabs_section.dart';

class ViewPetProfileScreen extends StatelessWidget {
  final bool isDarkMode;
  final String petId;

  const ViewPetProfileScreen({
    super.key,
    this.isDarkMode = false,
    required this.petId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<ProfileMatingCubit>()
                ..getPetProfileMating(petId)
                ..getPetProfileMatingHistory(petId),

      child: BlocConsumer<ProfileMatingCubit, ProfileMatingState>(
        listener: (context, state) {
          if (state is ProfileChangeMatingError) {
            errorToast(context, state.message);
          }
          if (state is ProfileChangeMatingSuccess) {
            ProfileMatingCubit.get(context).getPetProfileMating(state.petId);
            ProfileMatingCubit.get(
              context,
            ).getPetProfileMatingHistory(state.petId);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = ProfileMatingCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(S.of(context).viewProfile),
              backgroundColor: Colors.transparent,
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
                      : DogLoadingStateWidget(
                        theme: Theme.of(context),
                        isDark: Theme.of(context).brightness == Brightness.dark,
                        s: S.of(context),
                        text: S.of(context).loadingProfile,
                      ),
            ),
          );
        },
      ),
    );
  }
}
