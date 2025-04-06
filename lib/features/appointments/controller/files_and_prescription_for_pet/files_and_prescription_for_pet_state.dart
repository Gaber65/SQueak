part of 'files_and_prescription_for_pet_cubit.dart';

@immutable
sealed class FilesAndPrescriptionForPetState {}

final class FilesAndPrescriptionForPetInitial extends FilesAndPrescriptionForPetState {}

final class GetFilesAndPrescriptionForPetSuccessState extends FilesAndPrescriptionForPetState {}
final class GetFilesAndPrescriptionForPetLoadingState extends FilesAndPrescriptionForPetState {}
final class GetFilesAndPrescriptionForPetErrorState extends FilesAndPrescriptionForPetState {}
