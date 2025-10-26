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
    // Local helpers to safely parse values from potentially inconsistent API responses
    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      final s = v.toString();
      return int.tryParse(s) ?? 0;
    }

    num toNum(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v;
      final s = v.toString();
      return num.tryParse(s) ?? 0;
    }

    final String id = json['id']?.toString() ?? '';
    final String date = json['data']?.toString() ?? '';
    final String time = json['time']?.toString() ?? '';
    final bool isBillSqueakVisible = json['isBillSqueakVisible'] ?? false;
    final String? doctorUserId = json['doctorUserId']?.toString();
    final String? visitId = () {
      final v = json['visitId'];
      if (v == null) return null;
      final s = v.toString();
      return s.contains('00000000') ? null : s;
    }();

    final int cleanlinessRate = toInt(json['cleanlinessRate']);
    final int doctorServiceRate = toInt(json['doctorServiceRate']);

    final bool isRating = json['isRating'] ?? (cleanlinessRate > 0 || doctorServiceRate > 0);

    final String? feedbackComment = json['feedbackComment']?.toString();
    final dynamic status = json['status'] ?? json['statues'] ?? 0;
    final String clientId = json['clientId']?.toString() ?? '';
    final String petId = json['petId']?.toString() ?? '';
    final String clinicPhone = json['clinicPhone']?.toString() ?? '';
    final String clinicLocation = json['clinicLocation']?.toString() ?? '';
    final String? clinicLogo = json['clinicLogo']?.toString();
    final String clinicCode = json['clinicCode']?.toString() ?? '';
    final String clinicId = json['clinicId']?.toString() ?? '';
    final String clinicName = json['clinicName']?.toString() ?? '';
    final int source = toInt(json['source']);

    final client = json['client'] != null
        ? ClientModel.fromJson(Map<String, dynamic>.from(json['client']))
        : const ClientModel();

    final pet = json['pet'] != null
        ? PetModel.fromJson(Map<String, dynamic>.from(json['pet']))
        : const PetModel();

    final DoctorUserModel? doctorUser = json['doctorUser'] != null
        ? DoctorUserModel.fromJson(Map<String, dynamic>.from(json['doctorUser']))
        : null;

    final num temperature = toNum(json['temprature'] ?? json['temperature']);
    final num weight = toNum(json['wieght'] ?? json['weight']);

    return AppointmentModel(
      id: id,
      date: date,
      time: time,
      isBillSqueakVisible: isBillSqueakVisible,
      doctorUserId: doctorUserId,
      visitId: visitId,
      isRating: isRating,
      cleanlinessRate: cleanlinessRate,
      doctorServiceRate: doctorServiceRate,
      feedbackComment: feedbackComment,
      status: status,
      clientId: clientId,
      petId: petId,
      clinicPhone: clinicPhone,
      clinicLocation: clinicLocation,
      clinicLogo: clinicLogo,
      clinicCode: clinicCode,
      clinicId: clinicId,
      clinicName: clinicName,
      source: source,
      client: client,
      pet: pet,
      doctorUser: doctorUser,
      temperature: temperature,
      weight: weight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': date,
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
      'clinicId': clinicId,
      'clinicName': clinicName,
      'source': source,
      'client': (client as ClientModel).toJson(),
      'pet': (pet as PetModel).toJson(),
      'doctorUser': doctorUser != null ? (doctorUser as DoctorUserModel).toJson() : null,
      'weight': weight,
      'temperature': temperature,
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