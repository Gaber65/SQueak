import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              cubit.petImage == null
                  ? CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: FaIcon(
                      // Prefer the cubit's selected species; fallback to pathImage
                      (() {
                        final selected =
                            cubit.dropdownValueSpecies.toLowerCase();
                        if (selected.isNotEmpty) {
                          if (selected.contains('cat') || selected == 'coww')
                            return FontAwesomeIcons.cat;
                          if (selected.contains('dog'))
                            return FontAwesomeIcons.dog;
                          return FontAwesomeIcons.paw;
                        }
                        final fallback = pathImage.toLowerCase();
                        if (fallback.contains('cat'))
                          return FontAwesomeIcons.cat;
                        if (fallback.contains('dog'))
                          return FontAwesomeIcons.dog;
                        return FontAwesomeIcons.paw;
                      })(),
                      size: 48,
                      color: Colors.grey.shade700,
                    ),
                  )
                  : CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(cubit.petImage!),
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
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
