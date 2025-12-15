// ignore_for_file: constant_identifier_names

import '../export_path/export_files.dart';

enum DayOfWeek {
  sunday, // 0
  monday, // 1
  tuesday, // 2
  wednesday, // 3
  thursday, // 4
  friday, // 5
  saturday, // 6
}

extension DayOfWeekExtension on DayOfWeek {
  static DayOfWeek fromInt(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0:
        return DayOfWeek.sunday;
      case 1:
        return DayOfWeek.monday;
      case 2:
        return DayOfWeek.tuesday;
      case 3:
        return DayOfWeek.wednesday;
      case 4:
        return DayOfWeek.thursday;
      case 5:
        return DayOfWeek.friday;
      case 6:
        return DayOfWeek.saturday;
      default:
        throw Exception('Invalid day of week');
    }
  }

  int toInt() {
    switch (this) {
      case DayOfWeek.sunday:
        return 0;
      case DayOfWeek.monday:
        return 1;
      case DayOfWeek.tuesday:
        return 2;
      case DayOfWeek.wednesday:
        return 3;
      case DayOfWeek.thursday:
        return 4;
      case DayOfWeek.friday:
        return 5;
      case DayOfWeek.saturday:
        return 6;
    }
  }
}

enum AppointmentState {
  Reserved,
  Start_Examination,
  End_Examination,
  Finished,
  Attended,
  Cancel,
}

// Class Definition
class StateAppointment {
  final AppointmentState state;
  final String key;

  StateAppointment(this.state, this.key);
}

// Dummy Data Generation
List<StateAppointment> generateDummyDataState(context) {
  return [
    StateAppointment(
      AppointmentState.Reserved,
      S.of(context).appointmentsReserved,
    ),
    StateAppointment(
      AppointmentState.Attended,
      S.of(context).appointmentsAttended,
    ),
    StateAppointment(
      AppointmentState.Start_Examination,
      S.of(context).appointmentsStartExamination,
    ),
    StateAppointment(
      AppointmentState.End_Examination,
      S.of(context).appointmentsEndExamination,
    ),
    StateAppointment(
      AppointmentState.Finished,
      S.of(context).appointmentsFinished,
    ),
    StateAppointment(
      AppointmentState.Cancel,
      S.of(context).appointmentsCanceled,
    ),
  ];
}
