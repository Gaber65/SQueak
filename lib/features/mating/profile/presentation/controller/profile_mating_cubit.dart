import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/network/dio.dart';
import 'package:squeak/features/mating/profile/domain/usecases/get_pet_profile_history_usecase.dart';
import 'package:squeak/features/mating/profile/domain/usecases/update_pet_mating_statues_usecase.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../domain/entities/history_entities.dart';
import '../../domain/usecases/get_pet_profile_usecase.dart';
import '../../domain/usecases/mating_profile_prams.dart';

part 'profile_mating_state.dart';

class ProfileMatingCubit extends Cubit<ProfileMatingState> {
  ProfileMatingCubit(
    this.updatePetMatingStatuesUseCase,
    this.getPetProfileMatingUseCase,
    this.getPetHistoryMatingUseCase,
  ) : super(ProfileMatingInitial());

  static ProfileMatingCubit get(context) => BlocProvider.of(context);

  UpdatePetMatingStatuesUseCase updatePetMatingStatuesUseCase;
  GetPetProfileMatingUseCase getPetProfileMatingUseCase;
  GetPetHistoryMatingUseCase getPetHistoryMatingUseCase;

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> updatePetMatingStatues(MatingProfileParams params) async {
    isLoading = true;
    emit(ProfileChangeMatingLoading());
    final result = await updatePetMatingStatuesUseCase(params);
    result.fold(
      (failure) {
        isLoading = false;
        emit(ProfileChangeMatingError(extractFirstErrorAuth(failure.error)));
      },
      (r) {
        isLoading = false;
        emit(ProfileChangeMatingSuccess(params.petId));
      },
    );
  }

  PetEntities? petProfileMating;
  Future<void> getPetProfileMating(String petId) async {
    emit(ProfileGetMatingLoading());
    final result = await getPetProfileMatingUseCase(petId);
    result.fold(
      (failure) {
        emit(ProfileGetMatingError(extractFirstErrorAuth(failure.error)));
      },
      (r) {
        petProfileMating = r;
        emit(ProfileGetMatingSuccess(r));
      },
    );
  }

  List<HistoryEntity>? petProfileMatingHistory;
  Future<void> getPetProfileMatingHistory(String petId) async {
    emit(ProfileGetMatingHistoryLoading());
    final result = await getPetHistoryMatingUseCase(petId);
    result.fold(
      (failure) {
        emit(
          ProfileGetMatingHistoryError(extractFirstErrorAuth(failure.error)),
        );
      },
      (r) {
        petProfileMatingHistory = r;
        emit(ProfileGetMatingHistorySuccess(r));
      },
    );
  }
}
