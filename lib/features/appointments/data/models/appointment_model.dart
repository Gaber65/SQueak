import '../../domain/entities/appointment_entity.dart';

class AppointmentData extends AppointmentEntity {
  AppointmentData({
    required super.id,
    required super.petId,
    required super.clientId,
    required super.doctorId,
    required super.clinicId,
    required super.startTime,
    required super.endTime,
    required super.appointmentDate,
    required super.note,
    required super.status,
    required super.reason,
    required super.isPetCheckIn,
    required super.createDate,
    super.doctor,
    super.pet,
    super.clinic,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      id: json['id'] ?? '',
      petId: json['petId'] ?? '',
      clientId: json['clientId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      clinicId: json['clinicId'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      appointmentDate: json['appointmentDate'] ?? '',
      note: json['note'] ?? '',
      status: json['status'] ?? 0,
      reason: json['reason'] ?? '',
      isPetCheckIn: json['isPetCheckIn'] ?? false,
      createDate: json['createDate'] ?? '',
      doctor: json['doctor'] != null ? DoctorData.fromJson(json['doctor']) : null,
      pet: json['pet'] != null ? PetData.fromJson(json['pet']) : null,
      clinic: json['clinic'] != null ? ClinicData.fromJson(json['clinic']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'clientId': clientId,
      'doctorId': doctorId,
      'clinicId': clinicId,
      'startTime': startTime,
      'endTime': endTime,
      'appointmentDate': appointmentDate,
      'note': note,
      'status': status,
      'reason': reason,
      'isPetCheckIn': isPetCheckIn,
      'createDate': createDate,
    };
  }
}

class DoctorData extends DoctorEntity {
  DoctorData({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.imageName,
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) {
    return DoctorData(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      imageName: json['imageName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageName': imageName,
    };
  }
}

class PetData extends PetEntity {
  PetData({
    required super.id,
    required super.petName,
    required super.imageName,
  });

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      id: json['id'] ?? '',
      petName: json['petName'] ?? '',
      imageName: json['imageName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petName': petName,
      'imageName': imageName,
    };
  }
}

class ClinicData extends ClinicEntity {
  ClinicData({
    required super.id,
    required super.name,
    required super.address,
  });

  factory ClinicData.fromJson(Map<String, dynamic> json) {
    return ClinicData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }
} 