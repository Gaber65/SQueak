import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import '../../domain/entities/boarding_entry_entity.dart';
import '../../domain/entities/boarding_type_entity.dart';
import '../../domain/repositories/boarding_repository.dart'
    show CreateBoardingParams, EditBoardingParams, RateBoardingParams;
import '../../domain/usecases/create_boarding_usecase.dart';
import '../../domain/usecases/edit_boarding_usecase.dart';
import '../../domain/usecases/get_boarding_entries_usecase.dart';
import '../../domain/usecases/get_boarding_types_usecase.dart';
import '../../domain/usecases/rate_boarding_usecase.dart';
import '../../domain/usecases/share_image_usecase.dart';
import 'boarding_state.dart';

class BoardingCubit extends Cubit<BoardingState> {
  final GetBoardingTypesUseCase getBoardingTypesUseCase;
  final CreateBoardingUseCase createBoardingUseCase;
  final EditBoardingUseCase editBoardingUseCase;
  final GetBoardingEntriesUseCase getBoardingEntriesUseCase;
  final RateBoardingUseCase rateBoardingUseCase;
  final ShareImageEntriesUseCase shareImageEntriesUseCase;

  BoardingCubit({
    required this.getBoardingTypesUseCase,
    required this.createBoardingUseCase,
    required this.editBoardingUseCase,
    required this.getBoardingEntriesUseCase,
    required this.rateBoardingUseCase,
    required this.shareImageEntriesUseCase,
  }) : super(BoardingInitial());

  static BoardingCubit get(context) => BlocProvider.of<BoardingCubit>(context);

  List<BoardingTypeEntity> boardingTypes = [];
  List<BoardingEntryEntity> boardingEntries = [];
  List<BoardingEntryEntity> filteredEntries = [];

  // Rating properties
  int ratingCleanliness = 0;
  int ratingDoctor = 0;
  TextEditingController rateController = TextEditingController();

  // Filter properties
  String? selectedPetId;
  String? petName;
  int? selectedState;
  String? selectedStateValue;

  Future<void> getBoardingTypes(String clinicCode) async {
    emit(GetBoardingTypesLoading());

    final result = await getBoardingTypesUseCase(clinicCode);

    result.fold(
      (failure) => emit(GetBoardingTypesError(failure.error.message)),
      (types) {
        boardingTypes = types;
        emit(GetBoardingTypesSuccess(types));
      },
    );
  }

  bool isLoading = false;
  Future<void> createBoarding(CreateBoardingParams params) async {
    isLoading = true;
    emit(CreateBoardingLoading());

    final result = await createBoardingUseCase(params);

    result.fold(
      (failure) {
        isLoading = false;
        emit(CreateBoardingError(failure.error.message));
      },
      (_) {
        isLoading = false;
        emit(CreateBoardingSuccess());
      },
    );
  }

  Future<void> editBoarding(EditBoardingParams params) async {
    emit(EditBoardingLoading());

    final result = await editBoardingUseCase(params);

    result.fold(
      (failure) => emit(EditBoardingError(failure.error.message)),
      (_) => emit(EditBoardingSuccess()),
    );
  }

  Future<void> getBoardingEntries( bool applyFilter) async {
    emit(GetBoardingEntriesLoading());

    final params = GetBoardingEntriesParams(
      phone: CacheHelper.getData('phone'),
      applyFilter: false,
    );

    final result = await getBoardingEntriesUseCase(params);

    result.fold(
      (failure) => emit(GetBoardingEntriesError(failure.error.message)),
      (entries) {
        boardingEntries = entries;
        filteredEntries = List.from(entries);
        emit(GetBoardingEntriesSuccess(entries));
      },
    );
  }

  Future<void> rateBoarding(BoardingEntryEntity BoardingEntryEntity) async {
    emit(RateBoardingLoading());

    final params = RateBoardingParams(
      boardingId: BoardingEntryEntity.id,
      cleanlinessRate: BoardingEntryEntity.cleanlinessRate,
      doctorServiceRate: BoardingEntryEntity.doctorServiceRate,
      feedbackComment: rateController.text,
    );

    final result = await rateBoardingUseCase(params);

    result.fold(
      (failure) => emit(RateBoardingError(failure.error.message)),
      (_) => emit(RateBoardingSuccess()),
    );
  }

  void shareImageEntries(ShareImageBoardingEntriesParams entries) =>
      shareImageEntriesUseCase(entries);

  void initRating(BoardingEntryEntity BoardingEntryEntity) {
    ratingCleanliness = BoardingEntryEntity.cleanlinessRate;
    ratingDoctor = BoardingEntryEntity.doctorServiceRate;
    rateController.text = BoardingEntryEntity.feedbackComment ?? '';
    emit(BoardingInitial());
  }

  void filterBoardings() {
    filteredEntries =
        boardingEntries.where((boarding) {
          final matchesPet =
              selectedPetId == null || boarding.pet.name == selectedPetId;
          final matchesState =
              selectedState == null || boarding.status == selectedState;
          return matchesPet && matchesState;
        }).toList();

    emit(BoardingFiltered(filteredEntries));
  }

  void clearFilters() {
    selectedPetId = null;
    selectedState = null;
    selectedStateValue = null;
    petName = null;
    filteredEntries = List.from(boardingEntries);
    emit(BoardingFilteredClear(filteredEntries));
  }

  @override
  Future<void> close() {
    rateController.dispose();
    return super.close();
  }
}
