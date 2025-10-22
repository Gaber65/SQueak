import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/utils/enums/profile_type.dart';
import 'package:squeak/features/settings/persentaion/controller/setting_cubit.dart';
import '../../../../pets/domain/entities/pet_entity.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../../../layoutMating/presentation/screens/widgets/profile_switcher_builder.dart';
import 'widgets/mating_requests_body.dart';

class MatingRequestsScreen extends StatelessWidget {
  const MatingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ManageRequestMatingCubit>()),
        BlocProvider(create: (_) => sl<PetCubit>()..getOwnerPets()),
        BlocProvider(create: (_) => sl<SettingCubit>()..getOwnerData()),
        BlocProvider(create: (_) => sl<ChatListCubit>()),
        BlocProvider(create: (_) => sl<SwitchProfileCubit>()..loadProfile()),
      ],
      child: BlocConsumer<ManageRequestMatingCubit, ManageRequestMatingState>(
        listener: (context, state) {
          if(state is UpdateMatingRequestLoaded && state.message.contains('0000')){
            ManageRequestMatingCubit.get(context).getChatItem(ChatListCubit.get(context).allChats);
          }
        },
        builder: (context, state) {
          final cubit = ManageRequestMatingCubit.get(context);
          final cubitList = ChatListCubit.get(context);
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: _buildAppBar(context),
              body: BlocSelector<
                SwitchProfileCubit,
                SwitchProfileState,
                PetEntities?
              >(
                selector: (state) {
                  if (state is ProfileLoaded &&
                      state.profile.type == ProfileType.pet) {
                    cubit.fetchMatingRequests(state.profile.pet!.petId!);
                    cubit.fetchSentRequests(state.profile.pet!.petId!);
                    cubitList.loadChats(state.profile.pet!.petId!).then(
                      (value) {
                      },
                    );
                    return state.profile.pet;
                  }
                  return null;
                },
                builder: (context, petActive) {
                  return MatingRequestsBody(
                    cubit,
                    petActive?.petName ?? 'Current Profile',
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorManager.primaryColor),
        onPressed: () => navigateAndFinish(context, LayoutScreen()),
      ),
      title: Text(
        S.of(context).mangeMatingRequests,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        buildProfileSwitcher(context),

      ],
    );
  }
}
