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
    ///TODO : Mohamed Elkerm  why you provide blocProvider multi times ???

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
          var cubit = PetCubit.get(context);
          print("Add Pet Screen and this is the data : ");
          print('breedData.length');
          print(cubit.breedData.length);
          print(cubit.breedData);
          print("================================================");
          print('species.length');
          print(cubit.species.length);
          print(cubit.species);
          print("================================================");
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(S.of(context).addPet),
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
                                  ? AssetImage(pathImage) as ImageProvider
                                  : FileImage(cubit.pitsImage!),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 15,
                              ),
                              child: CircleAvatar(
                                radius: 15,
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt_outlined),
                                  iconSize: 15,
                                  onPressed: () {
                                    cubit.getPitsImage();
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
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: buildDropDownBreed(
                                cubit.breedData, context, cubit),
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
                      const SizedBox(height: 8),
                      const SizedBox(height: 8),
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
                                if (cubit.pitsImage != null) {
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
                                    cubit.createPet();
                                  });
                                } else {
                                  if (cubit.searchController.text.isEmpty) {
                                    cubit.createPet();
                                  } else {
                                    if (cubit.breedData.any((BreadData data) =>
                                        data.enType ==
                                        cubit.searchController.text)) {
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
        child: MyTextForm(
          controller: cubit.birthdateController,
          enabled: false,
          prefixIcon: const Icon(
            Icons.calendar_month,
            size: 14,
          ),
          enable: false,
          hintText: isArabic()
              ? 'من فضلك ادخل تاريخ الميلاد'
              : 'Please enter date of birth',
          validatorText: isArabic()
              ? 'من فضلك ادخل تاريخ الميلاد'
              : 'Please enter date of birth',
          obscureText: false,
        ));
  }

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
