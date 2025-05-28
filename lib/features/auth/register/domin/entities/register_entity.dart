class RegisterEntity {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final int countryId;
  final String? followCode;
  final int gender;
  final bool shareData;

  const RegisterEntity({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.countryId,
    this.followCode,
    this.gender = 1,
    this.shareData = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phone,
      'email': email,
      'password': password,
      'countryId': countryId,
      'gender': gender,
      if (followCode != null) 'followCode': followCode,
      'allToShareDataWithVetICare': shareData,
    };
  }
  Map<String, dynamic> toMapRegister() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'countryId': countryId,
      'Gender': gender,
      'PasswordConfirm': password,
      'userName': email,
      'userType': 1,
      if (followCode != null) 'followCode': followCode,
      'allToShareDataWithVetICare': shareData,
    };
  }
}