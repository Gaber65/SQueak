import 'dart:async';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/constant/global_function/custom_text_form_field.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/constant/global_widget/toast.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/pets/models/pet_model.dart';
import 'package:squeak/features/pets/controller/pet_cubit.dart';
import 'package:squeak/features/pets/view/pet_screen.dart';
import '../../../core/thames/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../layout/controller/layout_cubit.dart';

class AddPet extends StatelessWidget {
  AddPet({
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
      create: (context) => PetCubit()
        ..getAllBreeds(species)
        ..init(dropdownValueSpecies, species)
        ..getAllSpecies(),
      child: BlocConsumer<PetCubit, PetState>(
        listener: (context, state) {
          if (state is PetCreateSuccessState) {
            LayoutCubit.get(context).getOwnerPet();
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
                    _buildProfileImageSection(context, cubit),
                    const SizedBox(height: 24),

                    // General Information Section
                    _buildGeneralInformationSection(context, cubit, isDark, theme),

                    // Save Button
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
                  ? Image.asset(
                pathImage,
                fit: BoxFit.cover,
              )
                  : Image.file(
                cubit.pitsImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorTheme.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, size: 20),
              color: Colors.white,
              onPressed: cubit.getPitsImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInformationSection(
      BuildContext context,
      PetCubit cubit,
      bool isDark,
      ThemeData theme,
      ) {
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Spayed/Unspayed Toggle
          _buildSpayedToggle(context, cubit),
          const SizedBox(height: 20),

          // Pet Name Field
          _buildPetNameField(context, cubit, isDark),
          const SizedBox(height: 20),

          // Breed and Species Dropdowns
          _buildBreedAndSpeciesRow(context, cubit, isDark),
          const SizedBox(height: 20),

          // Gender Selection
          _buildGenderSelection(context, cubit),
          const SizedBox(height: 20),

          // Birthdate Picker
          _buildBirthdatePicker(context, cubit, isDark),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSpayedToggle(BuildContext context, PetCubit cubit) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
        ),
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
                  : S.of(context).notSpayed ,
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Switch(
              value: cubit.spayed,
              activeColor: ColorTheme.primaryColor,
              onChanged: (value) => cubit.changeSpayed(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetNameField(BuildContext context, PetCubit cubit, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).petName,
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        MyTextForm(
          controller: cubit.petNameController,
          prefixIcon: Icon(
            Icons.pets,
            size: 20,
            color: isDark ? ColorManager.sWhite : ColorManager.black_87,
          ),
          enable: false,
          hintText: isArabic()
              ? 'ادخل الاسم الحيوان'
              : 'Enter pet name',
          validatorText: isArabic()
              ? "من فضلك ادخل الاسم الحيوان"
              : "Please enter pet name",
          obscureText: false,
        ),
      ],
    );
  }

  Widget _buildBreedAndSpeciesRow(
      BuildContext context,
      PetCubit cubit,
      bool isDark,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).breed,
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

  Widget _buildGenderSelection(BuildContext context, PetCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).gender,
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                context,
                isArabic() ? "ذكر" : 'Male',
                1,
                cubit,
                cubit.gender == 1,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderOption(
                context,
                isArabic() ? 'أنثى' : 'Female',
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

  Widget _buildBirthdatePicker(
      BuildContext context,
      PetCubit cubit,
      bool isDark,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic() ? 'تاريخ الميلاد' : 'Date of birth',
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => selectDate(context, cubit),
          child: MyTextForm(
            controller: cubit.birthdateController,
            enabled: false,
            prefixIcon: Icon(
              Icons.calendar_today,
              size: 20,
              color: isDark ? ColorManager.sWhite : ColorManager.black_87,
            ),
            enable: false,
            hintText: isArabic()
                ? 'من فضلك ادخل تاريخ الميلاد'
                : 'Please enter date of birth',
            validatorText: isArabic()
                ? 'من فضلك ادخل تاريخ الميلاد'
                : 'Please enter date of birth',
            obscureText: false,
          ),
        ),
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
            if (cubit.pitsImage != null) {
              cubit.isLoading = true;
              MainCubit.get(context)
                  .getGlobalImage(
                file: cubit.pitsImage!,
                uploadPlace: UploadPlace.petsImages.value,
              )
                  .then((value) {
                cubit.imageNameController.text =
                MainCubit.get(context).modelImage!.data as String;
                cubit.createPet();
              });
            } else {
              if (cubit.searchController.text.isEmpty) {
                cubit.createPet();
              } else {
                if (cubit.breedData.any((BreadData data) =>
                data.enType == cubit.searchController.text)) {
                  cubit.createPet();
                } else {
                  cubit.dropdownValueBreed = '';
                  cubit.breedIdController.clear();
                  cubit.searchController.clear();
                  cubit.emit(ChangeBreedState());
                  errorToast(
                      context,
                      isArabic()
                          ? "هذه السلاله غير موجوده"
                          : 'this breed doesn\'t exist');
                }
              }
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

  // Keep the existing utility methods (selectDate, buildDropDownSpecies, buildDropDownBreed)
  // They can remain the same as in your original code
  Future<void> selectDate(BuildContext context, PetCubit cubit) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      cubit.changeBirthdate(pickedDate.toString().substring(0, 10));
    }
  }

  final suggestionBoxControllerSpecies = SuggestionsBoxController();

  Widget buildDropDownSpecies(
      List<BreadData> speciesData,
      context,
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
          color: MainCubit.get(context).isDark
              ? ColorManager.sWhite
              : ColorManager.black_87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: cubit.dropdownValueSpecies.isEmpty
              ? 'Select species'
              : cubit.dropdownValueSpecies,
          fillColor: MainCubit.get(context).isDark
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
              color: MainCubit.get(context).isDark ? Colors.white : Colors.black,
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
      suggestionsBoxController: suggestionBoxControllerSpecies,
      displayAllSuggestionWhenTap: true,
    );
  }

  final suggestionBoxController = SuggestionsBoxController();

  Widget buildDropDownBreed(
      List<BreadData> breedData,
      context,
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
          color: MainCubit.get(context).isDark
              ? ColorManager.sWhite
              : ColorManager.black_87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          fillColor: MainCubit.get(context).isDark
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
              color: MainCubit.get(context).isDark ? Colors.white : Colors.black,
            ),
          ),
        );
      },
      onSuggestionSelected: (BreadData suggestion) {
        cubit.searchController.text = suggestion.enType;
        cubit.changeBreed(suggestion.enType, suggestion.id);
      },
      suggestionsBoxController: suggestionBoxController,
      displayAllSuggestionWhenTap: true,
    );
  }




}