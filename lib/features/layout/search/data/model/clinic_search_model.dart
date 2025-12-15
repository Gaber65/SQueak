// data/models/supplier_model_search.dart

import '../../domain/entities/clinic_search_entity.dart';

class SupplierModelSearch extends SupplierEntitySearch {
  SupplierModelSearch({required List<ClinicInfoModelSearch> clinics})
    : super(clinics: clinics);

  factory SupplierModelSearch.fromJson(Map<String, dynamic> json) {
    return SupplierModelSearch(
      clinics:
          (json['clinics'] as List)
              .map((e) => ClinicInfoModelSearch.fromJson(e))
              .toList(),
    );
  }
}

class ClinicInfoModelSearch extends ClinicInfoEntitySearch {
  ClinicInfoModelSearch({
    required ClinicModelSearch super.clinic,
    required super.id,
  });

  factory ClinicInfoModelSearch.fromJson(Map<String, dynamic> json) {
    return ClinicInfoModelSearch(
      clinic: ClinicModelSearch.fromJson(json['clinic']),
      id: json['id'] ?? '',
    );
  }
}

class ClinicModelSearch extends ClinicEntitySearch {
  ClinicModelSearch({
    required super.id,
    required super.name,
    required super.location,
    required super.city,
    required super.address,
    required super.phone,
    required super.image,
    required super.code,
    required AdminModelSearch? super.admin,
    required List<SpecialityModelSearch> super.specialities,
  });

  factory ClinicModelSearch.fromJson(Map<String, dynamic> json) {
    return ClinicModelSearch(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'] ?? '',
      code: json['code'] ?? '',
      admin:
          json['admin'] == null
              ? null
              : AdminModelSearch.fromJson(json['admin']),
      specialities:
          json['specialities'] == null
              ? []
              : (json['specialities'] as List)
                  .map((e) => SpecialityModelSearch.fromJson(e))
                  .toList(),
    );
  }
}

class AdminModelSearch extends AdminEntitySearch {
  AdminModelSearch({
    required super.id,
    required super.fullName,
    required super.image,
    required super.gender,
    required super.doctorCode,
    required super.specialization,
  });

  factory AdminModelSearch.fromJson(Map<String, dynamic> json) {
    return AdminModelSearch(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      image: json['image'],
      gender: json['gender'] ?? 0,
      doctorCode: json['doctorCode'],
      specialization: json['specialization'],
    );
  }
}

class SpecialityModelSearch extends SpecialityEntitySearch {
  SpecialityModelSearch({required super.id, required super.name});

  factory SpecialityModelSearch.fromJson(Map<String, dynamic> json) {
    return SpecialityModelSearch(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
