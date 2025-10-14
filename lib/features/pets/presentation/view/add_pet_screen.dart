import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/presentation/view/widgets/add_pet/pet_form_section.dart';
import 'package:squeak/features/pets/presentation/view/widgets/add_pet/pet_profile_image.dart';
import '../controller/pet_cubit.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({
    super.key,
    required this.dropdownValueSpecies,
    required this.pathImage,
    required this.species,
  });

  final String dropdownValueSpecies;
  final String species;
  final String pathImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<PetCubit>()
                ..init(dropdownValueSpecies, species)
                ..getAllSpecies()
                ..getBreedsBySpecies(species),
      child: BlocConsumer<PetCubit, PetState>(
        listener: (context, state) {
          if (state is PetCreateSuccessState) {
            navigateAndFinish(context, const LayoutScreen());
          }

          if (state is PetCreateErrorState) {
            errorToast(context, state.message);
          }
        },
        // ✅ Only rebuild when necessary states change
        buildWhen: (previous, current) {
          // Rebuild for loading, success, error states
          if (current is PetCreateLoadingState ||
              current is PetCreateSuccessState ||
              current is PetCreateErrorState) {
            return true;
          }
          // Rebuild for breeds/species data changes
          if (current is GetAllBreedsSuccessState ||
              current is GetAllSpeciesSuccessState ||
              current is PetFormState) {
            return true;
          }
          // Rebuild for image picker states
          if (current is PetImagePickedSuccessState ||
              current is PetImagePickedErrorState) {
            return true;
          }
          // Don't rebuild for other states (like form field changes)
          return false;
        },
        builder: (context, state) {
          final cubit = PetCubit.get(context);
          final isDark = MainCubit.get(context).isDark;
          final theme = Theme.of(context);

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                S.of(context).addPet,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Section
                    PetProfileImage(cubit: cubit, pathImage: pathImage),
                    const SizedBox(height: 24),

                    // Form Section
                    PetFormSection(cubit: cubit, isDark: isDark),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
