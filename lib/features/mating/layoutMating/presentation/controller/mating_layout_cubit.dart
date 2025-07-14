import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:squeak/features/mating/feeds/presentation/screens/feed_mating.dart';
import 'package:squeak/features/mating/matingRequest/presentation/screens/mating_requests_screen.dart';

part 'mating_layout_state.dart';

class MatingLayoutCubit extends Cubit<MatingLayoutState> {
  MatingLayoutCubit() : super(MatingLayoutInitial());

  static MatingLayoutCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;

  final List<Widget> screens = [
    const PetFeedScreen(),
    const Scaffold(),
    const MatingRequestsScreen(),
    const Scaffold(),
    const Scaffold(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }
}
