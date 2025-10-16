// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.cubit});

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
      cubit.isLoading = true;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      cubit.emit(ChangeBreedState());

      // Handle both pet image and passport image uploads
      _handleImageUploads(context);
    }
  }

  void _handleImageUploads(BuildContext context) {
    List<Future> uploadTasks = [];

    // Upload pet image if exists
    if (cubit.petImage != null) {
      uploadTasks.add(
        MainCubit.get(
          context,
        ).getGlobalImage(cubit.petImage!, UploadPlace.petsImages).then((value) {
          cubit.imageNameController.text =
              // ignore: use_build_context_synchronously
              MainCubit.get(context).modelImage!.data;
        }),
      );
    }

    // Upload passport image if exists
    if (cubit.passportImage != null) {
      uploadTasks.add(
        MainCubit.get(context)
            .getGlobalImage(cubit.passportImage!, UploadPlace.petsImages)
            .then((value) {
              cubit.passportImageNameController.text =
                  // ignore: use_build_context_synchronously
                  MainCubit.get(context).modelImage!.data;
            }),
      );
    }

    if (uploadTasks.isNotEmpty) {
      // Wait for all image uploads to complete
      Future.wait(uploadTasks)
          .then((_) {
            cubit.updatePet();
          })
          .catchError((error) {
            cubit.isLoading = false;
            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
            cubit.emit(PetCreateErrorState(error.toString()));
            errorToast(
              // ignore: use_build_context_synchronously
              context,
              isArabic() ? "فشل في رفع الصور" : "Failed to upload images",
            );
          });
    } else {
      // No images to upload, proceed directly
      cubit.updatePet();
    }
  }
}
