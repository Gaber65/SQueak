// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../controller/setting_cubit.dart';

class UpProfileScreen extends StatelessWidget {
  UpProfileScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => sl<SettingCubit>()..init(context),
    child: BlocConsumer<SettingCubit, SettingState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccessState) {
          successToast(context, S.of(context).updateSuccess);
          CacheHelper.saveData('name', state.owner.fullName);
          SettingCubit.get(context).getOwnerData();
          // Changed from index 3 to index 0 for first tab
          LayoutCubit.get(context).changeBottomNav(0);
          navigateAndFinish(context, LayoutScreen());
        }
        if (state is UpdateProfileErrorState) {
          errorToast(context, state.message);
        }
      },
      builder: (context, state) {
        var cubit = SettingCubit.get(context);

        if (state is GetOwnerDataLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(S.of(context).updateProfile),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Profile Image Section
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor:
                                (CacheHelper.getData('isDark')) == true
                                    ? ColorManager.editScreenBaseBlueColors
                                    : ColorManager.sWhite,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  cubit.profileImage == null
                                      ? NetworkImage(
                                        cubit.imageController.text.isNotEmpty
                                            ? '$imageUrl${cubit.imageController.text}'
                                            : AssetImageModel
                                                .defaultUserImage,
                                      )
                                      : FileImage(cubit.profileImage!)
                                          as ImageProvider,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 15,
                              child: IconButton(
                                icon: const Icon(Icons.settings),
                                iconSize: 15,
                                onPressed: () {
                                  scaffoldKey.currentState!.showBottomSheet(
                                    backgroundColor: Colors.white.withOpacity(
                                      0,
                                    ),
                                    elevation: 0,
                                    (context) {
                                      return _buildImageOptions(
                                        context,
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

                    const SizedBox(height: 20),

                    // Name Field
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: cubit.nameController,
                      icon: Icons.person,
                      hintText: S.of(context).name_hint,
                      validatorText: S.of(context).name_validation,
                    ),

                    // Address Field
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: cubit.addressController,
                      icon: Icons.location_on,
                      hintText: S.of(context).address_hint,
                      validatorText: S.of(context).address_validation,
                    ),

                    // Birthdate Field
                    SizedBox(height: 10),
                    _buildDateSelector(context, cubit),

                    // Phone Field
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: cubit.phoneController,
                      icon: Icons.phone,
                      hintText: S.of(context).phone_hint,
                      validatorText: S.of(context).phone_validation,
                      enabled: false,
                    ),

                    // Email Field (if available)
                    if (cubit.emailController.text.isNotEmpty) ...[
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: cubit.emailController,
                        icon: Icons.email,
                        hintText: S.of(context).email_hint,
                        validatorText: S.of(context).email_validation,
                        enabled: false,
                      ),
                    ],

                    // Gender Selection
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildGenderSelect(
                            S.of(context).male,
                            1,
                            cubit,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildGenderSelect(
                            S.of(context).female,
                            2,
                            cubit,
                          ),
                        ),
                      ],
                    ),

                    // Save Button
                    SizedBox(height: 30),
                    CustomElevatedButton(
                      isLoading: cubit.isLoading,
                      formKey: cubit.formKey,
                      onPressed: () async {
                        if (cubit.formKey.currentState!.validate()) {
                          if (cubit.profileImage == null) {
                            await cubit.updateProfile();
                          } else {
                            cubit.isLoading = true;
                            cubit.emit(ChangeBirthdateState());
                            MainCubit.get(context)
                                .getGlobalImage(
                                  cubit.profileImage!,
                                  UploadPlace.petsImages,
                                )
                                .then((value) {
                                  cubit.imageController.text =
                                      MainCubit.get(context).modelImage!.data;
                                  cubit.updateProfile();
                                });
                          }
                        }
                      },
                      buttonText: S.of(context).save,
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
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required String validatorText,
    bool obscureText = false,
    bool enabled = true,
  }) {
    return MyTextForm(
      controller: controller,
      prefixIcon: Icon(icon, size: 14),
      enable: false,
      enabled: enabled,
      hintText: hintText,
      validatorText: validatorText,
      obscureText: obscureText,
    );
  }

  Widget _buildDateSelector(BuildContext context, SettingCubit cubit) {
    return InkWell(
      onTap: () => _selectDate(context, cubit),
      child: IgnorePointer(
        child: MyTextForm(
          controller: cubit.birthDateController,
          enabled: true,
          enable: false,
          prefixIcon: const Icon(Icons.calendar_month, size: 14),
          hintText: S.of(context).birthdate_hint,
          validatorText: S.of(context).birthdate_validation,
          obscureText: false,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, SettingCubit cubit) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = pickedDate.toString().substring(
        0,
        10,
      ); // 'yyyy-MM-dd'
      _parseDateFromInput(formattedDate);
      cubit.changeBirthdate(formattedDate);
    }
  }

  Widget _buildGenderSelect(String title, int id, SettingCubit cubit) {
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
          color:
              cubit.gender == id
                  ? ColorManager.primaryColor
                  : ColorManager.primaryColor.withOpacity(.3),
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

  Widget _buildImageOptions(BuildContext context, SettingCubit cubit) {
    return Material(
      elevation: 12,
      color:
          MainCubit.get(context).isDark
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
            const SizedBox(height: 12),

            if (cubit.imageController.text.isNotEmpty)
              MaterialButton(
                onPressed: () {
                  if (cubit.profileImage == null) {
                    cubit.imageController.text = '';
                  } else {
                    cubit.profileImage = null;
                  }
                  Navigator.of(scaffoldKey.currentContext!).pop();
                },
                child: Row(
                  children: [
                    Text(S.of(context).deletePhoto),
                    Spacer(),
                    Icon(Icons.delete),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            MaterialButton(
              onPressed: () {
                cubit.getProfileImage();
                Navigator.of(scaffoldKey.currentContext!).pop();
              },
              child: Row(
                children: [
                  Text(S.of(context).changePhoto),
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

  DateTime? _parseDateFromInput(String input) {
    try {
      // Convert Arabic to English numbers
      String englishInput = _convertArabicToEnglishNumbers(input);
      return DateTime.parse(englishInput); // Parse the date
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  String _convertArabicToEnglishNumbers(String input) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabicNumbers.length; i++) {
      input = input.replaceAll(arabicNumbers[i], englishNumbers[i]);
    }

    return input;
  }
}
