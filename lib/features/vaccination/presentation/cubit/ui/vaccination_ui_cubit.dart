import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../../domain/entities/reminder_entity.dart';
import '../../../domain/entities/vaccination_entity.dart';
import '../data/vaccination_data_cubit.dart';

part 'vaccination_ui_state.dart';

class VaccinationUiCubit extends Cubit<VaccinationUiState> {
  final VaccinationDataCubit dataCubit;
  late StreamSubscription _dataCubitSubscription;

  VaccinationUiCubit({required this.dataCubit}) : super(VaccinationUiInitial());

  // UI state variables
  String feedSubTypeValue =
      isArabic() ? 'نوع معين الطعام' : 'select feed sub type';
  List<String> feedSubType = ["Dry food", "wet food", "snacks"];
  bool isButtonSheetShown = false;
  List<VaccinationNameEntity> vaccinationNames = [];
  List<ReminderEntity> reminders = [];
  String valueFeedItem = "Select Feed Type";
  bool isVacLoading = false;
  bool isEdit = false;
  bool isLoading = false;
  List<String> reminderFreq = [
    "Once",
    "Daily",
    "Weekly",
    "Monthly",
    "Annually",
  ];
  TextEditingController otherController = TextEditingController();
  bool? value;
  String valueVacItem = isArabic() ? 'اختر نوع الخدمة' : 'Select Service';
  String valueIdItem = '';
  DateTime currentDateItem = DateTime.now();
  String timeDateItem = '';
  bool isSelectedTime = false;
  bool isSelectedVac = false;
  TimeOfDay? picked = TimeOfDay.now();
  String currentFreq = "Select The Frequency";
  TimeOfDay? pickedFromEdit;
  DateTime? newValueForDateInEdit;
  late String currentFreqInEdit;

  // Listen to data cubit state changes
  void listenToDataCubit() {
    _dataCubitSubscription = dataCubit.stream.listen((state) {
      if (state is GetVaccinationNamesSuccess) {
        vaccinationNames = state.vaccinations;
        emit(VaccinationNamesLoaded(state.vaccinations));
      } else if (state is GetVaccinationNamesError) {
        emit(VaccinationUiError(state.message));
      } else if (state is GetPetRemindersSuccess) {
        reminders = state.reminders;
        isVacLoading = false;
        emit(PetRemindersLoaded(state.reminders));
      } else if (state is GetPetRemindersError) {
        isVacLoading = false;
        emit(VaccinationUiError(state.message));
      } else if (state is CreateReminderSuccess) {
        isLoading = false;
        isButtonSheetShown = false;
        dataCubit.getPetReminders(state.petId);
        print("reminder created");
        emit(ReminderActionSuccess());
      } else if (state is CreateReminderError) {
        isLoading = false;
        isButtonSheetShown = false;
        emit(VaccinationUiError(state.message));
      } else if (state is UpdateReminderSuccess) {
        emit(ReminderActionSuccess());
      } else if (state is UpdateReminderError) {
        emit(VaccinationUiError(state.message));
      } else if (state is DeleteReminderSuccess) {
        emit(ReminderActionSuccess());
      } else if (state is DeleteReminderError) {
        emit(VaccinationUiError(state.message));
      } else if (state is GetVaccinationNamesLoading ||
          state is GetPetRemindersLoading) {
        isVacLoading = true;
        emit(VaccinationUiLoading());
      } else if (state is CreateReminderLoading ||
          state is UpdateReminderLoading ||
          state is DeleteReminderLoading) {
        isLoading = true;
        emit(VaccinationUiLoading());
      }
    });
  }

  @override
  Future<void> close() {
    _dataCubitSubscription.cancel();
    otherController.dispose();
    return super.close();
  }

  // UI actions
  void changeBottomSheetShow({required bool isShow}) {
    isButtonSheetShown = !isShow;
    emit(BottomSheetStateChanged(isButtonSheetShown));
  }

  void loadVaccinationNames() {
    dataCubit.getVaccinationNames();
  }

  void loadPetReminders(String petId) {
    isVacLoading = true;
    dataCubit.getPetReminders(petId);
  }

