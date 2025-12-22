import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/mating/layoutMating/presentation/controller/mating_layout_cubit.dart';
import 'package:squeak/features/mating/layoutMating/presentation/screens/widgets/bottom_navigation.dart';

class MatingLayoutScreen extends StatelessWidget {
  const MatingLayoutScreen({super.key, this.indexID = 0});
  final int indexID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatingLayoutCubit()..changeIndex(indexID),
      child: BlocConsumer<MatingLayoutCubit, MatingLayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = MatingLayoutCubit.get(context);
          return Scaffold(
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigation(
              currentIndex: cubit.currentIndex,
              onTap: (index) => cubit.changeIndex(index),
            ),
          );
        },
      ),
    );
  }
}
