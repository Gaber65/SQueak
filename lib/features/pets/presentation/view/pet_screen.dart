import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/presentation/view/widgets/get_pet/pet_screen_content.dart';
import 'package:squeak/generated/l10n.dart';

import '../../domain/entities/pet_entity.dart';
import '../controller/pet_cubit.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<PetCubit>()
                ..getOwnerPets(),
      child: BlocConsumer<PetCubit, PetState>(
        listener: (context, state) {
          if (state is DeletePetSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).petDeletedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = PetCubit.get(context);
          return PetScreenContent(pets: cubit.pets, cubit: cubit,state: state,);
        },
      ),
    );
  }
}
