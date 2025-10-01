import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
import 'package:squeak/features/pets/presentation/view/widgets/add_pet/passport_section.dart';
import 'package:squeak/features/pets/presentation/view/widgets/add_pet/pet_form_section.dart';
import 'package:squeak/features/pets/presentation/view/widgets/edit_pet/birthdate_section.dart';
import 'package:squeak/features/pets/presentation/view/widgets/edit_pet/breed_species_section.dart';
import 'package:squeak/features/pets/presentation/view/widgets/edit_pet/gender_section.dart';
import 'package:squeak/features/pets/presentation/view/widgets/edit_pet/general_information_section.dart';
import 'package:squeak/features/pets/presentation/view/widgets/edit_pet/profile_image_section.dart';

// Import widget sections
import '../controller/pet_cubit.dart';
import 'widgets/edit_pet/save_button.dart' show SaveButton;

class EditPet extends StatelessWidget {
  EditPet({super.key, required this.pets, required this.breedData});

  final List<BreedEntity> breedData;
  final PetEntities pets;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final species = pets.specieId;
    final dropdownValueSpecies =
        pets.specieId == 'f1131363-3b9f-40ee-9a89-0573ee274a10'
            ? isArabic()
                ? 'قطة'
                : 'Cat'
            : isArabic()
            ? 'كلب'
            : 'Dog';

    return BlocProvider(
      create:
          (context) =>
              sl<PetCubit>()
                ..initEdit(pets)
                ..init(dropdownValueSpecies, species ?? '')
                ..getAllSpecies(),
      child: BlocConsumer<PetCubit, PetState>(
        listener: (context, state) {
          if (state is PetCreateSuccessState) {
            navigateAndFinish(context, const LayoutScreen());
          }
          if (state is PetCreateErrorState) {
            errorToast(context, state.message);
          }
        },
        builder: (context, state) {
          final cubit = PetCubit.get(context);
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                S.of(context).editPet,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileImageSection(pets: pets, cubit: cubit),
                    const SizedBox(height: 24),

                    GeneralInformationSection(cubit: cubit, isDark: isDark),
                    SizedBox(height: responsiveHeight(30, context)),

                    BreedSpeciesSection(cubit: cubit, isDark: isDark),
                    GenderSection(cubit: cubit),
                    BirthdateSection(cubit: cubit, isDark: isDark),

                    PassportSection(cubit: cubit, isDark: isDark),
                    SizedBox(height: responsiveHeight(30, context)),
                    SaveButton(cubit: cubit),
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
