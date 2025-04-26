import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/layout/layout.dart';
import 'package:squeak/features/settings/controller/setting_cubit.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../../generated/l10n.dart';
import '../../layout/models/owner_model.dart';

class UpProfileScreen extends StatelessWidget {
  UpProfileScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingCubit()..init(context),
      child: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccessState) {
            successToast(context,
                isArabic() ? 'تم التعديل بنجاح' : 'Update successfully');
            LayoutCubit.get(context).getOwnerData();
            LayoutCubit.get(context).getOwnerPet();
            CacheHelper.saveData('name', state.userModel.fullName);
            navigateAndFinish(context, LayoutScreen());
            LayoutCubit.get(context).changeBottomNav(3);
          }
          if (state is UpdateProfileErrorState) {
            errorToast(context, state.error);
          }
        },
        builder: (context, state) {
          var cubit = SettingCubit.get(context);

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
                      const SizedBox(
                        height: 20,
                      ),
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
                                backgroundImage: cubit.profileImage == null
                                    ? NetworkImage(
                                        cubit.imageController.text.isNotEmpty
                                            ? '$imageUrl${cubit.imageController.text}'
                                            : AssetImageModel.defaultUserImage,
                                      )
                                    : FileImage(cubit.profileImage!)
                                        as ImageProvider,
                              ),
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
                                          cubit.profile!,
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

                      /// name
                      SizedBox(
                        height: 10,
                      ),
                      MyTextForm(
                        controller: cubit.nameController,
                        prefixIcon: const Icon(
                          Icons.person,
                          size: 14,
                        ),
                        enable: false,
                        hintText: S.of(context).name_hint,
                        validatorText: S.of(context).name_validation,
                        obscureText: false,
                      ),

                      /// address
                      SizedBox(
                        height: 10,
                      ),
                      MyTextForm(
                        controller: cubit.addressController,
                        prefixIcon: const Icon(
                          Icons.location_on,
                          size: 14,
                        ),
                        enable: false,
                        hintText: S.of(context).address_hint,
                        validatorText: S.of(context).address_validation,
                        obscureText: false,
                      ),

                      /// birthdate
                      SizedBox(
                        height: 10,
                      ),
                      buildSelectDate2(context, cubit),

                      /// phone
                      SizedBox(
                        height: 20,
                      ),
                      MyTextForm(
                        controller: cubit.phoneController,
                        prefixIcon: const Icon(
                          Icons.phone,
                          size: 14,
                        ),
                        enable: false,
                        enabled: false,
                        hintText: S.of(context).phone_hint,
                        validatorText: S.of(context).phone_validation,
                        obscureText: false,
                      ),

                      /// phone
                      if (cubit.emailController.text.isNotEmpty)
                        SizedBox(
                          height: 20,
                        ),
                      if (cubit.emailController.text.isNotEmpty)
                        MyTextForm(
                          controller: cubit.emailController,
                          prefixIcon: const Icon(
                            Icons.email,
                            size: 14,
                          ),
                          enable: false,
                          enabled: false,
                          hintText: S.of(context).email_hint,
                          validatorText: S.of(context).email_validation,
                          obscureText: false,
                        ),

                      ///gender
                      SizedBox(
                        height: 20,
                      ),
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

                      /// button
                      SizedBox(
                        height: 30,
                      ),
                      BlocConsumer<MainCubit, MainState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return CustomElevatedButton(
                            isLoading: cubit.isLoading,
                            formKey: cubit.formKey,
                            onPressed: () {
                              // if (cubit.profileImage == null) {
                              //   cubit.updateProfile();
                              // } else {
                              //   cubit.isLoading = true;
                              //   MainCubit.get(context)
                              //       .getGlobalImage(
                              //     file: cubit.profileImage!,
                              //     uploadPlace: UploadPlace.usersImages.value,
                              //   )
                              //       .whenComplete(() {
                              //     cubit.imageController.text =
                              //         MainCubit.get(context).modelImage!.data!;
                              //     cubit.updateProfile();
                              //   });
                              // }
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

  Material ImageOption(
      BuildContext context, OwnerModel model, SettingCubit cubit) {
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
                  if (cubit.profileImage == null) {
                    cubit.imageController.text = '';
                    cubit.emit(ChangeImageNameState());
                  } else {
                    cubit.profileImage = null;
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

  Widget buildSelect(title, id, SettingCubit cubit) {
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

  Widget buildSelectDate2(BuildContext context, SettingCubit cubit) {
    return InkWell(
      onTap: () => selectDate(context, cubit), // Trigger date picker on tap
      child: IgnorePointer(
        // Prevent direct interaction with the TextFormField
        child: MyTextForm(
          controller: cubit.birthDateController,
          enabled: true,
          enable: false, // Disable the text input field
          prefixIcon: const Icon(
            Icons.calendar_month,
            size: 14,
          ),
          hintText: S.of(context).birthdate_hint,
          validatorText: S.of(context).birthdate_validation,
          obscureText: false,
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context, SettingCubit cubit) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate =
          pickedDate.toString().substring(0, 10); // 'yyyy-MM-dd'
      parseDateFromInput(formattedDate);
      cubit.changeBirthdate(formattedDate);
    }
  }
}

String convertArabicToEnglishNumbers(String input) {
  const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  for (int i = 0; i < arabicNumbers.length; i++) {
    input = input.replaceAll(arabicNumbers[i], englishNumbers[i]);
  }

  return input;
}

DateTime? parseDateFromInput(String input) {
  try {
    // Convert Arabic to English numbers
    String englishInput = convertArabicToEnglishNumbers(input);
    return DateTime.parse(englishInput); // Parse the date
  } catch (e) {
    return null; // Return null if parsing fails
  }
}
