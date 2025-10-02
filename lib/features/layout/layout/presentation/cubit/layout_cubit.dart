// ignore_for_file: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/features/appointments/service_screen.dart';
import 'package:squeak/features/friendship/presentation/pages/pet_friend_layout.dart';
import 'package:squeak/features/layout/post/presentation/screens/home_screen.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
import 'package:squeak/features/settings/persentaion/view/setting_screen.dart';

import '../../../../../core/network/dio.dart';
import '../../domain/entities/version_entity.dart';
import '../../domain/usecases/get_current_app_version_usecase.dart';
import '../../domain/usecases/get_version_usecase.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  final GetVersionUseCase getVersionUseCase;
  final GetCurrentAppVersionUseCase getCurrentAppVersionUseCase;

  LayoutCubit({
    required this.getVersionUseCase,
    required this.getCurrentAppVersionUseCase,
  }) : super(LayoutInitial());

  static LayoutCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    HomeScreen(),
    FriendsScreen(),
    PetScreen(),
    CareHubScreen(),
    SettingScreen(),
  ];

  int selectedIndex = 0;
  String currentVersion = '';
  VersionEntity? versionEntity;
  bool getVersionFromBackLoading = true;

  void changeBottomNav(int index) {
    selectedIndex = index;
    emit(ChangeBottomNavState());
  }

  Future<void> getVersion() async {
    getVersionFromBackLoading = true;
    emit(GetVersionLoadingState());

    final result = await getVersionUseCase(const NoParameters());

    result.fold(
      (failure) {
        getVersionFromBackLoading = false;
        emit(GetVersionErrorState(extractFirstError(failure)));
      },
      (version) {
        versionEntity = version;
        getVersionFromBackLoading = false;
        emit(GetVersionSuccessState(version));
      },
    );
  }

  Future<void> getAppVersion() async {
    emit(GetCurrentVersionLoadingState());

    final result = await getCurrentAppVersionUseCase(const NoParameters());

    result.fold(
      (failure) {
        emit(GetCurrentVersionErrorState(extractFirstError(failure)));
      },
      (version) {
        currentVersion = version;
        emit(GetCurrentVersionSuccessState(version));
      },
    );
  }
}
