import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/pets/presentation/view/widgets/add_pet/passport_section.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';

// Import widget sections
import '../../../../core/utils/enums/profile_type.dart';
import '../../../profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import '../../../profile_switch/domain/entities/profile_type_entity.dart';
import '../../data/models/pet_model.dart';
import '../controller/pet_cubit.dart';
import 'widgets/add_pet/birthdate_picker.dart';
import 'widgets/add_pet/breed_species_section.dart';
import 'widgets/add_pet/pet_name_field.dart';
import 'widgets/edit_pet/profile_image_section.dart';
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SwitchProfileCubit>()..loadProfile()),

        BlocProvider(
          create:
              (context) =>
                  sl<PetCubit>()
                    ..initEdit(pets)
                    ..init(dropdownValueSpecies, species ?? '')
                    ..getAllSpecies()
                    ..getBreedsBySpecies(species ?? ''),
        ),
      ],
      child: BlocConsumer<SwitchProfileCubit, SwitchProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return BlocConsumer<PetCubit, PetState>(
            listener: (context, state) {
              if (state is PetCreateSuccessState) {
                final switchCubit = SwitchProfileCubit.get(context);
                final petCubit = PetCubit.get(context);

                final activePet = switchCubit.activeProfile?.pet;
                final editedPet = petCubit.petEdit;
                final isSamePet =
                    activePet != null &&
                    editedPet != null &&
                    activePet.petId == editedPet.petId;

                var pet = PetData(
                  petId: editedPet!.petId,
                  petName: editedPet.petName,
                  specieId: editedPet.specieId,
                  breedId: editedPet.breedId,
                  gender: editedPet.gender,
                  birthdate: editedPet.birthdate,
                  isSpayed: editedPet.isSpayed,
                  passportNumber: editedPet.passportNumber,
                  passportImage: editedPet.passportImage,
                  imageName: editedPet.imageName,
                  breed: editedPet.breed,
                  microShipNumber: editedPet.microShipNumber,
                  isSelected: editedPet.isSelected,
                  mutualFriends: editedPet.mutualFriends,
                  qrCode: editedPet.qrCode,
                  qrCodeId: editedPet.qrCodeId,
                );

                if (isSamePet) {
                  switchCubit.switchProfile(
                    ActiveProfile(type: ProfileType.pet, pet: pet),
                  );
                }

                navigateAndFinish(context, const LayoutScreen());
              }
              if (state is PetCreateErrorState) {
                errorToast(context, state.message);
              }
            },
            buildWhen: (previous, current) {
              // Rebuild for loading, success, error states
              if (current is PetCreateLoadingState ||
                  current is PetCreateSuccessState ||
                  current is PetCreateErrorState) {
                return true;
              }
              // Rebuild for data loading states
              if (current is GetAllSpeciesSuccessState ||
                  current is GetAllBreedsSuccessState ||
                  current is PetFormState) {
                return true;
              }
              // Rebuild for image picker states
              if (current is PetImagePickedSuccessState ||
                  current is PetImagePickedErrorState) {
                return true;
              }
              // Don't rebuild for individual form field changes
              return false;
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
                        // Profile Image Section
                        ProfileImageSection(cubit: cubit, pets: pets),
                        SizedBox(height: responsiveHeight(20, context)),
                        SpayedToggle(cubit: cubit),
                        SizedBox(height: responsiveHeight(20, context)),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.error, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      'Basic Information',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color:
                                            isDark
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: responsiveHeight(20, context)),
                                PetNameField(cubit: cubit, isDark: isDark),
                                SizedBox(height: responsiveHeight(20, context)),
                                BreedSpeciesSection(
                                  cubit: cubit,
                                  isDark: isDark,
                                ),
                                SizedBox(height: responsiveHeight(20, context)),
                                GenderSelection(cubit: cubit),
                                SizedBox(height: responsiveHeight(20, context)),
                                BirthdatePicker(cubit: cubit, isDark: isDark),
                                SizedBox(height: responsiveHeight(20, context)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: responsiveHeight(30, context)),
                        PassportSection(cubit: cubit, isDark: isDark),
                        SizedBox(height: responsiveHeight(30, context)),
                        SaveButton(cubit: cubit),
                        SizedBox(height: responsiveHeight(30, context)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

double responsiveHeight(double height, BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return (height / 800) * screenHeight; // 800 is the design reference height
}

/// Calculates a responsive width based on the screen size
double responsiveWidth(double width, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return (width / 360) * screenWidth; // 360 is the design reference width
}
