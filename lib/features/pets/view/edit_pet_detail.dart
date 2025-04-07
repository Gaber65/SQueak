import 'dart:async';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import '../../../core/thames/color_manager.dart';
import '../../../generated/l10n.dart';

///
///
///         Cat
///         AddPet(
//                     dropdownValueSpecies: isArabic() ? 'قطة' : 'Cat',
//                     pathImage: 'assets/cat-with-gold.jpg',
//                     species: 'f1131363-3b9f-40ee-9a89-0573ee274a10',
//           ),
///
///         Dog
///         AddPet(
//                     dropdownValueSpecies: isArabic() ? 'كلب' : 'Dog',
//                     pathImage: 'assets/dog.png',
//                     species: 'bca48207-f05d-4e9f-a631-06f34eb5af39',
//                   ),
///
///
///
///

class EditPet extends StatelessWidget {
  EditPet({
    required this.pets,
    required this.breedData,
  });

  final List<BreadData> breedData;
  final PetsData pets;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late String dropdownValueSpecies;
  late String species;
  bool initTheBreedOfThePet = false;
  @override
  Widget build(BuildContext context) {
    species = pets.specieId;

    /// Mohamed Elkerm  i create only 2 case s cat and dog
    dropdownValueSpecies =
        pets.specieId == 'f1131363-3b9f-40ee-9a89-0573ee274a10'
            ? isArabic()
                ? 'قطة'
                : 'Cat'
            : isArabic()
                ? 'كلب'
                : 'Dog';

    print("12121212121212121212121212");

    ///Categroy Id
    print(pets.specieId);

    ///TODO : Mohamed Elkerm  why you provide blocProvider multi times ???

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
          var cubit = PetCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(isArabic() ? 'تعديل الاليف ' : 'Edit Pet'),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: cubit.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: cubit.pitsImage == null
                                  ? NetworkImage((pets.imageName == null ||
                                          pets.imageName == 'PetAvatar.png' ||
                                          pets.imageName!.isEmpty)
                                      ? AssetImageModel.defaultPetImage
                                      : imageUrl +
                                          pets.imageName) as ImageProvider
                                  : FileImage(cubit.pitsImage!),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 15,
                              ),
                              child: CircleAvatar(
                                radius: 15,
                                child: IconButton(
                                  icon: const Icon(Icons.settings),
                                  iconSize: 15,
                                  onPressed: () {
                                    scaffoldKey.currentState!.showBottomSheet(
                                      backgroundColor:
                                          Colors.white.withOpacity(0),
                                      elevation: 0,
                                      (context) {
                                        return ImageOption(
                                          context,
                                          pets,
                                          cubit,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(S.of(context).generalInformation),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            cubit.spayed
                                ? isArabic()
                                    ? 'معقم'
                                    : 'Spayed'
                                : isArabic()
                                    ? 'غير معقم'
                                    : 'Unspayed',
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
                            onChanged: (value) {
                              cubit.changeSpayed();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(S.of(context).petName),
                      const SizedBox(height: 8),
                      MyTextForm(
                        controller: cubit.petNameController,
                        prefixIcon: const Icon(
                          Icons.person,
                          size: 14,
                        ),
                        enable: false,
                        hintText: isArabic()
                            ? 'ادخل الاسم الحيوان'
                            : 'Enter pet name',
                        validatorText: isArabic()
                            ? " من فضلك ادخل الاسم الحيوان"
                            : "Please enter pet name",
                        obscureText: false,
                      ),
                      // if (pets.breed != null) const SizedBox(height: 20),
                      // if (pets.breed != null) Text(S.of(context).breed),
                      // if (pets.breed != null) const SizedBox(height: 8),
                      // if (pets.breed != null)
                      //   Container(
                      //     decoration: BoxDecoration(
                      //       color: MainCubit.get(context).isDark
                      //           ? Colors.black26
                      //           : Colors.grey.shade200,
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text(pets.breed!.enType),
                      //     ),
                      //   ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: buildDropDownBreed(
                              cubit.breedData,
                              context,
                              cubit,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width / 2.5) - 10,
                            child: buildDropDownSpecies(
                              cubit.species,
                              context,
                              cubit,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(S.of(context).gender),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: buildSelect(
                                  isArabic() ? "ذكر" : 'Male', 1, cubit)),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: buildSelect(
                                  isArabic() ? 'أنثى' : 'Female', 2, cubit)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(isArabic() ? 'تاريخ الميلاد' : 'date of birth'),
                      const SizedBox(height: 20),
                      buildSelectDate2(context, cubit),
                      const SizedBox(height: 30),
                      BlocConsumer<MainCubit, MainState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return CustomElevatedButton(
                            isLoading: cubit.isLoading,
                            formKey: cubit.formKey,
                            onPressed: () {
                              if (cubit.formKey.currentState!.validate()) {
                                if (cubit.pitsImage == null) {
                                  cubit.editPet();
                                  return;
                                } else {
                                  cubit.isLoading = true;
                                  MainCubit.get(context)
                                      .getGlobalImage(
                                    file: cubit.pitsImage!,
                                    uploadPlace: UploadPlace.petsImages.value,
                                  )
                                      .then((value) {
                                    cubit.imageNameController.text =
                                        MainCubit.get(context).modelImage!.data
                                            as String;
                                    cubit.editPet();
                                  });
                                }
                              }
                            },
                            buttonText: S.of(context).save,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSelectDate2(context, cubit) {
    return InkWell(
      onTap: () => selectDate(context, cubit),
      child: IgnorePointer(
        child: MyTextForm(
          controller: cubit.birthdateController,
          enabled: true,
          onTap: () => selectDate(context, cubit),
          prefixIcon: const Icon(
            Icons.calendar_month,
            size: 14,
          ),
          enable: false,
          hintText: isArabic() ? 'ادخل تاريخ الميلاد' : 'Enter date of birth',
          validatorText: isArabic()
              ? 'من فضلك ادخل تاريخ الميلاد'
              : 'Please enter date of birth',
          obscureText: false,
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context, PetCubit cubit) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      keyboardType: TextInputType.text,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      cubit.changeBirthdate(pickedDate.toString().substring(0, 10));
    }
  }

  Widget buildSelect(title, id, PetCubit cubit) {
    return GestureDetector(
      onTap: () {
        cubit.changeGender(id);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.none),
          color: cubit.gender == id
              ? ColorTheme.primaryColor
              : ColorTheme.primaryColor.withOpacity(.3),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'medium',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Material ImageOption(BuildContext context, PetsData model, PetCubit cubit) {
    return Material(
      elevation: 12,
      color: MainCubit.get(context).isDark
          ? Colors.grey.shade800
          : Colors.grey.shade200,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.minimize),
            const SizedBox(
              height: 12,
            ),
            if (model.imageName.isNotEmpty)
              MaterialButton(
                onPressed: () {
                  if (cubit.pitsImage == null) {
                    pets.imageName = '';
                    cubit.imageNameController.text = '';
                    cubit.emit(ChangeImageNameState());
                  } else {
                    cubit.pitsImage = null;
                    cubit.emit(ChangeImageNameState());
                  }
                  Navigator.of(scaffoldKey.currentContext!).pop();
                },
                child: Row(
                  children: [
                    Text(
                      isArabic() ? 'حذف الصورة' : 'Delete Photo',
                    ),
                    Spacer(),
                    Icon(Icons.delete),
                  ],
                ),
              ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                cubit.getPitsImage();
                Navigator.of(scaffoldKey.currentContext!).pop();
              },
              child: Row(
                children: [
                  Text(
                    isArabic() ? 'تغيير الصورة' : 'Change Photo',
                  ),
                  Spacer(),
                  Icon(Icons.camera),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  final suggestionBoxControllerSpecies = SuggestionsBoxController();

  /// TODO : Mohamed Elkerm the logic to make it public for shared now i have to copy the code and put it into edit screen
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: cubit.dropdownValueSpecies.isEmpty
              ? 'Select species'
              : cubit.dropdownValueSpecies,
          fillColor: MainCubit.get(context).isDark
              ? Colors.black26
              : Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          labelText: cubit.dropdownValueSpecies.isEmpty
              ? 'Select species'
              : cubit.dropdownValueSpecies,
          labelStyle: FontStyleThame.textStyle(
            context: context,
            fontColor: MainCubit.get(context).isDark
                ? ColorManager.sWhite
                : ColorManager.black_87,
            fontSize: 18,
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
              color:
                  MainCubit.get(context).isDark ? Colors.white : Colors.black,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          fillColor: MainCubit.get(context).isDark
              ? Colors.black26
              : Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          labelText: S.of(context).breed,
          labelStyle: FontStyleThame.textStyle(
            context: context,
            fontColor: MainCubit.get(context).isDark
                ? ColorManager.sWhite
                : ColorManager.black_87,
            fontSize: 18,
          ),
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
              color:
                  MainCubit.get(context).isDark ? Colors.white : Colors.black,
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
