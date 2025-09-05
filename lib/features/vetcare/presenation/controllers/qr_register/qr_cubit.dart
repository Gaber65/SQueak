import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import 'package:squeak/features/vetcare/domain/entities/vet_client.dart';
import 'package:squeak/features/vetcare/domain/use_case/follow_clinic_usecase.dart';
import '../../../domain/base_repo/qr_base_repo.dart';
import '../../../domain/use_case/check_clinic_usecase.dart';
import '../../../domain/use_case/get_vet_clients_usecase.dart';
import 'qr_state.dart';

class QRCubit extends Cubit<QRState> {
  final CheckClinicInSupplierUseCase checkClinicInSupplierUseCase;
  final FollowQRClinicUseCase followClinicUseCase;
  final GetVetClientsUseCase getVetClientsUseCase;

  QRCubit({
    required this.checkClinicInSupplierUseCase,
    required this.followClinicUseCase,
    required this.getVetClientsUseCase,
  }) : super(QRInitial());

  static QRCubit get(context) => BlocProvider.of(context);

  bool isAlreadyFollow = false;
  int countdown = 5;
  bool isLoading = true;
  bool isConfirmed = false;
  bool isGetVet = false;
  List<VetClient> vetClientModel = [];
  MySupplier? suppliersList;

  Future<void> checkClinicInMySupplier(String clinicCode, suppliers) async {
    emit(QRLoading());

    final result = await checkClinicInSupplierUseCase(
      CheckClinicParams(clinicCode: clinicCode, suppliers: suppliers),
    );

    result.fold(
      (failure) {
        isLoading = false;
        emit(QRError(failure.error.message));
      },
      (isFollow) {
        isAlreadyFollow = isFollow;
        isLoading = false;
        suppliersList = suppliers;
        print('isAlreadyFollow $isAlreadyFollow');
        emit(QRLoaded(isAlreadyFollow: isAlreadyFollow));
      },
    );
  }

  Future<void> followClinic(String clinicCode) async {
    _startCountdown();
    emit(QRFollowing());

    final result = await followClinicUseCase(
      FollowClinicParams(clinicCode: clinicCode),
    );

    result.fold(
      (failure) {
        emit(QRError(failure.error.message));
      },
      (success) async {
        isConfirmed = true;
        await _getClientFromVet(clinicCode, false);
        emit(QRFollowed());
      },
    );
  }

  Future<void> getVetClients(String code, bool isFilter) async {
    final result = await getVetClientsUseCase(
      GetVetClientsParams(code: code, isFilter: isFilter),
    );

    result.fold(
      (failure) {
        isGetVet = false;
        emit(QRError(failure.error.message));
      },
      (clients) {
        vetClientModel = clients;
        isGetVet = true;
        emit(QRVetClientsLoaded(clients: clients));
      },
    );
  }

  Future<void> _getClientFromVet(String code, bool isFilter) async {
    final result = await getVetClientsUseCase(
      GetVetClientsParams(code: code, isFilter: isFilter),
    );

    result.fold(
      (failure) {
        emit(QRFollowSuccess(false));
      },
      (clients) {
        if (clients.isNotEmpty) {
          if (clients.first.id.contains('0000')) {
            emit(QRFollowSuccess(false));
          } else {
            emit(QRFollowSuccess(true));
          }
        } else {
          emit(QRFollowSuccess(false));
        }
      },
    );
  }

  void _startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        emit(QRFollowing());
      } else {
        timer.cancel();
      }
    });
  }
}
