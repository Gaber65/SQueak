import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../controller/pet_cubit.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key, required this.cubit}) : super(key: key);

  final PetCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () => _handleSave(context),
        child:
            cubit.isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  S.of(context).save,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  void _handleSave(BuildContext context) {
    if (cubit.formKey.currentState!.validate()) {
      if (cubit.petImage != null) {
        cubit.isLoading = true;
        MainCubit.get(
          context,
        ).getGlobalImage(cubit.petImage!, UploadPlace.petsImages).then((value) {
          cubit.imageNameController.text =
              MainCubit.get(context).modelImage!.data;
          cubit.createPet();
        });
      } else {
        if (cubit.searchController.text.isEmpty) {
          cubit.createPet();
        } else {
          if (cubit.breedData.any(
            (BreedEntity data) => data.enType == cubit.searchController.text,
          )) {
            cubit.createPet();
          } else {
            cubit.dropdownValueBreed = '';
            cubit.breedIdController.clear();
            cubit.searchController.clear();
            cubit.emit(ChangeBreedState());
            errorToast(
              context,
              isArabic()
                  ? "هذه السلاله غير موجوده"
                  : 'this breed doesn\'t exist',
            );
          }
        }
      }
    }
  }
}
