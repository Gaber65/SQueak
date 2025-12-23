import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../data/models/files_and_prescription_for_pet_model.dart';

part 'files_and_prescription_for_pet_state.dart';

class FilesAndPrescriptionForPetCubit
    extends Cubit<FilesAndPrescriptionForPetState> {
  FilesAndPrescriptionForPetCubit()
    : super(FilesAndPrescriptionForPetInitial());

  late PrescriptionAndFiles getPrescriptionAndFilesModel;
  bool getTheFilesAndPrescriptionForPetLoading = false;

  void getTheFilesAndPrescriptionForPet({required String reservationid}) async {
    getTheFilesAndPrescriptionForPetLoading = true;
    try {
      Response response = await DioFinalHelper.getData(
        method: getFilesAndPrescriptionForPetEndPoint(
          reservationid: reservationid,
        ),
        language: true,
      );

      // doctors = (response.data['data'] as List)
      //     .map((e) => DoctorModel.fromJson(e))
      //     .toList();

      getPrescriptionAndFilesModel = PrescriptionAndFiles.fromJson(
        response.data,
      );


      getTheFilesAndPrescriptionForPetLoading = false;
      emit(GetFilesAndPrescriptionForPetSuccessState());
    } on DioException {

      getTheFilesAndPrescriptionForPetLoading = false;
      emit(GetFilesAndPrescriptionForPetErrorState());
    }
  }
}
