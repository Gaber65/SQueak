import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/boarding_entry_entity.dart';
import '../entities/boarding_type_entity.dart';
import '../usecases/share_image_usecase.dart';

abstract class BoardingRepository {
  Future<Either<Failure, List<BoardingTypeEntity>>> getBoardingTypes(
    String clinicCode,
  );
  Future<Either<Failure, void>> createBoarding(CreateBoardingParams params);
  Future<Either<Failure, void>> editBoarding(EditBoardingParams params);
  Future<Either<Failure, List<BoardingEntryEntity>>> getBoardingEntries(
    String phone,
    bool applyFilter,
  );
  Future<Either<Failure, void>> rateBoarding(RateBoardingParams params);

  Future<Either<Failure, void>> shareImage(ShareImageBoardingEntriesParams params);
}

class CreateBoardingParams {
  final String clinicCode;
  final String entryDate;
  final String existDate;
  final int period;
  final String comment;
  final String boardingTypeId;
  final String vetICarePetId;

  CreateBoardingParams({
    required this.clinicCode,
    required this.entryDate,
    required this.existDate,
    required this.period,
    required this.comment,
    required this.boardingTypeId,
    required this.vetICarePetId,
  });

  Map<String, dynamic> toMap() {
    return {
      'clinicCode': clinicCode,
      'entryDate': entryDate,
      'existDate': existDate,
      'period': period,
      'comment': comment,
      'boardingTypeId': boardingTypeId,
      'vetICarePetId': vetICarePetId,
    };
  }
}

class EditBoardingParams extends CreateBoardingParams {
  final String id;
  final int boardingStatus;

  EditBoardingParams({
    required this.id,
    required super.clinicCode,
    required super.entryDate,
    required super.existDate,
    required super.period,
    required super.comment,
    required super.boardingTypeId,
    required super.vetICarePetId,
    required this.boardingStatus,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clinicCode': clinicCode,
      'entryDate': entryDate,
      'existDate': existDate,
      'period': period,
      'comment': comment,
      'boardingTypeId': boardingTypeId,
      'vetICarePetId': vetICarePetId,
      'status': boardingStatus,
    };
  }
}

class RateBoardingParams {
  final String boardingId;
  final int cleanlinessRate;
  final int doctorServiceRate;
  final String feedbackComment;

  RateBoardingParams({
    required this.boardingId,
    required this.cleanlinessRate,
    required this.doctorServiceRate,
    required this.feedbackComment,
  });

  Map<String, dynamic> toMap() {
    return {
      'boardingId': boardingId,
      'cleanlinessRate': cleanlinessRate,
      'doctorServiceRate': doctorServiceRate,
      'feedbackComment': feedbackComment,
    };
  }
}
