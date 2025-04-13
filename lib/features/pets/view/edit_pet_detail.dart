import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:squeak/core/constant/global_function/custom_text_form_field.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/constant/global_widget/toast.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/core/helper/remotely/end-points.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/pets/models/pet_model.dart';
import 'package:squeak/features/pets/controller/pet_cubit.dart';
import 'package:squeak/features/pets/view/pet_screen.dart';
import 'package:squeak/generated/l10n.dart';

class EditPet extends StatelessWidget {
  EditPet({
    required this.pets,
    required this.breedData,
  });

  final List<BreadData> breedData;
  final PetsData pets;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final species = pets.specieId;
    final dropdownValueSpecies = pets.specieId == 'f1131363-3b9f-40ee-9a89-0573ee274a10'
        ? isArabic() ? 'قطة' : 'Cat'
        : isArabic() ? 'كلب' : 'Dog';

    return BlocProvider(
      create: (context) => PetCubit()
        ..initEdit(pets)
        ..getAllBreeds(species)
        ..init(dropdownValueSpecies, species)
        ..getAllSpecies(),
      child: BlocConsumer<PetCubit, PetState>(
        listener: (context, state) {
          if (state is PetCreateSuccessState) {
            LayoutCubit.get(context).getOwnerPet();
            CacheHelper.removeData('usersPets');
            navigateAndFinish(context, const PetScreen());
          }
          if (state is PetCreateErrorState) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
                    _buildProfileImageSection(context, cubit),
                    const SizedBox(height: 24),
                    _buildGeneralInformationSection(context, cubit, isDark),
                    _buildBreedSpeciesSection(context, cubit, isDark),
                    _buildGenderSection(context, cubit),
                    _buildBirthdateSection(context, cubit, isDark),
                    _buildSaveButton(context, cubit),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImageSection(BuildContext context, PetCubit cubit) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorTheme.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: cubit.pitsImage == null
                  ? Image.network(
                (pets.imageName == null ||
                    pets.imageName == 'PetAvatar.png' ||
                    pets.imageName!.isEmpty)
                    ? AssetImageModel.defaultPetImage
                    : imageUrl + pets.imageName!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  pets.specieId == 'f1131363-3b9f-40ee-9a89-0573ee274a10'
                      ? 'assets/cat-with-gold.jpg'
                      : 'assets/dog.png',
                  fit: BoxFit.cover,
                ),
              )
                  : Image.file(cubit.pitsImage!, fit: BoxFit.cover),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ColorTheme.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              icon: Icon(Icons.edit, size: 18),
              color: Colors.white,
              onPressed: () => _showImageOptions(context, cubit),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInformationSection(BuildContext context, PetCubit cubit, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).generalInformation,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  cubit.spayed ? Icons.health_and_safety : Icons.pets,
                  color: ColorTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  cubit.spayed
                      ? S.of(context).spayed
                      : S.of(context).notSpayed,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: cubit.spayed,
                  activeColor: ColorTheme.primaryColor,
                  onChanged: (_) => cubit.changeSpayed(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          S.of(context).petName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        MyTextForm(
          controller: cubit.petNameController,
          prefixIcon: Icon(Icons.pets, size: 20),
          enable: false,
          hintText: S.of(context).enterPetName,
          validatorText: S.of(context).enterPetNameValidation,
          obscureText: false,
        ),
      ],
    );
  }

