import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/layout/controller/layout_cubit.dart';

import '../../authentication/models/login.dart';
import '../../layout/models/owner_model.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial());

  static SettingCubit get(BuildContext context) => BlocProvider.of(context);

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final imageController = TextEditingController();
  final birthDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int gender = 1;
  OwnerModel? profile;

  void init(BuildContext context) {
    final model = LayoutCubit.get(context).profile;
    profile = model;

    nameController.text = model.fullName;
    phoneController.text = model.phone;
    addressController.text = model.address;
    emailController.text = model.email;
    imageController.text = model.imageName;
    birthDateController.text = _formatBirthDate(model.birthdate);
    gender = model.gender;

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

  Future<void> getPitsImage() async {
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

    try {
      final response = await DioFinalHelper.putData(
        method: updatemyprofileEndPoint,
        data: {
          "fullName": nameController.text,
          "address": addressController.text,
          "imageName": imageController.text,
          "birthDate": birthDateController.text,
          "gender": gender,
        },
      );

      final updatedUser = OwnerModel.fromJson(response.data['data']);
      isLoading = false;
      emit(UpdateProfileSuccessState(updatedUser));
    } on DioException catch (e) {
      isLoading = false;
      final errorMessageModel = ErrorMessageModel.fromJson(e.response?.data);
      final error = errorMessageModel.errors.isNotEmpty
          ? errorMessageModel.errors.values.first.first
          : errorMessageModel.message;
      emit(UpdateProfileErrorState(error));
    }
  }
}
