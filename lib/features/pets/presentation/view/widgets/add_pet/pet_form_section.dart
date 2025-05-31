import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../../controller/pet_cubit.dart';
import 'spayed_toggle.dart';
import 'pet_name_field.dart';
import 'breed_species_section.dart';
import 'gender_selection.dart';
import 'birthdate_picker.dart';
import 'passport_section.dart';
import 'save_button.dart';

class PetFormSection extends StatelessWidget {
  const PetFormSection({super.key, required this.cubit, required this.isDark});

  final PetCubit cubit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpayedToggle(cubit: cubit),
          SizedBox(height: responsiveHeight(20, context)),

          PetNameField(cubit: cubit, isDark: isDark),
          SizedBox(height: responsiveHeight(20, context)),

          PassportSection(cubit: cubit, isDark: isDark),
          SizedBox(height: responsiveHeight(30, context)),

          BreedSpeciesSection(cubit: cubit, isDark: isDark),
          SizedBox(height: responsiveHeight(20, context)),

          GenderSelection(cubit: cubit),
          SizedBox(height: responsiveHeight(20, context)),


          BirthdatePicker(cubit: cubit, isDark: isDark),
          SizedBox(height: responsiveHeight(20, context)),

          SaveButton(cubit: cubit),
          SizedBox(height: responsiveHeight(30, context)),
        ],
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
