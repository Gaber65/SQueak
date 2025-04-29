class SupplierEntitySearch {
  final List<ClinicInfoEntitySearch> clinics;

  SupplierEntitySearch({
    required this.clinics,
  });
}

class ClinicInfoEntitySearch {
  final ClinicEntitySearch clinic;
  final String id;

  ClinicInfoEntitySearch({
    required this.clinic,
    required this.id,
  });
}

class ClinicEntitySearch {
  final String id;
  final String name;
  final String location;
  final String city;
  final String address;
  final String phone;
  final String image;
  final String code;
  final AdminEntitySearch? admin;
  final List<SpecialityEntitySearch> specialities;

  ClinicEntitySearch({
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
}

class AdminEntitySearch {
  final String id;
  final String fullName;
  final dynamic image;
  final int gender;
  final dynamic doctorCode;
  final dynamic specialization;

  AdminEntitySearch({
    required this.id,
    required this.fullName,
    required this.image,
    required this.gender,
    required this.doctorCode,
    required this.specialization,
  });
}

class SpecialityEntitySearch {
  final String id;
  final String name;

  SpecialityEntitySearch({
    required this.id,
    required this.name,
  });
}
