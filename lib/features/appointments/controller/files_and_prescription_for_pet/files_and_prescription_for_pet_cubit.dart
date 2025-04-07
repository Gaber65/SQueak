import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/helper/remotely/dio.dart';
import 'package:squeak/core/helper/remotely/end-points.dart';

import '../../models/files_and_prescription_for_pet_model.dart';

part 'files_and_prescription_for_pet_state.dart';

class FilesAndPrescriptionForPetCubit
    extends Cubit<FilesAndPrescriptionForPetState> {
  FilesAndPrescriptionForPetCubit()
      : super(FilesAndPrescriptionForPetInitial());

  late PrescriptionAndFiles getPrescriptionAndFilesModel;
  bool getTheFilesAndPrescriptionForPetLoading = false;

  void getTheFilesAndPrescriptionForPet({
    required String reservationid,
  }) async {
    getTheFilesAndPrescriptionForPetLoading = true;
    try {
      Response response = await DioFinalHelper.getData(
        method: getFilesAndPrescriptionForPetEndPoint(
          reservationid: reservationid,
        ),
        language: true,
      );
      print(response.data);

      // doctors = (response.data['data'] as List)
      //     .map((e) => DoctorModel.fromJson(e))
      //     .toList();

      getPrescriptionAndFilesModel = PrescriptionAndFiles.fromJson(
        response.data,
      );

      print("************************************");
      print(getPrescriptionAndFilesModel.data!.files!.isEmpty);

      getTheFilesAndPrescriptionForPetLoading = false;
      emit(GetFilesAndPrescriptionForPetSuccessState());
    } on DioException catch (e) {
      print(e);
      getTheFilesAndPrescriptionForPetLoading = false;
      emit(GetFilesAndPrescriptionForPetErrorState());
    }
  }
}
