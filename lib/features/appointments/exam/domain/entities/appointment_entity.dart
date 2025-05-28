import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String date;
  final String time;
  final String? doctorUserId;
  final String? visitId;
  final bool isRating;
  final bool isBillSqueakVisible;
  final int cleanlinessRate;
  final int doctorServiceRate;
  final String? feedbackComment;
  final int status;
  final String clientId;
  final String petId;
  final String clinicPhone;
  final String clinicLocation;
  final String? clinicLogo;
  final String clinicCode;
  final String clinicId;
  final String clinicName;
  final int source;
  final ClientEntity client;
  final PetEntityAppointment pet;
  final DoctorUserEntity? doctorUser;
  final int weight;
  final int temperature;

  const AppointmentEntity({
    required this.id,
    required this.date,
    required this.time,
    this.doctorUserId,
    required this.visitId,
    required this.isRating,
    required this.cleanlinessRate,
    required this.doctorServiceRate,
    this.feedbackComment,
    required this.status,
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
    required this.temperature,
    required this.weight,
    this.doctorUser,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    time,
    doctorUserId,
    visitId,
    isRating,
    cleanlinessRate,
    doctorServiceRate,
    feedbackComment,
    status,
    clientId,
    petId,
    clinicPhone,
    clinicLocation,
    clinicLogo,
    clinicCode,
    clinicId,
    clinicName,
    source,
    client,
    pet,
    doctorUser,
    temperature,
    weight,
  ];

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date,
    'time': time,
    'doctorUserId': doctorUserId,
    'visitId': visitId,
    'isRating': isRating,
    'cleanlinessRate': cleanlinessRate,
    'doctorServiceRate': doctorServiceRate,
    'feedbackComment': feedbackComment,
    'status': status,
    'clientId': clientId,
    'petId': petId,
    'clinicPhone': clinicPhone,
    'clinicLocation': clinicLocation,
    'clinicLogo': clinicLogo,
    'clinicCode': clinicCode,
    'isBillSqueakVisible': isBillSqueakVisible,
    'clinicId': clinicId,
    'clinicName': clinicName,
    'source': source,
    'client': client.toMap(),
    'pet': pet.toMap(),
    'doctorUser': doctorUser?.toMap(),
    'temperature': temperature,
    'weight': weight,
  };
}

class ClientEntity extends Equatable {
  final String? name;
  final String? phone;
  final int? gender;

  const ClientEntity({
    this.name,
    this.phone,
    this.gender,
  });

  @override
  List<Object?> get props => [name, phone, gender];

  Map<String, dynamic> toMap() => {
    'name': name,
    'phone': phone,
    'gender': gender,
  };
}

class PetEntityAppointment extends Equatable {
  final String? name;
  final String? squeakPetId;
  final int? gender;

  const PetEntityAppointment({
    this.name,
    this.gender,
    this.squeakPetId,
  });

  @override
  List<Object?> get props => [name, gender, squeakPetId];
  Map<String, dynamic> toMap() => {
    'name': name,
    'gender': gender,
    'squeakPetId': squeakPetId,
  };
}

class DoctorUserEntity extends Equatable {
  final String? fullName;
  final String? imageName;

  const DoctorUserEntity({
    this.fullName,
    this.imageName,
  });

  @override
  List<Object?> get props => [fullName, imageName];

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'imageName': imageName,
  };
}