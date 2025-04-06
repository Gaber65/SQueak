import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';


import '../../../generated/l10n.dart';
import '../models/pet_model.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  PetCubit() : super(PetInitial()) {
    if (CacheHelper.getData('usersPets') != null) {
      String stringToJason = CacheHelper.getData('usersPets');
      List<PetsData> usersPets = List<PetsData>.from(
          json.decode(stringToJason).map((x) => PetsData.fromJson(x)));
      pets = usersPets.where((element) {
        return element.petId != CacheHelper.getData('clintId');
      }).toList();
    }

    if (CacheHelper.getData('allBreeds') != null) {
      String stringToJasonBreed = CacheHelper.getData('allBreeds');
      List<BreadData> allBreedsCache = List<BreadData>.from(
          json.decode(stringToJasonBreed).map((x) => BreadData.fromJson(x)));
      allBreeds = allBreedsCache;
    }
  }

  static PetCubit get(context) => BlocProvider.of(context);

  List<PetsData> pets = [];

  Future<void> getOwnerPet() async {
    emit(SqueakGetOwnerPetlaoding());
    try {
      Response response = await DioFinalHelper.getData(
        method: getOwnerPetEndPoint,
        language: true,
      );

      pets = (response.data['data']['petsDto'] as List)
          .map((e) => PetsData.fromJson(e))
          .toList();
      String jsonToString = json.encode(response.data['data']['petsDto']);

      CacheHelper.saveData('usersPets', jsonToString);

      emit(SqueakGetOwnerPetSuccess());
    } on DioException catch (e) {
      print(e.response!.data + '**********************');
      emit(SqueakGetOwnerPetError());
    }
  }

  List<BreadData> allBreeds = [];

  Future<void> getAllBreed() async {
    emit(GetAllBreedsLoadingState());
    try {
      Response response = await DioFinalHelper.getData(
        method: allBreed,
        language: false,
      );

      breedData = List<BreadData>.from(
          response.data['data']['breedDto'].map((x) => BreadData.fromJson(x)));
      String jsonToString = json.encode(response.data['data']['breedDto']);
      CacheHelper.saveData('allBreeds', jsonToString);
      emit(GetAllBreedsSuccessState());
    } on DioException catch (e) {
      print(e);
      emit(GetAllBreedsErrorState());
    }
  }

  void init(species, speciesId) {
    print(pets);
    dropdownValueSpecies = species;
    dropdownValueSpeciesId = speciesId;
    emit(PetCreateSuccessState());
  }

  String petId = '';
  String specieId = '';

  void initEdit(PetsData model) {
    petNameController.text = model.petName;
    breedIdController.text = model.breedId;
    birthdateController.text =
        model.birthdate.isEmpty ? '' : model.birthdate.substring(0, 10);
    imageNameController.text =
        (model.imageName.toString().contains('freepik')) ? '' : model.imageName;
    gender = model.gender;
    petId = model.petId;
    specieId = model.specieId;
    spayed = model.isSpayed;
    dropdownValueBreed = model.breedId;

    model.breed == null
        ? searchController.text = S.current.breed
        : searchController.text = model.breed!.enType;

    emit(PetCreateSuccessState());
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController breedIdController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController birthdateController =
      TextEditingController(text: DateTime.now().toString().substring(0, 10));
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController imageNameController = TextEditingController();
  int gender = 1;
  String dropdownValueBreed = '';
  String dropdownValueSpecies = '';
  String dropdownValueSpeciesId = '';
  bool isLoading = false;

  void createPet() async {
    isLoading = true;
    emit(PetCreateLoadingState());
    try {
      Response response = await DioFinalHelper.postData(
        method: addPetEndPint,
        data: breedIdController.text.isEmpty
            ? {
                'petName': petNameController.text,
                'gender': gender,
                'imageName': imageNameController.text,
                'birthdate': birthdateController.text,
                'ownerId': CacheHelper.getData('clintId'),
                "specieId": dropdownValueSpeciesId,
                "isSpayed": spayed
              }
            : {
                'petName': petNameController.text,
                'gender': gender,
                'breedId': breedIdController.text,
                'imageName': imageNameController.text,
                'birthdate': birthdateController.text,
                "specieId": dropdownValueSpeciesId,
                'ownerId': CacheHelper.getData('clintId'),
                "isSpayed": spayed
              },
      );

      pets.add(PetsData.fromJson(response.data['data']));
      String petsJson = jsonEncode(pets.map((pet) => pet.toMap()).toList());
      CacheHelper.saveData('usersPets', petsJson);

      print(CacheHelper.getData('usersPets') + '*****************');
      print(response.data);
      print(pets.length);
      isLoading = false;
      emit(PetCreateSuccessState());
    } on DioException catch (e) {
      isLoading = false;
      print(e.response!.data);
      emit(PetCreateErrorState(ErrorMessageModel.fromJson(e.response!.data)));
    }
  }

  void editPet() async {
    isLoading = true;

    print("breedIdController.text");
    print(breedIdController.text);

    emit(PetCreateLoadingState());
    try {
      Response response = await DioFinalHelper.patchData(
        method: updatePetEndPint + petId,
        data: {
          'petName': petNameController.text,
          'gender': gender,
          'imageName': imageNameController.text == 'PetAvatar.png'
              ? ''
              : imageNameController.text,
          'birthdate': birthdateController.text,
          'specieId': dropdownValueSpeciesId,
          'breedId':
              breedIdController.text.isEmpty || breedIdController.text == ''
                  ? null
                  : breedIdController.text,
          'ownerId': CacheHelper.getData('clintId'),
          "isSpayed": spayed
        },
      );

      pets.add(PetsData.fromJson(response.data['data']));
      String petsJson = jsonEncode(pets.map((pet) => pet.toMap()).toList());
      CacheHelper.saveData('usersPets', petsJson);
      isLoading = false;
      emit(PetCreateSuccessState());
    } on DioException catch (e) {
      isLoading = false;
      print(e.response!.data);
      emit(PetCreateErrorState(ErrorMessageModel.fromJson(e.response!.data)));
    }
  }

  void changeGender(ChangeGender) {
    gender = ChangeGender;
    emit(ChangeGenderState());
  }

  void changeBirthdate(ChangeBirthdate) {
    birthdateController.text = ChangeBirthdate;
    emit(ChangeBirthdateState());
  }

  void changeImageName(ChangeImageName) {
    imageNameController.text = ChangeImageName;
    emit(ChangeImageNameState());
  }

  /// TODO: Mohamed Elkerm -> fuunction run wrong the dropdownValueBreed need id and the oldd function give it just name
  void changeBreed(name, id) {
    breedIdController.text = id;
    dropdownValueBreed = name;
    emit(ChangeBreedState());
  }

  void changeSpecies(name, id) {
    dropdownValueSpecies = name;
    dropdownValueSpeciesId = id;
    emit(ChangeSpeciesState());
  }

  File? pitsImage;
  var picker = ImagePicker();

  Future<void> getPitsImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pitsImage = File(pickedFile.path);
      emit(PitsImagePickedSuccessState());
    } else {
      emit(PitsImagePickedErrorState());
    }
  }

  List<BreadData> breedData = [];

  Future<void> getAllBreeds(id) async {
    emit(GetAllBreedsLoadingState());
    try {
      Response response = await DioFinalHelper.getData(
        method: allBreedBySpeciesId + id.toString(),
        language: false,
      );

      breedData = List<BreadData>.from(
          response.data['data']['breedDto'].map((x) => BreadData.fromJson(x)));
      emit(GetAllBreedsSuccessState());
    } on DioException catch (e) {
      print(e);
      emit(GetAllBreedsErrorState());
    }
  }

  List<BreadData> species = [];

  Future<void> getAllSpecies() async {
    emit(GetAllSpeciesLoadingState());
    try {
      Response response = await DioFinalHelper.getData(
        language: false,
        method: allSpeciesEndPoint,
      );
      species = List<BreadData>.from(response.data['data']['speciesDtos']
          .map((x) => BreadData.fromJson(x)));
      emit(GetAllSpeciesSuccessState());
    } on DioException catch (e) {
      print(e);

      emit(GetAllSpeciesErrorState());
    }
  }

  Future<void> deletePet(id) async {
    print('id = $id');
    emit(DeletePetLoadingState());
    try {
      Response response = await DioFinalHelper.deleteData(
        method: deletePetEndPint + id.toString(),
      );
      getOwnerPet();
      emit(DeletePetSuccessState());
    } on DioException catch (e) {
      print(e.response!.data + '************');
      emit(DeletePetErrorState());
    }
  }

  @override
  Future<void> close() {
    print('close Cubit');
    CacheHelper.removeData('NotificationId');
    CacheHelper.removeData('NotificationType');

    return super.close();
  }

  bool spayed = false;

  void changeSpayed() {
    spayed = !spayed;
    emit(ChangeBreedState());
  }
}
