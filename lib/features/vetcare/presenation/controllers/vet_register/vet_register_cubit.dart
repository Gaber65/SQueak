import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/data_vet.dart';
import '../../../domain/use_case/register_vet_usecase.dart';

part 'vet_register_state.dart';

class VetRegisterCubit extends Cubit<VetRegisterState> {
  final RegisterVetUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final GetClientUseCase getClientUseCase;

  VetRegisterCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.getClientUseCase,
  }) : super(VetRegisterInitial());

  static VetRegisterCubit get(context) => BlocProvider.of(context);

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State variables
  bool isRegister = false;
  DataVetEntity? vetClientModelOne;
  File? profileImage;
  final ImagePicker picker = ImagePicker();

  Future<void> register() async {
    isRegister = true;
    emit(LoadingRegisterState());

    final params = RegisterParams(
      fullName: vetClientModelOne?.name ?? '',
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      clientId: vetClientModelOne?.vetICareId ?? '',
      birthDate: birthDateController.text,
      gender: 1,
      clinicCode: vetClientModelOne?.clinicCode ?? '',
      countryId: vetClientModelOne?.countryId ?? 0,
    );

    final result = await registerUseCase(params);

    result.fold(
      (failure) {
        isRegister = false;
        emit(ErrorRegisterState(failure.message));
      },
      (clients) {
        // Check if registration was successful
        if (clients.first.id.contains('0000')) {
          login(false);
        } else {
          login(true);
        }
        emit(SuccessRegisterState());
      },
    );
  }

  Future<void> login(bool isHavePet) async {
    emit(LoadingLoginState());

    final params = LoginParams(
      emailOrPhone: vetClientModelOne?.phone ?? '',
      password: passwordController.text,
    );

    final result = await loginUseCase(params);

    result.fold(
      (failure) {
        isRegister = false;
        emit(ErrorLoginState(failure.message));
      },
      (authToken) {
        isRegister = false;
        emit(SuccessLoginState(authToken, isHavePet));
      },
    );
  }

  Future<void> getClient(String invitationCode) async {
    emit(LoadingGetClientState());

    final result = await getClientUseCase(invitationCode);

    result.fold(
      (failure) {
        emit(ErrorGetClientState());
      },
      (dataVet) {
        vetClientModelOne = dataVet;
        phoneController.text = vetClientModelOne?.phone ?? '';
        emailController.text = vetClientModelOne?.email ?? '';
        emit(SuccessGetClientState());
      },
    );
  }

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    birthDateController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}