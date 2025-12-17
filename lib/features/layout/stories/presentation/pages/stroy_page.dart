import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/layout/stories/presentation/controllers/story_cubit.dart';

import '../../../../../core/service/service_locator/service_locator.dart';
import '../widgets/story_list/stories_bar.dart';

class StoryPage extends StatelessWidget {
  const StoryPage({super.key, required this.imagePath, required this.petID});
  final String imagePath;
  final String petID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<StoryCubit>()
                ..loadMyStories(petID)
                ..loadFriendsStories(petID),
      child: StoriesBar(imagePath: imagePath, petID: petID),
    );
  }
}
