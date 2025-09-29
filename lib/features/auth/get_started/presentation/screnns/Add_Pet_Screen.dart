// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import 'package:squeak/core/utils/enums/upload_place.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
import 'package:squeak/core/utils/theme/navigation_helper/navigation.dart';
import 'package:squeak/features/auth/get_started/presentation/screnns/find_friends.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/pets/presentation/controller/pet_cubit.dart';
import 'package:squeak/features/pets/presentation/view/widgets/add_pet/birthdate_picker.dart';
import 'package:squeak/features/pets/presentation/view/widgets/common/species_selector_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/add_pets_widgets/add_pet_additional_details.dart';
import '../widgets/add_pets_widgets/add_pet_app_bar.dart';
import '../widgets/add_pets_widgets/add_pet_breed_dropdown_modal.dart';
import '../widgets/add_pets_widgets/add_pet_choice.dart';
import '../widgets/add_pets_widgets/add_pet_image_picker.dart';
import '../widgets/add_pets_widgets/add_pet_section.dart';
import '../widgets/add_pets_widgets/add_pet_text_field.dart';

class GetStartedAddPetScreen extends StatefulWidget {
  const GetStartedAddPetScreen({super.key});

  @override
  State<GetStartedAddPetScreen> createState() => _GetStartedAddPetScreenState();
}

class _GetStartedAddPetScreenState extends State<GetStartedAddPetScreen> {
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  File? imagefile;
  String selectedSpecies = "dog";
  String? selectedGender;
  String? selectedSpeciesId;
  String? selectedBreedId;
  bool _isLoadingSpecies = false;

  @override
  void initState() {
    super.initState();
    _restoreData();
    _nameController.addListener(() {
      CacheHelper.saveData('pet_name', _nameController.text);
    });
    _breedController.addListener(() {
      CacheHelper.saveData('pet_breed', _breedController.text);
    });
    _dateController.addListener(() {
      CacheHelper.saveData('pet_date', _dateController.text);
    });
  }

