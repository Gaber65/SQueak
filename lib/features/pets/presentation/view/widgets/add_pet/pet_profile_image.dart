import 'package:flutter/material.dart';

import '../../../controller/pet_cubit.dart';

class PetProfileImage extends StatelessWidget {
  const PetProfileImage({
    super.key,
    required this.cubit,
    required this.pathImage,
  });

  final PetCubit cubit;
  final String pathImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: cubit.petImage == null
                    ? AssetImage(pathImage) as ImageProvider
                    : FileImage(cubit.petImage!),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 15,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    iconSize: 15,
                    onPressed: () {
                      cubit.getPetImage();
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (cubit.petImage == null)
            const Text(
              "Add a photo of your pet",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
