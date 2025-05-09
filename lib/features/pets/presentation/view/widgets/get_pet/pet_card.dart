import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/presentation/view/supplier/get_supplier.dart';
import 'package:squeak/features/service/view/pet_vaccination.dart';
import 'package:squeak/generated/l10n.dart';

import '../../../../domain/entities/pet_entity.dart';
import '../../../controller/pet_cubit.dart';

import '../../edit_pet_screen.dart';
import 'action_button.dart';
import 'icon_circle.dart';

class PetCard extends StatelessWidget {
  final PetEntity pet;
  final PetCubit cubit;

  const PetCard({super.key, required this.pet, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToEditPet(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildPetHeader(context),
              const SizedBox(height: 16),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            pet.imageName.toString().contains('PetAvatar') ||
                    pet.imageName.toString().isEmpty
                ? 'https://img.freepik.com/free-vector/hand-drawn-animal-rescue-illustration_52683-109643.jpg?t=st=1724850971~exp=1724854571~hmac=310725afd1c40b0312d37d37e8cc8982f8cba5177dc34f988d94b9eccae6e977&w=826'
                : '$imageUrl${pet.imageName}',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pet.petName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                pet.birthdate.isEmpty ? '' : pet.birthdate.substring(0, 10),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
        _buildCalendarButton(context),
      ],
    );
  }

  Widget _buildCalendarButton(BuildContext context) {
    return OfflineWidget(
      offlineChild: IconCircle(
        icon: IconlyLight.calendar,
        onPressed: () => OfflineWidget.showOfflineWidget(context),
      ),
      onlineChild: IconCircle(
        icon: IconlyLight.calendar,
        onPressed:
            () => navigateToScreen(
              context,
              MySupplierScreen(
                petId: pet.petId,
                isSpayed: pet.isSpayed,
                petNameFromAppoinmentIcon: pet.petName,
                genderForPetFromAppoinmentScreen: pet.gender,
              ),
            ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OfflineWidget(
            offlineChild: ActionButton(
              text: S.of(context).addPetService,
              color: Colors.green,
              onPressed: () => OfflineWidget.showOfflineWidget(context),
            ),
            onlineChild: ActionButton(
              text: isArabic() ? "تذكيرات" : "Reminders",
              color: Colors.green,
              onPressed:
                  () =>
                      navigateToScreen(context, PetVaccination(petModel: pet)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OfflineWidget(
            offlineChild: ActionButton(
              text: isArabic() ? 'حذف' : 'Delete',
              color: Colors.red,
              onPressed: () => OfflineWidget.showOfflineWidget(context),
            ),
            onlineChild: ActionButton(
              text: isArabic() ? 'حذف' : 'Delete',
              color: Colors.red,
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToEditPet(BuildContext context) {
    navigateToScreen(context, EditPet(pets: pet, breedData: cubit.allBreeds));
  }

  void _showDeleteConfirmation(BuildContext context) {
    showCustomConfirmationDialog(
      context: context,
      description:
          isArabic()
              ? Text.rich(
                TextSpan(
                  text: 'هل أنت متأكد أنك تريد حذف ',
                  children: [
                    TextSpan(
                      text: pet.petName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '?'),
                  ],
                ),
              )
              : Text.rich(
                TextSpan(
                  text: 'Are you sure you want to delete ',
                  children: [
                    TextSpan(
                      text: pet.petName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '?'),
                  ],
                ),
              ),
      imageUrl:
          'https://img.freepik.com/premium-vector/sad-dog_161669-74.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.2.131510781.1692744483&semt=ais',
      onConfirm: () async {

        print('pet id ${pet.petId.toString()}');
        print('pet id ${pet.toJson()}');
        await cubit.deletePet(pet.petId.toString());
        Navigator.of(context).pop(true);
      },
    );
  }
}
