import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/features/layout/search/domain/entities/clinic_search_entity.dart';
import 'package:squeak/features/layout/search/domain/entities/vet_client_search_entity.dart';

import '../../domain/usecase/follow_clinic_use_case.dart';
import '../../domain/usecase/get_client_form_vet_use_case.dart';
import '../../domain/usecase/get_search_list_use_case.dart';
import '../../domain/usecase/get_supplier_use_case.dart';
import '../../domain/usecase/unfollow_clinic_use_case.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GetSearchListUseCase getSearchListUseCase;
  final FollowClinicUseCase followClinicUseCase;
  final UnfollowClinicUseCase unfollowClinicUseCase;
  final GetClientFormVetUseCase getClintFormVetUseCase;
  final GetSupplierUseCase getSupplierUseCase;

  SearchCubit(
    this.getSearchListUseCase,
    this.followClinicUseCase,
    this.unfollowClinicUseCase,
    this.getClintFormVetUseCase,
    this.getSupplierUseCase,
  ) : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  final TextEditingController searchController = TextEditingController();

  List<ClinicEntitySearch> searchList = [];
  SupplierEntitySearch? suppliers;
  List<VetSearchClientEntity> vetClientModel = [];
  bool isFollowBefore = false;

  Future<void> getSearchList() async {
    emit(SearchLoading());

    final result =
        await getSearchListUseCase.call(searchController.text);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(SearchError());
      },
      (clinics) {
        searchList = clinics;

        if (suppliers != null && searchList.isNotEmpty) {
          final clinic = findClinic(
            suppliers!.clinics,
            searchList.first.code,
          );
          isFollowBefore = clinic != null;
        }

        if (isClosed) return;
        emit(SearchSuccess());
      },
    );
  }

  Future<void> followClinic(String clinicId) async {
    emit(FollowLoading());

    final result = await followClinicUseCase.call(clinicId);

    await result.fold(
      (failure) async {
        if (isClosed) return;
        emit(FollowError(failure));
      },
      (clinic) async {
        final clients = await _getClients(
          searchController.text,
          false,
        );

        if (isClosed) return;

        if (clients.isNotEmpty &&
            !clients.first.id.contains('0000')) {
          emit(FollowSuccess(true));
        } else {
          emit(FollowSuccess(false));
        }
      },
    );
  }

  Future<void> unfollowClinic(String clinicId) async {
    emit(FollowLoading());

    final result = await unfollowClinicUseCase.call(clinicId);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(FollowError(failure));
      },
      (clinic) {
        CacheHelper.removeData('posts');
        if (isClosed) return;
        emit(FollowSuccess(false));
      },
    );
  }

  Future<List<VetSearchClientEntity>> _getClients(
    String clinicCode,
    bool isFilter,
  ) async {
    final result =
        await getClintFormVetUseCase.call(clinicCode);

    return result.fold(
      (failure) => [],
      (clients) {
        if (isFilter) {
          return clients
              .where(
                (e) => e.addedInSqueakStatues == false,
              )
              .toList();
        }
        return clients;
      },
    );
  }

  Future<void> getSupplier() async {
    emit(GetSupplierLoading());

    final result =
        await getSupplierUseCase.call(NoParameters());

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(GetSupplierError());
      },
      (supplier) {
        suppliers = supplier;
        if (isClosed) return;
        emit(GetSupplierSuccess());
      },
    );
  }

  ClinicInfoEntitySearch? findClinic(
    List<ClinicInfoEntitySearch> data,
    String clinicId,
  ) {
    for (final element in data) {
      if (element.clinic.code == clinicId) {
        return element;
      }
    }
    return null;
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
