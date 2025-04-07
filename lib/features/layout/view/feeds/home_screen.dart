import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:squeak/features/layout/controller/FeedsCubit/feeds_cubit.dart';
import 'package:squeak/features/layout/controller/SearchCubit/search_cubit.dart';
import 'package:squeak/features/layout/view/feeds/widget/appbar_home_item.dart';
import 'package:squeak/features/layout/view/feeds/widget/get_posts_when_user_follow.dart';

import 'package:squeak/features/layout/view/search/search_screen.dart';

import '../../../../core/constant/global_widget/toast.dart';
import '../../../../core/thames/styles.dart';
import '../../../vetcare/view/pet_merge_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedsCubit()..init(),
      child: BlocConsumer<FeedsCubit, FeedsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = FeedsCubit.get(context);
          return Scaffold(
            appBar: buildAppBarHome(context),
            body: (cubit.userPosts.isEmpty)
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: BlocProvider(
                      create: (context) => SearchCubit(),
                      child: BlocConsumer<SearchCubit, SearchState>(
                        listener: (context, state) {
                          if (state is FollowError) {
                            errorToast(
                              context,
                              state.error.errors.isNotEmpty
                                  ? state.error.errors.values.first.first
                                  : state.error.message,
                            );
                          }

                          if (state is FollowSuccess) {
                            if (state.isHavePet) {
                              navigateAndFinish(
                                context,
                                PetMergeScreen(
                                  Code: SearchCubit.get(context)
                                      .searchController
                                      .text,
                                  isNavigation: true,
                                ),
                              );
                            } else {
                              cubit.init();
                            }
                          }
                        },
                        builder: (context, state) {
                          var cubit = SearchCubit.get(context);
                          return buildColumnSearchBody(
                              cubit,
                              state,
                              'https://lottie.host/e4e07617-64ba-4c41-89a4-c0f752e83267/aRzu88O6ZO.json',
                              context);
                        },
                      ),
                    ),
                  )
                : buildNotificationListenerUserPosts(cubit, state),
          );
        },
      ),
    );
  }
}