  Future<void> createReminder({
    required String petId,
    required String petName,
    required String typeId,
    required String data,
    required String valueVacItem,
    required String comments,
    required BuildContext context,
  }) async {
    if (picked == null) {
      errorToast(
        context,
        isArabic() ? "الرجاء اختيار الوقت" : "Please select the time",
      );
      isLoading = false;
      emit(
        VaccinationUiError(
          isArabic() ? "الرجاء اختيار الوقت" : "Please select the time",
        ),
      );
      return;
    }

    int notificationId = Random().nextInt(1000000);

    final reminder = ReminderEntity(
      petName: petName,
      reminderType: valueVacItem,
      reminderFreq: currentFreq.toString(),
      date: data,
      time: "${picked!.hour} : ${picked!.minute}",
      timeAR: "${picked!.minute} : ${picked!.hour}",
      notes: comments,
      petId: petId,
      notificationID: notificationId.toString(),
      vaccinationId:valueIdItem,
      subTypeFeed:
          feedSubTypeValue.isEmpty ||
                  feedSubTypeValue.toString() == "نوع معين الطعام" ||
                  feedSubTypeValue.toString() == 'select feed sub type'
              ? ""
              : feedSubTypeValue.toString().trim(),
      otherTitle:
          valueVacItem == "other" || valueVacItem == "أخرى"
              ? otherController.text.trim()
              : "",
    );

    await dataCubit.createReminder(reminder, picked);

    // Schedule notification if reminder was created successfully
    if (dataCubit.state is CreateReminderSuccess) {
      valueVacItem = isArabic() ? 'اختر نوع الخدمة' : 'Select Service';
      valueIdItem = '';
      currentFreq = "Select The Frequency";
      otherController.clear();
      loadPetReminders(petId);
    }
  }


  void changeSelect({required String vacName, required String vacId}) {
    valueVacItem = vacName;
    valueIdItem = vacId;
    emit(SelectionChanged(vacName, vacId));
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime tomorrowDateItem = currentDateItem.add(const Duration(days: 0));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: tomorrowDateItem,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != currentDateItem) {
      String formattedDate = pickedDate.toString().substring(
        0,
        10,
      ); // 'yyyy-MM-dd'
      parseDateFromInput(formattedDate);
      currentDateItem = DateTime.parse(formattedDate);
      emit(DateChanged(currentDateItem));
    }
  }

  DateTime? parseDateFromInput(String input) {
    try {
      // Convert Arabic to English numbers
      String englishInput = convertArabicToEnglishNumbers(input);
      return DateTime.parse(englishInput);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  String convertArabicToEnglishNumbers(String input) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabicNumbers.length; i++) {
      input = input.replaceAll(arabicNumbers[i], englishNumbers[i]);
    }

    return input;
  }


  Future<void> selectTime(BuildContext context) async {
    emit(TimePickerLoading());

    picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      emit(TimePickerSuccess(picked!));
    } else {
      emit(TimePickerError());
    }
  }

  Future<void> selectTimeFromEdit(
    BuildContext context,
    TimeOfDay initTime,
  ) async {
    emit(TimePickerLoading());

    final picked = await showTimePicker(
      context: context,
      initialTime: initTime,
    );

    if (picked != null) {
      pickedFromEdit = picked;
      emit(TimePickerSuccess(picked));
    } else {
      emit(TimePickerError());
    }
  }

  Future<void> updateReminder({required ReminderEntity reminder}) async {
    final updatedReminder = ReminderEntity(
      id: reminder.id,
      petName: reminder.petName,
      timeAR: "${picked!.minute} : ${picked!.hour}",
      petId: reminder.petId,
      reminderType: reminder.reminderType,
      reminderFreq: reminder.reminderFreq,
      date: reminder.date,
      time: reminder.time,
      notes: reminder.notes,
      notificationID: reminder.notificationID,
      subTypeFeed: reminder.subTypeFeed,
      otherTitle: reminder.otherTitle,
    );

    await dataCubit.updateReminder(updatedReminder);

  }

  Future<void> deleteReminder({
    required ReminderEntity reminder,
    required String petId,
  }) async {
    if (reminder.id == null) {
      emit(VaccinationUiError("Reminder ID is null"));
      return;
    }

    await dataCubit.deleteReminder(reminder.id!);

    if (dataCubit.state is DeleteReminderSuccess) {
      loadPetReminders(petId);
    }
  }

  Future<void> selectDateOnEdit(BuildContext context, DateTime initDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: initDate,
      firstDate: initDate.isAfter(DateTime.now()) ? DateTime.now() : initDate,
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != newValueForDateInEdit) {
      String formattedDate = pickedDate.toString().substring(
        0,
        10,
      ); // 'yyyy-MM-dd'
      parseDateFromInput(formattedDate);
      newValueForDateInEdit = DateTime.parse(formattedDate);
      emit(EditDateChanged(newValueForDateInEdit!));
    }
  }

  DateTime takeStringReturnDateTime(String date) {
    List<String> dateParts = date.split("-");
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }

  void updateTheFrequency(String newFreValue) {
    currentFreqInEdit = newFreValue;
    emit(FrequencyChanged(newFreValue));
  }

  void resetForm() {
    valueVacItem = isArabic() ? 'اختر نوع الخدمة' : 'Select Service';
    valueIdItem = '';
    currentFreq = "Select The Frequency";
    otherController.clear();
    feedSubTypeValue = isArabic() ? 'نوع معين الطعام' : 'select feed sub type';
    emit(FormReset());
  }
}
