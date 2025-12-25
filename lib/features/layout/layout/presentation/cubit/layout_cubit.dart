// ignore_for_file: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/appointments/service_screen.dart';
import 'package:squeak/features/friendship/presentation/pages/pet_friend_layout.dart';
import 'package:squeak/features/layout/layout/presentation/screens/browse_screen.dart';
import 'package:squeak/features/layout/post/presentation/screens/home_screen.dart';
import 'package:squeak/features/mating/chat/presentation/screens/chat_list_screen.dart';
import 'package:squeak/features/mating/profile/presentation/screens/pet_profile_screen.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
import 'package:squeak/features/settings/persentaion/view/setting_screen.dart';
import '../../domain/entities/version_entity.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  final GetVersionUseCase getVersionUseCase;
  final GetCurrentAppVersionUseCase getCurrentAppVersionUseCase;

  LayoutCubit({
    required this.getVersionUseCase,
    required this.getCurrentAppVersionUseCase,
  }) : super(LayoutInitial());

  static LayoutCubit get(context) => BlocProvider.of(context);

  late final List<Widget> screens = [
    HomeScreen(),
    FriendsScreen(),
    PetScreen(),
    CareHubScreen(),
    SettingScreen(),
  ];
  late final List<Widget> screensPets = [
    HomeScreen(),
    FriendsScreen(),
    BrowseScreen(),
    ChatListScreen(),
    PetProfileScreen(),
  ];

  int selectedIndex = 0;
  String currentVersion = '';
  VersionEntity? versionEntity;
  bool getVersionFromBackLoading = true;

  void changeBottomNav(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      if (index == 2) {
        try {} catch (e) {
          // print('Error loading suggested friends: $e');
        }
      }

      emit(ChangeBottomNavState());
    }
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
