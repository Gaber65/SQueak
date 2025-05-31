import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';


class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.date,
    required super.time,
    super.doctorUserId,
    required super.visitId,
    required super.isRating,
    required super.cleanlinessRate,
    required super.doctorServiceRate,
    super.feedbackComment,
    required super.status,
    required super.clientId,
    required super.petId,
    required super.clinicPhone,
    required super.clinicLocation,
    super.clinicLogo,
    required super.clinicCode,
    required super.isBillSqueakVisible,
    required super.clinicId,
    required super.clinicName,
    required super.source,
    required super.client,
    required super.pet,
    required super.temperature,
    required super.weight,
    super.doctorUser,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      isBillSqueakVisible: json['isBillSqueakVisible'],
      doctorUserId: json['doctorUserId'],
      visitId: json['visitId'].toString().contains('00000000')
          ? null
          : json['visitId'],
      isRating: json['isRating'] ?? ((json['cleanlinessRate'] > 0 || json['doctorServiceRate'] > 0)
              ? true
              : (json['cleanlinessRate'] == 0 && json['doctorServiceRate'] == 0)
                  ? false
                  : false),
      cleanlinessRate: json['cleanlinessRate'],
      doctorServiceRate: json['doctorServiceRate'],
      feedbackComment: json['feedbackComment'],
      status: json['statues'],
      clientId: json['clientId'],
      petId: json['petId'],
      clinicPhone: json['clinicPhone'],
      clinicLocation: json['clinicLocation'],
      clinicLogo: json['clinicLogo'],
      clinicCode: json['clinicCode'],
      clinicId: json['clinicId'],
      clinicName: json['clinicName'],
      source: json['source'] ?? 0,
      client: ClientModel.fromJson(json['client']),
      pet: PetModel.fromJson(json['pet']),
      doctorUser: json['doctorUser'] != null
          ? DoctorUserModel.fromJson(json['doctorUser'])
          : null,
      temperature: json['temprature'] ?? 0,
      weight: json['wieght'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
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
      'statues': status,
      'clientId': clientId,
      'petId': petId,
      'clinicPhone': clinicPhone,
      'clinicLocation': clinicLocation,
      'clinicLogo': clinicLogo,
      'clinicCode': clinicCode,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'source': source,
      'client': (client as ClientModel).toJson(),
      'pet': (pet as PetModel).toJson(),
      'doctorUser': doctorUser != null ? (doctorUser as DoctorUserModel).toJson() : null,
      'wieght': weight,
      'temprature': temperature,
    };
  }
}

class ClientModel extends ClientEntity {
  const ClientModel({
    super.name,
    super.phone,
    super.gender,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      name: json['name'],
      phone: json['phone'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'gender': gender,
    };
  }
}

class PetModel extends PetEntityAppointment {
  const PetModel({
    super.name,
    super.gender,
    super.squeakPetId,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      name: json['name'],
      gender: json['gender'],
      squeakPetId: json['squeakPetId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'squeakPetId': squeakPetId,
      'gender': gender,
    };
  }
}

class DoctorUserModel extends DoctorUserEntity {
  const DoctorUserModel({
    super.fullName,
    super.imageName,
  });

  factory DoctorUserModel.fromJson(Map<String, dynamic> json) {
    return DoctorUserModel(
      fullName: json['fullName'],
      imageName: json['imageName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'imageName': imageName,
    };
  }
}