import '../../domain/entities/clinic_entity.dart';

class ClinicModel extends Clinic {
  const ClinicModel({
    required super.id,
    required super.name,
    required super.location,
    required super.city,
    required super.address,
    required super.phone,
    required super.image,
    required super.code,
    required super.admin,
    required super.specialities,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      city: json['city'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'] ?? '120240808070538549.png',
      code: json['code'],
      admin: json['admin'] == null ? null : AdminModel.fromJson(json['admin']),
      specialities: (json['specialities'] as List)
          .map((e) => SpecialityModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'city': city,
      'address': address,
      'phone': phone,
      'image': image,
      'code': code,
      'admin': admin != null ? (admin as AdminModel).toJson() : null,
      'specialities': (specialities as List<SpecialityModel>)
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

class AdminModel extends AdminEntity {
  const AdminModel({
    required super.id,
    required super.fullName,
    required super.image,
    required super.gender,
    required super.doctorCode,
    required super.specialization,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      fullName: json['fullName'],
      image: json['image'],
      gender: json['gender'],
      doctorCode: json['doctorCode'],
      specialization: json['specialization'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'image': image,
      'gender': gender,
      'doctorCode': doctorCode,
      'specialization': specialization,
    };
  }
}

class SpecialityModel extends SpecialityEntity {
  const SpecialityModel({
    required super.id,
    required super.name,
  });

  factory SpecialityModel.fromJson(Map<String, dynamic> json) {
    return SpecialityModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ClinicInfoModel extends ClinicInfo {
  const ClinicInfoModel({
    required super.data,
    required super.id,
  });

  factory ClinicInfoModel.fromJson(Map<String, dynamic> json) {
    return ClinicInfoModel(
      data: ClinicModel.fromJson(json['clinic']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinic': (data as ClinicModel).toJson(),
      'id': id,
    };
  }
}

class MySupplierModel extends MySupplier {
  const MySupplierModel({
    required super.data,
  });

  factory MySupplierModel.fromJson(Map<String, dynamic> json) {
    return MySupplierModel(
      data:
          (json['clinics'] as List).map((e) => ClinicInfoModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinics': (data as List<ClinicInfoModel>).map((e) => e.toJson()).toList(),
    };
  }
}