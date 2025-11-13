import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/matingRequest/domain/entities/mating_request_entity.dart';

import '../../domain/usecases/update_mating_request.dart';

part 'manage_request_mating_state.dart';

class ManageRequestMatingCubit extends Cubit<ManageRequestMatingState> {
  ManageRequestMatingCubit(
    this.getMatingRequestsUseCase,
    this.getSentRequestsUseCase,
    this.updateMatingRequestUseCase,
  ) : super(ManageRequestMatingInitial());

  static ManageRequestMatingCubit get(context) => BlocProvider.of(context);
  final GetMatingRequestsUseCase getMatingRequestsUseCase;
  final GetSentRequestsMatingUseCase getSentRequestsUseCase;
  final UpdateMatingRequestUseCase updateMatingRequestUseCase;

  List<MatingRequestEntity> dummyMatingRequests = [];
  Future<void> fetchMatingRequests(String petId) async {
    emit(GetMyMatingRequestLoading());
    final result = await getMatingRequestsUseCase(petId);
    result.fold(
      (failure) => emit(GetMyMatingRequestError(failure.error.message)),
      (requests) {
        dummyMatingRequests = requests;
        emit(GetMyMatingRequestLoaded(requests));
      },
    );
  }

  List<MatingRequestEntity> dummyMatingSent = [];
  Future<void> fetchSentRequests(String petId) async {
    emit(GetMyMatingRequestLoading());
    final result = await getSentRequestsUseCase(petId);
    result.fold(
      (failure) => emit(GetMyMatingRequestError(failure.error.message)),
      (requests) {
        dummyMatingSent = requests;
        emit(GetMyMatingRequestLoaded(requests));
      },
    );
  }

  String conversationId = '';
  Future<void> updateRequestStatus(
    UpdateRequestStatusParams params,
    bool isSent,
  ) async {
    emit(UpdateMatingRequestLoading());
    final result = await updateMatingRequestUseCase(params);
    result.fold(
      (failure) => emit(UpdateMatingRequestError(failure.error.message)),
      (conversationId) {
        if (params.status != RequestStatus.canceled) {
          if (isSent) {
            dummyMatingSent.removeWhere(
              (element) => element.id == params.matingRequestId,
            );
          } else {
            for (final element in dummyMatingRequests) {
              if (element.id == params.matingRequestId) {
                element.status = params.status;
                break;
              }
            }

            if (params.status == RequestStatus.rejected) {
              dummyMatingRequests.removeWhere(
                (element) => element.id == params.matingRequestId,
              );
            }

            if (params.status == RequestStatus.canceled) {
              dummyMatingSent.removeWhere(
                (element) => element.id == params.matingRequestId,
              );
            }
          }
        } else {
          dummyMatingSent.removeWhere(
            (element) => element.id == params.matingRequestId,
          );
        }

        this.conversationId = conversationId;
        emit(UpdateMatingRequestLoaded(conversationId));
      },
    );
  }
  ChatEntity? chatEntity;

  void getChatItem(List<ChatEntity> chatItem) {
    try {
      chatEntity = chatItem.firstWhere((element) => element.id == conversationId);
    } catch (e) {
      chatEntity = null;
    }
  }
}
