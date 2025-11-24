import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/utils/enums/profile_type.dart';
import 'package:squeak/features/mating/layoutMating/presentation/screens/widgets/profile_switcher_builder.dart';
import 'package:squeak/features/mating/profile/presentation/screens/view_pet_profile_screen.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../../../../settings/persentaion/controller/setting_cubit.dart';
import '../../domain/usecases/mating_parameters.dart';
import '../widgets/pet_card.dart';
import '../widgets/send_request_dialog.dart';

class PetFeedScreen extends StatelessWidget {
  const PetFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<MatingFeedsCubit>()..getAvailablePets(''),
        ),
        BlocProvider(create: (_) => sl<PetCubit>()..getOwnerPets()),
        BlocProvider(create: (_) => sl<SettingCubit>()..getOwnerData()),
        BlocProvider(create: (_) => sl<SwitchProfileCubit>()..loadProfile()),
      ],
      child: BlocBuilder<MatingFeedsCubit, MatingFeedsState>(
        builder: (context, state) {
          final cubit = MatingFeedsCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => navigateAndFinish(context, LayoutScreen()),
              ),
              title: Text(S.of(context).avaPetTOMating),
              actions: [buildProfileSwitcher(context)],
            ),
            body: BlocSelector<
              SwitchProfileCubit,
              SwitchProfileState,
              PetEntities?
            >(
              selector: (state) {
                if (state is ProfileLoaded &&
                    state.profile.type == ProfileType.pet) {
                  return state.profile.pet;
                }
                return null;
              },
              builder: (context, petActive) {
                return _PetFeedBody(cubit: cubit, petActive: petActive);
              },
            ),
          );
        },
      ),
    );
  }
}

class _PetFeedBody extends StatelessWidget {
  final MatingFeedsCubit cubit;
  final PetEntities? petActive;

  const _PetFeedBody({required this.cubit, required this.petActive});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context),
          const SizedBox(height: 24),
          Text(
            S.of(context).petsLookingInArea,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // 🐶 Pet List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cubit.availablePets.length,
            itemBuilder: (context, index) {
              final pet = cubit.availablePets[index];
              return PetCardMating(
                onCancelRequest: () {
                  cubit
                      .cancelRequest(
                        SendMatingRequestParameters(
                          senderPetId: petActive!.petId!,
                          targetPetId: pet.petId!,
                          message: '',
                        ),
                      )
                      .then((value) {
                        if (cubit.isRequestSent) {
                          pet.isSelected = false;
                        }
                      });
                },
                pet: pet,
                onSendRequest: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => SendRequestDialog(
                          targetPet: pet,
                          cubit: cubit,
                          senderPetId: petActive!.petId!,
                          isDarkMode: MainCubit.get(context).isDark,
                        ),
                  ).then((value) {
                    if (value) {
                      pet.isSelected = true;
                    }
                  });
                },
                onViewProfile: () {
                  navigateToScreen(
                    context,
                    ViewPetProfileScreen(
                      fromMating: true,
                      petId: pet.petId!,
                      isDarkMode: MainCubit.get(context).isDark,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color:
              MainCubit.get(context).isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.8),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(IconlyBold.heart, color: Colors.pink.shade500),
                const SizedBox(width: 8),
                Text(
                  S.of(context).welcomeToSqueak,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).welcomeSubtitle,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.pets,
                    title: S.of(context).createPetProfile,
                    subtitle: S.of(context).createPetProfileSub,
                    color: Colors.pink.shade500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.favorite,
                    title: S.of(context).findMatches,
                    subtitle: S.of(context).findMatchesSub,
                    color: Colors.red.shade500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.message,
                    title: S.of(context).startChatting,
                    subtitle: S.of(context).startChattingSub,
                    color: ColorManager.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Decorations.kDecorationBoxShadow(context: context),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
