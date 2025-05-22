class CountryModel {
  final dynamic id;
  final dynamic name;
  final dynamic phoneCode;

  CountryModel({required this.id, required this.name, required this.phoneCode});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(id: json['id'], name: json['name'], phoneCode: json['phoneCode'],);
  }}