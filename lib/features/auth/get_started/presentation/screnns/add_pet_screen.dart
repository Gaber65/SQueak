import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/pets/presentation/view/widgets/add_pet/birthdate_picker.dart';
import 'package:squeak/features/pets/presentation/view/widgets/common/species_selector_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/add_pets_widgets/add_pet_additional_details.dart';
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
  String? selectedGender = "male";
  String? selectedSpeciesId;
  String? selectedBreedId;
  bool _isLoadingSpecies = false;

  @override
  void initState() {
    super.initState();
    _restoreData();
    // Try to restore cached species and breeds to avoid extra network calls
    // This mirrors behavior in `breed_species_section.dart` which prefers cached breeds.
    final cachedSpecies = CacheHelper.getData('pet_species');
    if (cachedSpecies != null && (cachedSpecies as String).isNotEmpty) {
      selectedSpecies = cachedSpecies;
    }
    // If species is dog or cat, try to load cached breeds immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<PetCubit>();
      final speciesId = selectedSpecies == 'dog'
          ? PetCubit.dogSpeciesId
          : selectedSpecies == 'cat'
              ? PetCubit.catSpeciesId
              : null;
      if (speciesId != null) {
        final cacheKey = 'breeds_$speciesId';
        final cached = CacheHelper.getData(cacheKey);
        if (cached != null && (cached as String).isNotEmpty) {
          try {
            final List<dynamic> decoded = jsonDecode(cached);
            final cachedBreeds = decoded
                .map<BreedEntity>((m) => BreedEntity(
                      enType: m['enType'] ?? '',
                      id: m['id'] ?? '',
                      specieId: m['specieId'] ?? '',
                    ))
                .toList();
            cubit.breedData = cachedBreeds;
          } catch (_) {
            // ignore parse errors and let normal flow load from network
          }
        }
      }
    });
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabicLang = isArabic();
    final titleColor = isDark ? Colors.white : ColorManager.black_87;
    final bodyBg =
        isDark
            ? ColorManager.editScreenTextFieldBaseColor.withValues(alpha: .5)
            : Colors.grey.shade50;
    final sectionTextColor = isDark ? Colors.white : ColorManager.black_87;
    final progressBg = isDark ? Colors.white24 : Colors.black12;
    final progressColor = ColorManager.primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isArabicLang ? "أضف صغيرك الأليف" : "Add Your Pet",
          style: TextStyle(color: titleColor),
        ),
        backgroundColor: isDark ? ColorManager.editScreenTextFieldBaseColor : ColorManager.white,
        leading: null,
      ),
      backgroundColor: bodyBg,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            LinearProgressIndicator(
              value: 0.75,
              minHeight: 2,
              backgroundColor: progressBg,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 20,
              backgroundColor: ColorManager.black_87,
              child: const Text(
                "3",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isArabicLang ? "أخبرنا عن صغيرك الأليف" : "Tell Us About Your Pet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: sectionTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                isArabicLang
                    ? "أضف بعض المعلومات الأساسية عن صديقك الأليف للبدء."
                    : "Add some basic information about your furry friend to get started.",
                textAlign: TextAlign.center,
                style: TextStyle(color: sectionTextColor, fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: isDark ? ColorManager.bTwitter : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AddPetImagePicker(
                imagefile: imagefile,
                onImagePicked: (File? file) {
                  setState(() {
                    imagefile = file;
                  });
                  if (file != null) {
                    if (!context.mounted) return;
                    MainCubit.get(
                      context,
                    ).getGlobalImage(file, UploadPlace.petsImages).then((value) {
                      if (!context.mounted) return;
                      context.read<PetCubit>().imageNameController.text =
                          MainCubit.get(context).modelImage!.data;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  AddPetSection(
                    icon: Icons.info,
                    title: isArabicLang ? "المعلومات الأساسية" : "Basic Information",
                    children: [
                      Text(
                        isArabicLang ? "اسم صغيرك الأليف *" : "Pet Name *",
                        style: TextStyle(color: sectionTextColor),
                      ),
                      const SizedBox(height: 8),
                      AddPetTextField(
                        hint: isArabicLang ? "أدخل اسم صغيرك الأليف" : "Enter your pet's name",
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isArabicLang ? "الفصيلة *" : "Species *",
                        style: TextStyle(color: sectionTextColor),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          AddPetChoice(
                            label: isArabicLang ? "كلب" : "Dog",
                            icon: FontAwesomeIcons.dog,
                            value: "dog",
                            isSelected: _isDogSpecies(selectedSpecies),
                            isLoading: _isLoadingSpecies,
                            onTap: () => _onSpeciesChanged("dog"),
                          ),
                          AddPetChoice(
                            label: isArabicLang ? "قطة" : "Cat",
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
                                    : (isArabicLang ? "آخر" : "Other"),
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
                      Text(
                        isArabicLang ? "السلالة" : "Breed",
                        style: TextStyle(color: sectionTextColor),
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
                    title: isArabicLang ? "تفاصيل إضافية" : "Additional Details",
                    children: [
                      Text(
                        isArabicLang ? " النوع*" : "Gender *",
                        style: TextStyle(color: sectionTextColor),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          AddPetAdditionalDetails(
                            label: isArabicLang ? "ذكر" : "Male",
                            icon: Icons.male,
                            value: "male",
                            isSelected: selectedGender == "male",
                            onTap:
                                () => setState(() => selectedGender = "male"),
                          ),
                          const SizedBox(width: 8),
                          AddPetAdditionalDetails(
                            label: isArabicLang ? "أنثى" : "Female",
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
                          return BirthdatePicker(
                            cubit: petCubit,
                            isDark: isDark,
                          );
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
                  navigateAndFinish(context, const LayoutScreen());
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
                            : Text(
                              isArabicLang ? "إضافة صغير أليف" : "Add Pet",
                              style: const TextStyle(
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
    final isArabicLang = isArabic();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isArabicLang ? "معلومات مفقودة" : "Missing Information"),
          content: Text(
            isArabicLang
                ? "يرجى إدخال اسم حيوانك الأليف."
                : "Please enter your pet's name.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isArabicLang ? "موافق" : "OK"),
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
    // Prefer cached breed list when available. If not, fall back to network.
    String? idToUse;
    if (species == 'dog') {
      idToUse = 'bca48207-f05d-4e9f-a631-06f34eb5af39';
    } else if (species == 'cat') {
      idToUse = 'f1131363-3b9f-40ee-9a89-0573ee274a10';
    } else if (speciesId != null) {
      idToUse = speciesId;
    }

    if (idToUse != null) {
      final cacheKey = 'breeds_$idToUse';
      final cached = CacheHelper.getData(cacheKey);
      if (cached != null && (cached as String).isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(cached);
          final cachedBreeds = decoded
              .map<BreedEntity>((m) => BreedEntity(
                    enType: m['enType'] ?? '',
                    id: m['id'] ?? '',
                    specieId: m['specieId'] ?? '',
                  ))
              .toList();
          cubit.breedData = cachedBreeds;
          // ensure UI shows no loading state
          return;
        } catch (_) {
          // fall through to network call
        }
      }
      cubit.getBreedsBySpecies(idToUse);
    }
  }
}