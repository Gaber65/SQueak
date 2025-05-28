import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/network/error_message_model.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

import '../../../domain/entities/vet_client.dart';
import '../../../domain/use_case/pet_async_usecase.dart';

part 'pet_async_state.dart';

class PetAsyncCubit extends Cubit<PetAsyncState> {
  final GetClientsFromVetUseCase getClientsFromVetUseCase;
  final AddInSqueakStatusUseCase addInSqueakStatusUseCase;

  PetAsyncCubit({
    required this.getClientsFromVetUseCase,
    required this.addInSqueakStatusUseCase,
  }) : super(PetAsyncInitial());

  static PetAsyncCubit get(context) => BlocProvider.of(context);

  // State variables
  bool isGetVet = false;
  bool isGetClinic = true;
  bool isAddInSqueakStatues = false;
  bool isLinkInSqueakStatues = false;
  dynamic entities;
  final List<VetClient> vetClientModel = [];

  Future<void> getClientsFromVet(
    String code,
    String phone,
    bool isFilter,
  ) async {
    emit(LoadingGetClinicState());

    CacheHelper.saveData('CodeForce', code);
    final params = GetClientsParams(
      code: code,
      phone: phone,
      isFilter: isFilter,
    );

    final result = await getClientsFromVetUseCase(params);

    result.fold(
      (failure) {
        isGetVet = false;
        emit(ErrorGetClinicState());
      },
      (clients) {
        vetClientModel.clear();
        vetClientModel.addAll(clients);

        if (isFilter) {
          vetClientModel.removeWhere(
            (element) => element.addedInSqueakStatues == true,
          );
        }

        isGetVet = true;
        emit(SuccessGetClinicState());
      },
    );
  }

  Future<void> addInSqueakStatues({
    required String vetCarePetId,
    String? squeakPetId,
    required int statuesOfAddingPetToSqueak,
  }) async {
    if (squeakPetId == null) {
      isAddInSqueakStatues = true;
    } else {
      isLinkInSqueakStatues = true;
    }

    emit(LoadingAddInSqueakStatuesState());

    final params = AddInSqueakParams(
      vetCarePetId: vetCarePetId,
      squeakPetId: squeakPetId,
      statuesOfAddingPetToSqueak: statuesOfAddingPetToSqueak,
    );

    final result = await addInSqueakStatusUseCase(params);

    result.fold(
      (failure) {
        isAddInSqueakStatues = false;
        isLinkInSqueakStatues = false;
        emit(ErrorAddInSqueakStatuesState(failure.error));
      },
      (petId) {
        isAddInSqueakStatues = false;
        isLinkInSqueakStatues = false;
        emit(SuccessAddInSqueakStatuesState(petId));
      },
    );
  }
}
