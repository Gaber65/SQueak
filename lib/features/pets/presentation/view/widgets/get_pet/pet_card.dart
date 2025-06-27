import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/presentation/view/supplier/get_supplier.dart';
import 'package:squeak/features/vaccination/presentation/pages/pet_vaccination_page.dart';

import '../../../../../qr/presentation/controller/qr_cubit.dart';
import '../../../../../qr/presentation/widgets/qr_action_buttons.dart';
import '../../../../../qr/presentation/widgets/qr_status_indicator.dart';
import '../../../../domain/entities/pet_entity.dart';
import '../../../controller/pet_cubit.dart';
import '../../edit_pet_screen.dart';
import 'action_button.dart';
import 'icon_circle.dart';

class PetCard extends StatefulWidget {
  final PetEntities pet;
  final PetCubit cubit;

  const PetCard({super.key, required this.pet, required this.cubit});

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Decorations.kDecorationBoxShadow(context: context),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToEditPet(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildPetHeader(context),
              const SizedBox(height: 12),

              // QR Status Indicator
              BlocProvider(
                create: (context) => sl<QrCubit>(),
                child: QrStatusIndicator(pet: widget.pet),
              ),

              const SizedBox(height: 12),

              BlocProvider(
                create: (context) => sl<QrCubit>(),
                child: QrActionButtons(pet: widget.pet, petCubit: widget.cubit),
              ),
              // QR Action Buttons
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
            widget.pet.imageName.toString().contains('PetAvatar') ||
                    widget.pet.imageName.toString().isEmpty
                ? 'https://img.freepik.com/free-vector/hand-drawn-animal-rescue-illustration_52683-109643.jpg?t=st=1724850971~exp=1724854571~hmac=310725afd1c40b0312d37d37e8cc8982f8cba5177dc34f988d94b9eccae6e977&w=826'
                : '$imageUrl${widget.pet.imageName}',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.pet.petName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.pet.birthdate.isEmpty
                    ? ''
                    : widget.pet.birthdate.substring(0, 10),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              if (widget.pet.breed != null) ...[
                const SizedBox(height: 2),
                Text(
                  isArabic()
                      ? widget.pet.breed!.arBreed
                      : widget.pet.breed!.enBreed,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildCalendarButton(context),
      ],
    );
  }

  Widget _buildCalendarButton(BuildContext context) {
    return IconCircle(
      icon: IconlyLight.calendar,
      onPressed:
          () => navigateToScreen(
            context,
            MySupplierScreen(petSelectFromIcon: widget.pet),
          ),
    );
  }


  void _navigateToEditPet(BuildContext context) {
    print('Pet ID: ${widget.pet.petId}');
    print('Pet Breed: ${widget.pet.breed}');
    navigateToScreen(
      context,
      EditPet(pets: widget.pet, breedData: widget.cubit.allBreeds),
    );
  }

}
