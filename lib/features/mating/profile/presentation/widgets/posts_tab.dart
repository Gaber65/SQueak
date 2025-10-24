import 'package:flutter/material.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/post_mating_item.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';


class PostsTab extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;

  const PostsTab({
    super.key,
    required this.pet,
    required this.isDarkMode,
  });


  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: pet.post.length,
      itemBuilder: (context, index) {
        final post = pet.post[index];
        return BuildPostItemMaying(
          petEntities: pet ,
          postItem: post,
        );
      },
    );
  }
}