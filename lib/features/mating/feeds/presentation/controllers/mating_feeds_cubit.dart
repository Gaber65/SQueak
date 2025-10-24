import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:squeak/core/network/dio.dart';
import 'package:squeak/features/mating/feeds/domain/entities/mating_request_entity.dart';
import 'package:squeak/features/mating/feeds/domain/usecases/get_available_pets_usecase.dart';
import 'package:squeak/features/mating/feeds/domain/usecases/update_pet_status_usecase.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../domain/usecases/mating_parameters.dart';
import '../../domain/usecases/send_mating_request_usecase.dart';

part 'mating_feeds_state.dart';

class MatingFeedsCubit extends Cubit<MatingFeedsState> {
  final GetAvailablePetsUseCase getAvailablePetsUseCase;
  final SendMatingRequestUseCase sendMatingRequestUseCase;
  final UpdateSentRequestStatusUseCase updatePetStatusUseCase;

  MatingFeedsCubit({
    required this.getAvailablePetsUseCase,
    required this.sendMatingRequestUseCase,
    required this.updatePetStatusUseCase,
  }) : super(MatingFeedsInitial());

  static MatingFeedsCubit get(BuildContext context) =>
      BlocProvider.of<MatingFeedsCubit>(context);
  List<PetEntities> availablePets = [];

  /// 🔹 Get Available Pets
  Future<void> getAvailablePets(String specieId) async {
    emit(MatingFeedsLoading());
    final result = await getAvailablePetsUseCase(specieId);
    result.fold((failure) => emit(MatingFeedsError(failure.error.message)), (
      pets,
    ) {
      availablePets.addAll(pets);
      emit(MatingFeedsLoaded(pets));
    });
  }

  /// 🔹 Send Mating Request
  Future<Either<String, MatingRequestStatus>> sendMatingRequest(
    SendMatingRequestParameters params,
  ) async {
    emit(MatingFeedsLoading());

    final result = await sendMatingRequestUseCase(params);

    return result.fold(
      (failure) {
        emit(MatingFeedsError(failure.error.message));
        return Left(extractFirstErrorAuth(failure.error));
      },
      (_) {
        emit(MatingRequestSentSuccess());
        return Right(MatingRequestStatus.success);
      },
    );
  }


  bool isRequestSent = false;
  /// 🔹 Update Pet Status
  Future<void> cancelRequest(SendMatingRequestParameters params) async {
    emit(MatingFeedsLoading());
    final result = await updatePetStatusUseCase(params);
    result.fold(
      (failure) => emit(MatingFeedsError(failure.error.message)),
      (_) {
        isRequestSent = true;
        emit(MatingStatusUpdated());
      },
    );
  }
}
