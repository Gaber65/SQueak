class MySupplierModel {
  List<ClinicInfo> data;

  MySupplierModel({
    required this.data,
  });

  factory MySupplierModel.fromJson(Map<String, dynamic> json) {
    return MySupplierModel(
      data:
          (json['clinics'] as List).map((e) => ClinicInfo.fromJson(e)).toList(),
    );
  }
}

class ClinicInfo {
  Clinic data;
  String id;

  ClinicInfo({
    required this.data,
    required this.id,
  });

  factory ClinicInfo.fromJson(Map<String, dynamic> json) {
    return ClinicInfo(
      data: Clinic.fromJson(json['clinic']),
      id: json['id'],
    );
  }
}

class Clinic {
  String id;
  String name;
  String location;
  String city;
  String address;
  String phone;
  String image;
  String code;
  Admin? admin;
  List<Speciality> specialities;

  Clinic({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.address,
    required this.phone,
    required this.image,
    required this.code,
    required this.admin,
    required this.specialities,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      city: json['city'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'] ?? '120240808070538549.png',
      code: json['code'],
      admin: json['admin'] == null ? null : Admin.fromJson(json['admin']),
      specialities: (json['specialities'] as List)
          .map((e) => Speciality.fromJson(e))
          .toList(),
    );
  }
}

class Admin {
  String id;
  String fullName;
  dynamic image;
  int gender;
  dynamic doctorCode;
  dynamic specialization;

  Admin({
    required this.id,
    required this.fullName,
    required this.image,
    required this.gender,
    required this.doctorCode,
    required this.specialization,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      fullName: json['fullName'],
      image: json['image'],
      gender: json['gender'],
      doctorCode: json['doctorCode'],
      specialization: json['specialization'],
    );
  }
}

class Speciality {
  String id;
  String name;

  Speciality({
    required this.id,
    required this.name,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}