  Widget _buildBreedSpeciesSection(BuildContext context, PetCubit cubit, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).breed,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildDropDownBreed(cubit.breedData, context, cubit),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).species,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildDropDownSpecies(cubit.species, context, cubit),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderSection(BuildContext context, PetCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          S.of(context).gender,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                context,
                S.of(context).male,
                1,
                cubit,
                cubit.gender == 1,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderOption(
                context,
                S.of(context).female,
                2,
                cubit,
                cubit.gender == 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(
      BuildContext context,
      String title,
      int id,
      PetCubit cubit,
      bool isSelected,
      ) {
    return InkWell(
      onTap: () => cubit.changeGender(id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? ColorTheme.primaryColor
              : ColorTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? ColorTheme.primaryColor
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : ColorTheme.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBirthdateSection(BuildContext context, PetCubit cubit, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          S.of(context).birthdate,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, cubit),
          child: MyTextForm(
            controller: cubit.birthdateController,
            enabled: false,
            prefixIcon: Icon(Icons.calendar_today, size: 20),
            enable: false,
            hintText: S.of(context).birthdateValidation,
            validatorText: S.of(context).birthdateValidation,
            obscureText: false,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, PetCubit cubit) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorTheme.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () {
          if (cubit.formKey.currentState!.validate()) {
            if (cubit.pitsImage == null) {
              cubit.editPet();
            } else {
              cubit.isLoading = true;
              MainCubit.get(context)
                  .getGlobalImage(
                file: cubit.pitsImage!,
                uploadPlace: UploadPlace.petsImages.value,
              )
                  .then((value) {
                cubit.imageNameController.text =
                MainCubit.get(context).modelImage!.data as String;
                cubit.editPet();
              });
            }
          }
        },
        child: cubit.isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          S.of(context).save,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showImageOptions(BuildContext context, PetCubit cubit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).cardColor,
      builder: (context) => Padding(
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
            if (pets.imageName!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(S.of(context).deletePhoto),
                onTap: () {
                  Navigator.pop(context);
                  if (cubit.pitsImage == null) {
                    pets.imageName = '';
                    cubit.imageNameController.text = '';
                    cubit.emit(ChangeImageNameState());
                  } else {
                    cubit.pitsImage = null;
                    cubit.emit(ChangeImageNameState());
                  }
                },
              ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(S.of(context).changePhoto),
              onTap: () {
                Navigator.pop(context);
                cubit.getPitsImage();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, PetCubit cubit) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      cubit.changeBirthdate(pickedDate.toString().substring(0, 10));
    }
  }

  Widget buildDropDownSpecies(
      List<BreadData> speciesData,
      BuildContext context,
      PetCubit cubit,
      ) {
    List<BreadData> getSpeciesSuggestions(String query) {
      return speciesData
          .where((s) => s.enType.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return DropDownSearchFormField(
      textFieldConfiguration: TextFieldConfiguration(
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: cubit.dropdownValueSpecies.isEmpty
              ? 'Select species'
              : cubit.dropdownValueSpecies,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black26
              : Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
      ),
      suggestionsCallback: (pattern) {
        return getSpeciesSuggestions(pattern);
      },
      itemBuilder: (context, BreadData suggestion) {
        return ListTile(
          title: Text(
            suggestion.enType,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        );
      },
      onSuggestionSelected: (BreadData suggestion) {
        cubit.changeSpecies(suggestion.enType, suggestion.id);
        cubit.dropdownValueBreed = '';
        cubit.breedData.clear();
        cubit.breedIdController.clear();
        cubit.searchController.clear();
        cubit.getAllBreeds(suggestion.id);
      },
      suggestionsBoxController: SuggestionsBoxController(),
      displayAllSuggestionWhenTap: true,
    );
  }

  Widget buildDropDownBreed(
      List<BreadData> breedData,
      BuildContext context,
      PetCubit cubit,
      ) {
    List<BreadData> getSuggestions(String query) {
      return breedData
          .where((s) => s.enType.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return DropDownSearchFormField(
      textFieldConfiguration: TextFieldConfiguration(
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black26
              : Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: S.of(context).breed,
          filled: true,
        ),
        controller: cubit.searchController,
      ),
      suggestionsCallback: (pattern) {
        return getSuggestions(pattern);
      },
      itemBuilder: (context, BreadData suggestion) {
        return ListTile(
          title: Text(
            suggestion.enType,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        );
      },
      onSuggestionSelected: (BreadData suggestion) {
        cubit.searchController.text = suggestion.enType;
        cubit.changeBreed(suggestion.enType, suggestion.id);
      },
      suggestionsBoxController: SuggestionsBoxController(),
      displayAllSuggestionWhenTap: true,
    );
  }
}