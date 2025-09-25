// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import 'package:squeak/core/utils/enums/upload_place.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
import 'package:squeak/core/utils/theme/navigation_helper/navigation.dart';
import 'package:squeak/features/auth/get_started/presentation/view/screnns/find_friends.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/pets/presentation/controller/pet_cubit.dart';

import '../../../../../pets/presentation/view/widgets/add_pet/birthdate_picker.dart';

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
  String? base64String;
  String selectedSpecies = "dog";
  String? selectedGender;
  String? selectedSpeciesId;
  String? selectedBreedId;

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
    // _breedController.text = CacheHelper.getData('pet_breed') ?? '';
    _dateController.text = CacheHelper.getData('pet_date') ?? '';
    // selectedGender = CacheHelper.getData('pet_gender');
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
      appBar: _buildAppBar(context),
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

            _buildImagePicker(),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildSection(
                    icon: Icons.info,
                    title: "Basic Information",
                    children: [
                      const Text(
                        "Pet Name *",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        "Enter your pet's name",
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "Species *",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Row(
                            children: [
                              _buildChoice(
                                label: "Dog",
                                icon: FontAwesomeIcons.dog,
                                value: "dog",
                              ),
                              _buildChoice(
                                label: "Cat",
                                icon: FontAwesomeIcons.cat,
                                value: "cat",
                              ),
                              _buildChoice(
                                label: "Other",
                                icon: Icons.more_horiz,
                                value: "other",
                              ),
                            ],
                          ),

                          if (selectedSpecies == "other")
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: BlocBuilder<PetCubit, PetState>(
                                builder: (context, state) {
                                  final cubit = context.read<PetCubit>();
                                  return DropdownButton<SpeciesEntity>(
                                    isExpanded: true,
                                    value: cubit.species.firstWhere(
                                      (s) => s.type == selectedSpecies,
                                      orElse: () => cubit.species.first,
                                    ),
                                    items:
                                        cubit.species
                                            .map(
                                              (species) => DropdownMenuItem(
                                                value: species,
                                                child: Text(species.type),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedSpecies = value.type;
                                          selectedSpeciesId = value.id;
                                        });
                                        CacheHelper.saveData(
                                          "pet_species",
                                          value.type,
                                        );
                                        _onSpeciesChanged(
                                          value.type,
                                          speciesId: value.id,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
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
                          return _buildBreedDropdownModal(cubit.breedData);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
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
                          _additionDetails(
                            label: "Male",
                            icon: Icons.male,
                            value: "male",
                          ),
                          const SizedBox(width: 8),
                          _additionDetails(
                            label: "Female",
                            icon: Icons.female,
                            value: "female",
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
                  navigateToScreen(context, FindFriendsScreen());
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Add Your Pet", style: TextStyle(color: Colors.white)),
      backgroundColor: ColorManager.editScreenTextFieldBaseColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child:
                  imagefile != null
                      ? Image.file(
                        imagefile!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                      : const CircleAvatar(
                        radius: 48,
                        backgroundColor: ColorManager.white,
                        child: Icon(
                          Icons.pets,
                          color: ColorManager.primaryColor,
                          size: 42,
                        ),
                      ),
            ),
          ),
          Positioned(
            bottom: -8,
            right: -12,
            child: InkWell(
              onTap: () => _showImagePickerDialog(),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: ColorManager.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManager.primaryColor.withOpacity(.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ColorManager.primaryColor, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    Key? key,
    TextEditingController? controller,
    bool readOnly = false,
    Widget? suffix,
    void Function()? onTap,
  }) {
    return TextField(
      key: key,
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: ColorManager.followersShadowLightColor,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: ColorManager.primaryColor.withOpacity(.7),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildChoice({
    required String label,
    required IconData icon,
    required String value,
  }) {
    String displayLabel = value;
    if (value == "other" &&
        selectedSpecies != "dog" &&
        selectedSpecies != "cat") {
      displayLabel = selectedSpecies;
    }

    final isSelected =
        selectedSpecies == value ||
        (value == "other" &&
            selectedSpecies != "dog" &&
            selectedSpecies != "cat");

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (value == "other") {
            // Force show the dropdown when "Other" is clicked
            if (selectedSpecies == "dog" || selectedSpecies == "cat") {
              setState(() {
                selectedSpecies = "other";
              });
            }
            // The dropdown will be shown because of the condition in the parent widget
          } else {
            _onSpeciesChanged(value);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primaryColor : Colors.white10,
            border: Border.all(
              color: ColorManager.primaryColor.withOpacity(.7),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 4),
              Text(displayLabel, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _additionDetails({
    required String label,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selectedGender == value;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedGender = value);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.025,
            horizontal: screenWidth * 0.05,
          ),
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primaryColor : Colors.white10,
            border: Border.all(
              color: ColorManager.primaryColor.withOpacity(.7),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02), // scaled padding
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: ColorManager.editScreenBaseFontColor,
                ),
                child: Icon(
                  icon,
                  color: Colors.blueAccent,
                  size: screenWidth * 0.06, // responsive icon size
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04, // responsive font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Please Choose An Option',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  pickedImageWithCamera();
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Camera'),
                      SizedBox(width: 8),
                      Icon(Icons.camera, color: Colors.amber),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  pickedImageWithGallery();
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Gallery'),
                      SizedBox(width: 8),
                      Icon(Icons.browse_gallery, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void pickedImageWithCamera() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        setState(() {
          imagefile = File(pickedFile.path);
        });

        MainCubit.get(
          context,
        ).getGlobalImage(imagefile!, UploadPlace.petsImages).then((value) {
          context.read<PetCubit>().imageNameController.text =
              MainCubit.get(context).modelImage!.data;

          // print(context.read<PetCubit>().imageNameController.text);
        });

        // print("Image File: $imagefile");
        // print("Image Path: ${imagefile!.path}");
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void pickedImageWithGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        setState(() {
          imagefile = File(pickedFile.path);
        });

        MainCubit.get(
          context,
        ).getGlobalImage(imagefile!, UploadPlace.petsImages).then((value) {
          context.read<PetCubit>().imageNameController.text =
              MainCubit.get(context).modelImage!.data;

          // print(context.read<PetCubit>().imageNameController.text);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Widget _buildBreedDropdownModal(List<BreedEntity> breeds) {
    return GestureDetector(
      onTap: () => _openBreedPickerModal(context, breeds),
      child: AbsorbPointer(
        child: TextField(
          controller: _breedController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            fillColor: ColorManager.followersShadowLightColor,
            filled: true,
            hintText: "Select breed (optional)",
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: ColorManager.primaryColor.withOpacity(.7),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openBreedPickerModal(
    BuildContext context,
    List<BreedEntity> breeds,
  ) async {
    String filter = '';
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            List<BreedEntity> filtered = breeds;
            return StatefulBuilder(
              builder: (context, setModalState) {
                filtered =
                    breeds
                        .where(
                          (b) => (b.enType).toLowerCase().contains(
                            filter.toLowerCase(),
                          ),
                        )
                        .toList();
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search breed...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (v) => setModalState(() => filter = v),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child:
                            filtered.isEmpty
                                ? const Center(child: Text('No breeds found'))
                                : ListView.separated(
                                  controller: scrollController,
                                  itemCount: filtered.length,
                                  separatorBuilder:
                                      (_, __) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final b = filtered[index];
                                    return ListTile(
                                      title: Text(b.enType),
                                      onTap: () {
                                        _breedController.text = b.enType;
                                        selectedBreedId = b.id;
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
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
