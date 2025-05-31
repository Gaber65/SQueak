import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/features/layout/search/domain/entities/clinic_search_entity.dart';
import 'package:squeak/features/layout/search/domain/entities/vet_client_search_entity.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/usecase/follow_clinic_use_case.dart';
import '../../domain/usecase/get_client_form_vet_use_case.dart';
import '../../domain/usecase/get_search_list_use_case.dart';
import '../../domain/usecase/get_supplier_use_case.dart';
import '../../domain/usecase/unfollow_clinic_use_case.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  GetSearchListUseCase getSearchListUseCase;
  FollowClinicUseCase followClinicUseCase;
  UnfollowClinicUseCase unfollowClinicUseCase;
  GetClientFormVetUseCase getClintFormVetUseCase;
  GetSupplierUseCase getSupplierUseCase;

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
  bool isFollowBefore = false;
  SupplierEntitySearch? suppliers;
  List<VetSearchClientEntity> vetClientModel = [];
  bool isGetVet = false;

  Future<void> getSearchList() async {
    emit(SearchLoading());
    final result = await getSearchListUseCase.call(searchController.text);
    result.fold((failure) => emit(SearchError()), (clinics) {
      searchList = clinics;
      if (suppliers != null && searchList.isNotEmpty) {
        ClinicInfoEntitySearch? clinic = findClinic(
          suppliers!.clinics,
          searchList[0].code,
        );
        if (clinic != null) {
          isFollowBefore = true;
        }
      }
      emit(SearchSuccess());
    });
  }

  Future<void> followClinic(String clinicId) async {
    emit(FollowLoading());
    final result = await followClinicUseCase.call(clinicId);
    result.fold((failure) => emit(FollowError(failure)), (clinic) {
      getClintFormVetVoid(searchController.text, false).then((value) {
        if (value.isNotEmpty) {
          if (value.first.id.contains('0000')) {
            emit(FollowSuccess(false));
          } else {
            emit(FollowSuccess(true));
          }
        } else {
          emit(FollowSuccess(false));
        }
      });
    });
  }

  Future<void> unfollowClinic(String clinicId) async {
    emit(FollowLoading());
    final result = await unfollowClinicUseCase.call(clinicId);
    result.fold(
      (failure) => emit(FollowError(failure)),
      (clinic) {
        CacheHelper.removeData('posts');
        emit(FollowSuccess(false));
      },
    );
  }

  Future<List<VetSearchClientEntity>> getClintFormVetVoid(
    String clinicCode,
    bool isFilter,
  ) async {
    emit(FollowLoading());
    final result = await getClintFormVetUseCase.call(clinicCode);

    result.fold((failure) {}, (clients) {
      if (clients.isNotEmpty) {
        if (isFilter) {
          vetClientModel =
              clients
                  .where((element) => element.addedInSqueakStatues == false)
                  .toList();
        } else {
          vetClientModel = clients;
        }
        emit(FollowSuccess(true));
      } else {
        vetClientModel.clear();
        emit(FollowSuccess(false));
      }
    });

    return vetClientModel;
  }

  Future<void> getSupplier() async {
    emit(GetSupplierLoading());
    final result = await getSupplierUseCase.call(NoParameters());
    result.fold((failure) => emit(GetSupplierError()), (supplier) {
      suppliers = supplier;
      emit(GetSupplierSuccess());
    });
  }

  ClinicInfoEntitySearch? findClinic(
    List<ClinicInfoEntitySearch> data,
    String clinicId,
  ) {
    for (var element in data) {
      if (element.clinic.code == clinicId) {
        return element;
      }
    }
    return null;
  }
}
