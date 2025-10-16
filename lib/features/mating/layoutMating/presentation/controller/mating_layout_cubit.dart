import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/service/main_service/presentation/screens/app_view.dart';
import 'package:squeak/features/mating/chat/presentation/screens/chat_list_screen.dart';
import 'package:squeak/features/mating/feeds/presentation/screens/feed_mating.dart';
import 'package:squeak/features/mating/matingRequest/presentation/screens/mating_requests_screen.dart';
import 'package:squeak/features/mating/profile/presentation/screens/pet_profile_screen.dart';

import '../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart'
    show MainCubit;

part 'mating_layout_state.dart';

class MatingLayoutCubit extends Cubit<MatingLayoutState> {
  MatingLayoutCubit() : super(MatingLayoutInitial());

  static MatingLayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  final List<Widget> screens = [
    const PetFeedScreen(),
    PetProfileScreen(
      isDarkMode: MainCubit.get(navigatorKey.currentState!.context).isDark,
    ),
    const MatingRequestsScreen(),
    ProfessionalChatListScreen(),
    const Scaffold(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }
}
