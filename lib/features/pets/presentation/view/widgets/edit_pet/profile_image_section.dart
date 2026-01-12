import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    // Prefer the cubit's currently selected species id (updated when user
    // taps species cards). Fall back to the pet model's specieId if cubit's
    // value is empty. This prevents mismatch where the UI selection and the
    // pet model disagree.
    final speciesId =
        (cubit.dropdownValueSpeciesId.isNotEmpty)
            ? cubit.dropdownValueSpeciesId
            : (pets.specieId ?? '');
    final isCat = speciesId == PetCubit.catSpeciesId;
    final isDog = speciesId == PetCubit.dogSpeciesId;
    final FaIcon speciesIcon = FaIcon(
      isCat
          ? FontAwesomeIcons.cat
          : (isDog ? FontAwesomeIcons.dog : FontAwesomeIcons.paw),
      size: 40,
      color: ColorManager.primaryColor,
    );
    final String speciesLabel =
        isCat
            ? (isArabic() ? 'قطة' : 'Cat')
            : (isDog
                ? (isArabic() ? 'كلب' : 'Dog')
                : (isArabic() ? 'حيوان' : 'Pet'));

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
                      ? (cubit.imageNameController.text.isEmpty
                          // No image name -> show species icon + label inside the circle
                          ? Container(
                            color:
                                MainCubit.get(context).isDark
                                    ? Colors.grey[850]
                                    : Colors.grey[200],
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  speciesIcon,
                                  const SizedBox(height: 6),
                                  Text(
                                    speciesLabel,
                                    style: TextStyle(
                                      color:
                                          MainCubit.get(context).isDark
                                              ? Colors.white
                                              : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : SafeFastCachedImageExtension.safe(
                            url: imageUrl + (pets.imageName ?? ''),
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                                  color:
                                      MainCubit.get(context).isDark
                                          ? Colors.grey[850]
                                          : Colors.grey[200],
                                  child: Center(
                                    child: FaIcon(
                                      isCat
                                          ? FontAwesomeIcons.cat
                                          : (isDog
                                              ? FontAwesomeIcons.dog
                                              : FontAwesomeIcons.paw),
                                      size: 40,
                                      color: ColorManager.primaryColor,
                                    ),
                                  ),
                                ),
                          ))
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
