import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../domain/entities/reminder_entity.dart';
import '../../../domain/entities/vaccination_entity.dart';

part 'vaccination_data_state.dart';

class VaccinationDataCubit extends Cubit<VaccinationDataState> {
  final GetVaccinationNamesUseCase getVaccinationNamesUseCase;
  final GetPetRemindersUseCase getPetRemindersUseCase;
  final CreateReminderUseCase createReminderUseCase;
  final UpdateReminderUseCase updateReminderUseCase;
  final DeleteReminderUseCase deleteReminderUseCase;

  VaccinationDataCubit({
    required this.getVaccinationNamesUseCase,
    required this.getPetRemindersUseCase,
    required this.createReminderUseCase,
    required this.updateReminderUseCase,
    required this.deleteReminderUseCase,
  }) : super(VaccinationDataInitial());

  Future<void> getVaccinationNames() async {
    emit(GetVaccinationNamesLoading());

    final result = await getVaccinationNamesUseCase(const NoParameters());

    result.fold(
      (failure) => emit(GetVaccinationNamesError(failure.error.message)),
      (vaccinations) => emit(GetVaccinationNamesSuccess(vaccinations)),
    );
  }

  Future<void> getPetReminders(String petId) async {
    emit(GetPetRemindersLoading());

    final result = await getPetRemindersUseCase(PetIdParams(petId: petId));

    result.fold((failure) {
      emit(GetPetRemindersError(failure.error.message));
    }, (reminders) => emit(GetPetRemindersSuccess(reminders)));
  }

  Future<void> createReminder(ReminderEntity reminder, picked) async {
    emit(CreateReminderLoading());

    final result = await createReminderUseCase(
      ReminderParams(reminder: reminder),
    );

    result.fold((failure) => emit(CreateReminderError(failure.error.message)), (
      _,
    ) async {
      List<String> dateParts = reminder.date.split("-");
      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);

      // print("reminder.notificationID: ${reminder.notificationID}");
      await NotificationScheduler.scheduleReminderNotification(
        id: int.parse(reminder.notificationID),
        title:
            reminder.reminderType.toString() == "other" ||
                    reminder.reminderType.toString() == "أخرى"
                ? reminder.otherTitle.toString()
                : reminder.reminderType.toString(),
        body: handleTheNotificationBodyBasedOnType(
          type: reminder.reminderType.toString(),
          petName: reminder.petName,
        ),
        startDate: DateTime(year, month, day),
        startTime: TimeOfDay(hour: picked!.hour, minute: picked!.minute),
        frequency: reminder.reminderFreq,
      );

      emit(CreateReminderSuccess(reminder.petId));
    });
  }

  Future<void> updateReminder(ReminderEntity reminder) async {
    emit(UpdateReminderLoading());

    final result = await updateReminderUseCase(
      ReminderParams(reminder: reminder),
    );

    result.fold((failure) => emit(UpdateReminderError(failure.error.message)), (
      _,
    ) async {
      List<String> dateParts = reminder.date.split("-");
      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);

      String cleanTime = reminder.time.replaceAll(
        RegExp(r'\s+'),
        '',
      ); // Remove all spaces
      List<String> parts = cleanTime.split(":");
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      await NotificationScheduler.editScheduledNotification(
        notificationId: int.parse(reminder.notificationID),
        newTitle:
            reminder.reminderType.toString() == "other" ||
                    reminder.reminderType.toString() == "أخرى"
                ? reminder.otherTitle.toString()
                : reminder.reminderType.toString(),
        newBody: handleTheNotificationBodyBasedOnType(
          type: reminder.reminderType.toString(),
          petName: reminder.petName,
        ),
        newStartDate: DateTime(year, month, day),
        newStartTime: TimeOfDay(hour: hour, minute: minute),
        newFrequency: reminder.reminderFreq,
      );
      emit(UpdateReminderSuccess());
    });
  }

  Future<void> deleteReminder(int id) async {
    emit(DeleteReminderLoading());

    final result = await deleteReminderUseCase(ReminderIdParams(id: id));

    result.fold(
      (failure) => emit(DeleteReminderError(failure.error.message)),
      (_) => emit(DeleteReminderSuccess()),
    );
  }

  String handleTheNotificationBodyBasedOnType({
    required String type,
    required String petName,
  }) {
    bool isArabicLang = isArabic();

    Map<String, String> messagesEn = {
      "Feed": "Hungry alert! $petName is giving you the \"feed me now\" look!",
      "Grooming":
          "Spa day! $petName is ready for some pampering. Time for grooming!",
      "Clean Potty":
          "Uh-oh! $petName would appreciate a fresh, clean space... if you know what we mean!",
      "Outdoor Walk":
          "Adventure time! $petName is ready to explore the world—let's go for a walk!",
      "Exercise":
          "Workout buddy alert! $petName needs some playtime—time to burn some energy!",
      "Buy Food":
          "Stock up time! $petName just realized the food stash is running low. Better refill before the \"sad eyes\" start!",
      "Flea":
          "Tiny invaders detected! Time to protect $petName from unwanted guests. Flea treatment time!",
      "Deworming":
          "Health check! $petName needs deworming to stay happy and healthy!",
    };

    Map<String, String> messagesAr = {
      "Feed": "جوعان Alert! $petName ينظر إليك بنظرة \"أطْعِمْني حالًا\"!",
      "Grooming":
          "يوم الدلال! $petName مستعد لجلسة عناية وتجميل. حان وقت التهذيب!",
      "Clean Potty":
          "أوه لا! $petName يفضل حمامًا نظيفًا... وأنت تعرف ماذا يعني ذلك!",
      "Outdoor Walk":
          "وقت المغامرة! $petName متحمّس لاستكشاف العالم – لنذهب في نزهة!",
      "Exercise":
          "شريك التمارين مستعد! $petName بحاجة لبعض الحركة واللعب. هيا نبدأ التمارين!",
      "Buy Food":
          "مخزون الطعام في خطر! $petName لاحظ أن الأكل قرب يخلص… تصرف قبل أن يبدأ بنظرات الاستعطاف!",
      "Flea":
          "الغزاة الصغار وصلوا! حان وقت حماية $petName من الضيوف غير المرغوب فيهم!",
      "Deworming":
          "وقت العناية الصحية! $petName يحتاج جرعة التخلص من الديدان ليبقى بصحة وسعادة!",
    };

    return isArabicLang
        ? (messagesAr[type] ?? "تذكير! حان وقت العناية بـ $petName!")
        : (messagesEn[type] ?? "Reminder! Time to take care of $petName!");
  }
}
