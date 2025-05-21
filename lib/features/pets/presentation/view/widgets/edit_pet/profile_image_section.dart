import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/pets/presentation/view/widgets/edit_pet/utils/image_picker_utils.dart';

import '../../../controller/pet_cubit.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({
    super.key,
    required this.pets,
    required this.cubit,
  });

  final PetEntities pets;
  final PetCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorManager.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child:
                  cubit.petImage == null
                      ? Image.network(
                        (pets.imageName == null ||
                                pets.imageName == 'PetAvatar.png' ||
                                pets.imageName!.isEmpty)
                            ? AssetImageModel.defaultPetImage
                            : imageUrl + pets.imageName!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Image.asset(
                              pets.specieId ==
                                      'f1131363-3b9f-40ee-9a89-0573ee274a10'
                                  ? 'assets/cat-with-gold.jpg'
                                  : 'assets/dog.png',
                              fit: BoxFit.cover,
                            ),
                      )
                      : Image.file(cubit.petImage!, fit: BoxFit.cover),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ColorManager.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              icon: Icon(Icons.edit, size: 18),
              color: Colors.white,
              onPressed: () => showImageOptions(context, cubit, pets),
            ),
          ),
        ],
      ),
    );
  }
}
