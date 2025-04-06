import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../authentication/models/login.dart';
import '../../layout/models/owner_model.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial());

  static SettingCubit get(context) => BlocProvider.of(context);
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  int gender = 1;
  OwnerModel? profile;

  init(context) {
    LayoutCubit.get(context).getOwnerData();
    OwnerModel model = LayoutCubit.get(context).profile;
    print(model.toJson());
    profile = model;
    nameController.text = model.fullName;
    phoneController.text = model.phone;
    addressController.text = model.address;
    emailController.text = model.email;
    imageController.text = model.imageName;
    birthDateController.text = model.birthdate.isNotEmpty &&
            model.birthdate != 'BirthDate' &&
            model.birthdate.length >= 10
        ? model.birthdate.substring(0, 10)
        : '';

    gender = model.gender;
    emit(SettingInitial());
  }

  void changeGender(int value) {
    gender = value;
    emit(ChangeGenderState());
  }

  void changeBirthdate(ChangeBirthdate) {
    birthDateController.text = ChangeBirthdate;
    emit(ChangeBirthdateState());
  }

  void changeImageName(ChangeImageName) {
    imageController.text = ChangeImageName;
    emit(ChangeImageNameState());
  }

  File? profileImage;
  var picker = ImagePicker();

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

  Future updateProfile() async {
    isLoading = true;
    emit(UpdateProfileLoadingState());
    try {
      Response response = await DioFinalHelper.putData(
        method: updatemyprofileEndPoint,
        data: {
          "fullName": nameController.text,
          "address": addressController.text,
          "imageName": imageController.text,
          "birthDate": birthDateController.text,
          "gender": gender,
        },
      );

      isLoading = false;
      emit(UpdateProfileSuccessState(
          OwnerModel.fromJson(response.data['data'])));
    } on DioException catch (e) {
      print(e.response!.data);

      isLoading = false;
      ErrorMessageModel errorMessageModel = ErrorMessageModel.fromJson(e.response!.data);
      emit(UpdateProfileErrorState(errorMessageModel.errors.isNotEmpty
          ? errorMessageModel.errors.values.first.first
          : errorMessageModel.message));
    }
  }
}
