class CountryEntity {
  final int id;
  final String name;
  final String phoneCode;

  const CountryEntity({
    required this.id,
    required this.name,
    required this.phoneCode,
  });

  Map toMap() => {'id': id, 'name': name, 'phoneCode': phoneCode};
}
