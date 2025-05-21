import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/settings/domain/use_case/update_profile_usecase.dart';
import 'package:squeak/features/settings/data/models/owner_model.dart';

import '../../../../core/base_usecase/base_usecase.dart';
import '../../domain/entities/owner_entite.dart';
import '../../domain/use_case/get_owner_data_usecase.dart';

part 'setting_state.dart';

Future<OwnerModel?> loadProfile() async {
  final data = await CacheHelper.getData('Owner');
  if (data == null) return null;
  final map = jsonDecode(data);
  return OwnerModel.fromJson(map);
}

class SettingCubit extends Cubit<SettingState> {
  final GetOwnerDataUseCase getOwnerDataUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  SettingCubit({
    required this.getOwnerDataUseCase,
    required this.updateProfileUseCase,
  }) : super(SettingInitial());

  static SettingCubit get(BuildContext context) => BlocProvider.of(context);

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final imageController = TextEditingController();
  final birthDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int gender = 1;
  Owner? profile;

  Future<void> getOwnerData() async {
    emit(GetOwnerDataLoading());
    final result = await getOwnerDataUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        GetOwnerDataError(
          failure.error.errors.entries.first.value.first ??
              failure.error.message,
        ),
      ),
      (owner) {
        profile = owner;
        var toJson = owner.toMap();
        CacheHelper.saveData('Owner', jsonEncode(toJson));
        emit(GetOwnerDataSuccess());
      },
    );
  }

  void init(BuildContext context) async {
    profile = await loadProfile();
    nameController.text = profile!.fullName;
    phoneController.text = profile!.phone;
    addressController.text = profile!.address;
    emailController.text = profile!.email;
    imageController.text = profile!.imageName;
    birthDateController.text = _formatBirthDate(profile!.birthdate);
    gender = profile!.gender;

    emit(SettingInitial());
  }

  String _formatBirthDate(String date) {
    if (date.isNotEmpty && date != 'BirthDate' && date.length >= 10) {
      return date.substring(0, 10);
    }
    return '';
  }

  void changeGender(int value) {
    gender = value;
    emit(ChangeGenderState());
  }

  void changeBirthdate(String date) {
    birthDateController.text = date;
    emit(ChangeBirthdateState());
  }

  void changeImageName(String name) {
    imageController.text = name;
    emit(ChangeImageNameState());
  }

  File? profileImage;
  final picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }

  bool isLoading = false;

  Future<void> updateProfile() async {
    isLoading = true;
    emit(UpdateProfileLoadingState());

    final result = await updateProfileUseCase(
      UpdateProfileParameters(
        fullName: nameController.text,
        address: addressController.text,
        imageName: imageController.text,
        birthDate: birthDateController.text,
        gender: gender,
      ),
    );

    isLoading = false;

    result.fold(
      (failure) => emit(
        UpdateProfileErrorState(
          failure.error.errors.entries.first.value.first ??
              failure.error.message,
        ),
      ),
      (owner) {
        profile = owner;
        emit(UpdateProfileSuccessState(owner));
      },
    );
  }
}
