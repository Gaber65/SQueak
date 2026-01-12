import 'package:flutter/material.dart';

import '../widgets/story_list/stories_bar.dart';

class StoryPage extends StatelessWidget {
  const StoryPage({super.key, required this.imagePath, required this.petID});
  final String imagePath;
  final String petID;
  @override
  Widget build(BuildContext context) {
    return StoriesBar(imagePath: imagePath, petID: petID);
  }
}
