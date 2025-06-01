import 'package:flutter/material.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/generated/l10n.dart';

import '../../../../controller/pet_cubit.dart';

void showImageOptions(BuildContext context, PetCubit cubit, PetEntities pets) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Theme.of(context).cardColor,
    builder:
        (context) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),
              if (pets.imageName.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(S.of(context).deletePhoto),
                  onTap: () {
                    Navigator.pop(context);
                    if (cubit.petImage == null) {
                      cubit.imageNameController.text = '';
                      cubit.emit(ChangeImageNameState());
                    } else {
                      cubit.imageNameController.text = '';
                      cubit.petImage = null;
                      cubit.emit(ChangeImageNameState());
                    }
                  },
                ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(S.of(context).changePhoto),
                onTap: () {
                  Navigator.pop(context);
                  cubit.getPetImage();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
  );
}
