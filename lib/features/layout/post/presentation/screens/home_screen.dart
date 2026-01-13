import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/layout/post/presentation/controller/post_cubit.dart';
import 'package:squeak/features/layout/post/presentation/widget/appbar_home_item.dart';
import 'package:squeak/features/layout/post/presentation/widget/get_posts_when_user_follow.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../../../../core/utils/enums/profile_type.dart' show ProfileType;
import '../../../../pets/domain/entities/pet_entity.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../../../stories/presentation/controllers/story_cubit.dart';
import '../../../stories/presentation/pages/stroy_page.dart';
import '../widget/add_post_form.dart';
import '../widget/build_search_box.dart';
import '../widget/loading_posts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PostCubit>()),
        BlocProvider(create: (context) => sl<StoryCubit>()),
      ],
      child: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is DeletePostErrorState) {
            errorToast(context, state.message);
          }
        },
        builder: (context, postState) {
          var cubit = PostCubit.get(context);
          var storyCubit = StoryCubit.get(context);
          String imagePath = '';
          return BlocSelector<
            SwitchProfileCubit,
            SwitchProfileState,
            PetEntities?
          >(
            selector: (state) {
              if (state is ProfileLoaded &&
                  state.profile.type == ProfileType.pet) {
                cubit.clearUserPosts();
                cubit.getAllUserPosts(state.profile.pet!.petId!);
                storyCubit.loadMyStories(state.profile.pet!.petId!);
                storyCubit.loadFriendsStories(state.profile.pet!.petId!);

                imagePath = imageUrl + state.profile.pet!.imageName!;
                return state.profile.pet;
              } else if (state is ProfileLoaded && state.profile.type == ProfileType.user) {
                imagePath = imageUrl + state.profile.user!.imageName;
                cubit.clearUserPosts();
                cubit.getAllUserPosts('');
              } else {
                cubit.clearUserPosts();
                cubit.getAllUserPosts('');
              }

              return null;
            },
            builder: (context, state) {
              return Scaffold(
                appBar: buildAppBarHome(context, state?.petId ?? ''),
                body: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    return false;
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildBody(
                          cubit,
                          postState,
                          state?.petId ?? '',
                          context,
                          imagePath,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(
    PostCubit cubit,
    PostState state,
    String petId,
    BuildContext context,
    String imagePath,
  ) {
    if (state is GetPostLoadingState && cubit.userPosts.isEmpty) {
      return buildShimmerLoading();
    }

    if (cubit.userPosts.isEmpty) {
      return Column(
        children: [
          buildWhatsonyourmindSanjay(context, petId),
          StoryPage(imagePath: imagePath, petID: petId),
          buildSearchBox(cubit),
        ],
      );
    }

    return buildNotificationListenerUserPosts(
      cubit,
      state,
      petId,
      context,
      imagePath,
      SwitchProfileCubit.get(context).activeProfile,
    );
  }
}
