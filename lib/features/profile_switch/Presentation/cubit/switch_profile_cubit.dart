import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/features/profile_switch/domain/entities/profile_type_entity.dart';
import 'package:squeak/features/profile_switch/domain/usecase/get_active_profile.dart';
import 'package:squeak/features/profile_switch/domain/usecase/save_active_profile.dart';

import '../../../../core/network/end_points.dart';
import '../../../../core/utils/enums/profile_type.dart';



class SwitchProfileCubit extends Cubit<SwitchProfileState> {
  final GetActiveProfileUseCase getActiveProfile;
  final SaveActiveProfileUseCase saveActiveProfile;

  SwitchProfileCubit(this.getActiveProfile, this.saveActiveProfile) : super(ProfileInitial());

  static SwitchProfileCubit get(BuildContext context) =>
      BlocProvider.of<SwitchProfileCubit>(context);


  ActiveProfile? activeProfile;
  String image = imageUrl;
  String name = "S";
  String specieId = "";
  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await getActiveProfile(const NoParameters());
    result.fold(
          (failure) {
            // print(failure.error.message);
            emit(ProfileError(failure.error.message));
          },
          (profile) {
            // print(profile.toJson());
            activeProfile = profile;
            if (activeProfile!.type == ProfileType.pet) {
              image = imageUrl +activeProfile!.pet!.imageName!;
              name = activeProfile!.pet!.petName!.substring(0, 1);
              specieId = activeProfile!.pet!.specieId!;
            } else {
              image = imageUrl + activeProfile!.user!.imageName;
            }
            emit(ProfileLoaded(profile));
          },
    );
  }

  Future<void> switchProfile(ActiveProfile profile) async {
    emit(ProfileLoading());
    final result = await saveActiveProfile(profile);
    result.fold(
          (failure) => emit(ProfileError(failure.error.message)),
          (_) {
            loadProfile();
            emit(ProfileLoaded(profile));
          },
    );
  }

  bool get isPet {
    if(activeProfile == null) return false;
    return activeProfile?.type == ProfileType.pet;
  }

}
