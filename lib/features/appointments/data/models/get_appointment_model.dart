import '../../../generated/l10n.dart';

class AppointmentModel {
  final String id;
  final String date;
  final String time;
  final String? doctorUserId;
  final String? visitId;
  final bool isRating;
  final bool isBillSqueakVisible;
  bool isPrint;
  final int cleanlinessRate;
  final int doctorServiceRate;
  final String? feedbackComment;
  final int statues;
  final String clientId;
  final String petId;
  final String clinicPhone;
  final String clinicLocation;
  final String? clinicLogo;
  final String clinicCode;
  final String clinicId;
  final String clinicName;
  final int source;
  final Client client;
  final Pet pet;
  final DoctorUser? doctorUser;
  final int wieght;
  final int temprature;

  AppointmentModel({
    required this.id,
    required this.date,
    required this.time,
    this.doctorUserId,
    this.isPrint = false,
    required this.visitId,
    required this.isRating,
    required this.cleanlinessRate,
    required this.doctorServiceRate,
    this.feedbackComment,
    required this.statues,
    required this.clientId,
    required this.petId,
    required this.clinicPhone,
    required this.clinicLocation,
    this.clinicLogo,
    required this.clinicCode,
    required this.isBillSqueakVisible,
    required this.clinicId,
    required this.clinicName,
    required this.source,
    required this.client,
    required this.pet,
    required this.temprature,
    required this.wieght,
    this.doctorUser,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      isBillSqueakVisible: json['isBillSqueakVisible'] ?? false,
      doctorUserId: json['doctorUserId'],
      isPrint: false,
      visitId: json['visitId'].toString().contains('00000000')
          ? null
          : json['visitId'],
      isRating: json['isRating'] == null
          ? (json['cleanlinessRate'] > 0 || json['doctorServiceRate'] > 0)
              ? true
              : (json['cleanlinessRate'] == 0 && json['doctorServiceRate'] == 0)
                  ? false
                  : null
          : json['isRating'],
      cleanlinessRate: json['cleanlinessRate'],
      doctorServiceRate: json['doctorServiceRate'],
      feedbackComment: json['feedbackComment'],
      statues: json['statues'],
      clientId: json['clientId'],
      petId: json['petId'],
      clinicPhone: json['clinicPhone'],
      clinicLocation: json['clinicLocation'],
      clinicLogo: json['clinicLogo'],
      clinicCode: json['clinicCode'],
      clinicId: json['clinicId'],
      clinicName: json['clinicName'],
      source: json['source'] ?? 0,
      client: Client.fromJson(json['client']),
      pet: Pet.fromJson(json['pet']),
      doctorUser: json['doctorUser'] != null
          ? DoctorUser.fromJson(json['doctorUser'])
          : null,
      temprature: json['temprature'] == null ? 0 :json['temprature'],
      wieght: json['wieght'] == null  ? 0 : json['wieght'] ,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'doctorUserId': doctorUserId,
      'visitId': visitId,
      'isRating': isRating,
      'cleanlinessRate': cleanlinessRate,
      'doctorServiceRate': doctorServiceRate,
      'feedbackComment': feedbackComment,
      'statues': statues,
      'clientId': clientId,
      'petId': petId,
      'clinicPhone': clinicPhone,
      'clinicLocation': clinicLocation,
      'clinicLogo': clinicLogo,
      'clinicCode': clinicCode,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'source': source,
      'client': client.toMap(),
      'pet': pet.toMap(),
      'doctorUser': doctorUser,
      'wieght': wieght,
      'temprature': temprature,
    };
  }
}

class Client {
  String? name;
  String? phone;
  int? gender;

  Client({
    this.name,
    this.phone,
    this.gender,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'],
      phone: json['phone'],
      gender: json['gender'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'gender': gender,
    };
  }
}

class Pet {
  String? name;
  String?squeakPetId;
  int? gender;

  Pet({
    this.name,
    this.gender,
    this.squeakPetId,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'],
      gender: json['gender'],
      squeakPetId: json['squeakPetId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'squeakPetId': squeakPetId,
      'gender': gender,
    };
  }
}

class DoctorUser {
  String? fullName;
  String? imageName;

  DoctorUser({
    this.fullName,
    this.imageName,
  });

  factory DoctorUser.fromJson(Map<String, dynamic> json) {
    return DoctorUser(
      fullName: json['fullName'],
      imageName: json['imageName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'imageName': imageName,
    };
  }
}

// Enum for Appointment States
enum AppointmentState {
  Reserved,
  Start_Examination,
  End_Examination,
  Finished,
  Attended,
  Cancel
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
        AppointmentState.Reserved, S.of(context).appointmentsReserved),
    StateAppointment(
        AppointmentState.Attended, S.of(context).appointmentsAttended),
    StateAppointment(AppointmentState.Start_Examination,
        S.of(context).appointmentsStartExamination),
    StateAppointment(AppointmentState.End_Examination,
        S.of(context).appointmentsEndExamination),
    StateAppointment(
        AppointmentState.Finished, S.of(context).appointmentsFinished),
    StateAppointment(
        AppointmentState.Cancel, S.of(context).appointmentsCanceled),
  ];
}