  Future<void> _restoreData() async {
    _nameController.text = CacheHelper.getData('pet_name') ?? '';
    _dateController.text = CacheHelper.getData('pet_date') ?? '';
    final imgBase64 = CacheHelper.getData('pet_image');
    if (imgBase64 != null) {
      try {
        final bytes = base64Decode(imgBase64);
        final tempDir = Directory.systemTemp;
        final tempFile = await File(
          '${tempDir.path}/pet_image.png',
        ).writeAsBytes(bytes);
        setState(() => imagefile = tempFile);
      } catch (e) {
        debugPrint("Error restoring image: $e");
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petCubit = context.read<PetCubit>();
    return Scaffold(
      appBar: AddPetAppBar(),
      backgroundColor: ColorManager.editScreenTextFieldBaseColor.withValues(
        alpha: .5,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            LinearProgressIndicator(
              value: 0.75,
              minHeight: 2,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 16,
              backgroundColor: ColorManager.primaryColor,
              child: const Text(
                "3",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Tell Us About Your Pet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Add some basic information about your furry friend to get started.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            AddPetImagePicker(
              imagefile: imagefile,
              onImagePicked: (File? file) {
                setState(() {
                  imagefile = file;
                });
                if (file != null) {
                  MainCubit.get(
                    context,
                  ).getGlobalImage(file, UploadPlace.petsImages).then((value) {
                    context.read<PetCubit>().imageNameController.text =
                        MainCubit.get(context).modelImage!.data;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  AddPetSection(
                    icon: Icons.info,
                    title: "Basic Information",
                    children: [
                      const Text(
                        "Pet Name *",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      AddPetTextField(
                        hint: "Enter your pet's name",
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Species *",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          AddPetChoice(
                            label: "Dog",
                            icon: FontAwesomeIcons.dog,
                            value: "dog",
                            isSelected: _isDogSpecies(selectedSpecies),
                            isLoading: _isLoadingSpecies,
                            onTap: () => _onSpeciesChanged("dog"),
                          ),
                          AddPetChoice(
                            label: "Cat",
                            icon: FontAwesomeIcons.cat,
                            value: "cat",
                            isSelected: _isCatSpecies(selectedSpecies),
                            isLoading: _isLoadingSpecies,
                            onTap: () => _onSpeciesChanged("cat"),
                          ),
                          AddPetChoice(
                            label:
                                selectedSpecies != "dog" &&
                                        selectedSpecies != "cat"
                                    ? selectedSpecies
                                    : "Other",
                            icon: Icons.more_horiz,
                            value: "other",
                            isSelected:
                                !_isDogSpecies(selectedSpecies) &&
                                !_isCatSpecies(selectedSpecies),
                            isLoading: _isLoadingSpecies,
                            onTap: () async {
                              if (_isLoadingSpecies) return;
                              setState(() => _isLoadingSpecies = true);
                              try {
                                await showSpeciesSelector(
                                  context,
                                  context.read<PetCubit>(),
                                  onSelected: (species) {
                                    setState(() {
                                      selectedSpecies = species.type;
                                      selectedSpeciesId = species.id;
                                      // reset breed when species changes
                                      selectedBreedId = null;
                                      _breedController.clear();
                                    });
                                    CacheHelper.saveData(
                                      "pet_species",
                                      species.type,
                                    );
                                    _onSpeciesChanged(
                                      species.type,
                                      speciesId: species.id,
                                    );
                                  },
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isLoadingSpecies = false);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Breed",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      BlocBuilder<PetCubit, PetState>(
                        builder: (context, state) {
                          final cubit = context.read<PetCubit>();
                          if (state is GetAllBreedsLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          if (state is GetAllBreedsErrorState) {
                            return Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            );
                          }
                          return AddPetBreedDropdownModal(
                            breeds: cubit.breedData,
                            controller: _breedController,
                            onBreedSelected: (
                              String breedId,
                              String breedName,
                            ) {
                              setState(() {
                                selectedBreedId = breedId;
                                _breedController.text = breedName;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AddPetSection(
                    icon: Icons.favorite,
                    title: "Additional Details",
                    children: [
                      const Text(
                        "Gender *",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          AddPetAdditionalDetails(
                            label: "Male",
                            icon: Icons.male,
                            value: "male",
                            isSelected: selectedGender == "male",
                            onTap:
                                () => setState(() => selectedGender = "male"),
                          ),
                          const SizedBox(width: 8),
                          AddPetAdditionalDetails(
                            label: "Female",
                            icon: Icons.female,
                            value: "female",
                            isSelected: selectedGender == "female",
                            onTap:
                                () => setState(() => selectedGender = "female"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<PetCubit, PetState>(
                        builder: (context, state) {
                          return BirthdatePicker(cubit: petCubit, isDark: true);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BlocConsumer<PetCubit, PetState>(
              listener: (context, state) {
                if (state is PetCreateSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pet created successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  final petCubit = context.read<PetCubit>();
                  final newPet = petCubit.pets.last;
                  navigateAndFinish(
                    context,
                    SuggestionFriendsScreen(
                      petId: newPet.petId ?? '',
                      specieId: newPet.specieId ?? '',
                    ),
                  );
                } else if (state is PetCreateErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is PetCreateLoadingState;
                return Container(
                  margin: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              if (_nameController.text.trim().isEmpty) {
                                _showValidationDialog();
                                return;
                              }
                              final pet = PetEntities(
                                imageName:
                                    context
                                            .read<PetCubit>()
                                            .imageNameController
                                            .text
                                            .isNotEmpty
                                        ? context
                                            .read<PetCubit>()
                                            .imageNameController
                                            .text
                                        : null,
                                breedId: selectedBreedId,
                                gender:
                                    selectedGender == "male"
                                        ? 1
                                        : selectedGender == "female"
                                        ? 2
                                        : null,
                                birthdate:
                                    _dateController.text.isNotEmpty
                                        ? DateTime.parse(
                                          "${_dateController.text.split('/')[2]}-"
                                          "${_dateController.text.split('/')[0].padLeft(2, '0')}-"
                                          "${_dateController.text.split('/')[1].padLeft(2, '0')}"
                                          "T00:00:00.000Z",
                                        ).toIso8601String()
                                        : null,
                                isSpayed: false,
                                petName: _nameController.text.trim(),
                                specieId:
                                    selectedSpecies == "dog"
                                        ? "bca48207-f05d-4e9f-a631-06f34eb5af39"
                                        : selectedSpecies == "cat"
                                        ? "f1131363-3b9f-40ee-9a89-0573ee274a10"
                                        : selectedSpeciesId,
                              );
                              context.read<PetCubit>().createPetGetStarting(
                                pet: pet,
                              );
                            },
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              "Add Pet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Missing Information"),
          content: const Text("Please enter your pet's name."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  bool _isDogSpecies(String species) {
    return species.toLowerCase() == 'dog' ||
        species.toLowerCase() == 'dogs' ||
        species.toLowerCase().contains('canine');
  }

  bool _isCatSpecies(String species) {
    return species.toLowerCase() == 'cat' ||
        species.toLowerCase() == 'cats' ||
        species.toLowerCase() == 'coww' ||
        species.toLowerCase().contains('feline');
  }

  void _onSpeciesChanged(String species, {String? speciesId}) {
    setState(() => selectedSpecies = species);
    final cubit = context.read<PetCubit>();
    if (species == 'dog') {
      cubit.getBreedsBySpecies('bca48207-f05d-4e9f-a631-06f34eb5af39');
    } else if (species == 'cat') {
      cubit.getBreedsBySpecies('f1131363-3b9f-40ee-9a89-0573ee274a10');
    } else if (speciesId != null) {
      cubit.getBreedsBySpecies(speciesId);
    }
  }
}
