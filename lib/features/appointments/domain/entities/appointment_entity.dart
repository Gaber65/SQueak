class AppointmentEntity {
  final String id;
  final String petId;
  final String clientId;
  final String doctorId;
  final String clinicId;
  final String startTime;
  final String endTime;
  final String appointmentDate;
  final String note;
  final int status;
  final String reason;
  final bool isPetCheckIn;
  final String createDate;
  final DoctorEntity? doctor;
  final PetEntity? pet;
  final ClinicEntity? clinic;

  AppointmentEntity({
    required this.id,
    required this.petId,
    required this.clientId,
    required this.doctorId,
    required this.clinicId,
    required this.startTime,
    required this.endTime,
    required this.appointmentDate,
    required this.note,
    required this.status,
    required this.reason,
    required this.isPetCheckIn,
    required this.createDate,
    this.doctor,
    this.pet,
    this.clinic,
  });
}

class DoctorEntity {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String imageName;

  DoctorEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.imageName,
  });
}

class PetEntity {
  final String id;
  final String petName;
  final String imageName;

  PetEntity({
    required this.id,
    required this.petName,
    required this.imageName,
  });
}

class ClinicEntity {
  final String id;
  final String name;
  final String address;

  ClinicEntity({
    required this.id,
    required this.name,
    required this.address,
  });
} 