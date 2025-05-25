class ClinicBoardEntity {
  String? id;
  String code;
  int? unit;
  String name;
  bool? isActive;
  double price;

  ClinicBoardEntity({
    this.id,
    required this.code,
    this.unit,
    required this.name,
    this.isActive,
    required this.price,
  });

  factory ClinicBoardEntity.fromJson(Map<String, dynamic> json) {
    return ClinicBoardEntity(
      id: json['id'] as String?,
      code: json['code'] as String,
      unit: json['unit'] as int?,
      name: json['name'] as String,
      isActive: json['isActive'] as bool?,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'unit': unit,
      'name': name,
      'isActive': isActive,
      'price': price,
    };
  }


}

class Cage {
  String name;
  String description;

  Cage({
    required this.name,
    required this.description,
  });

  factory Cage.fromJson(Map<String, dynamic> json) {
    return Cage(
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  static List<Cage> dummyCages = [
    Cage(
      name: 'Large Cage',
      description: 'A spacious cage suitable for larger pets.',
    ),
    Cage(
      name: 'Medium Cage',
      description: 'A medium-sized cage for small to medium pets.',
    ),
    Cage(
      name: 'Small Cage',
      description: 'A cozy cage perfect for smaller animals.',
    ),
    Cage(
      name: 'Outdoor Cage',
      description: 'A durable cage designed for outdoor use.',
    ),
    Cage(
      name: 'Travel Cage',
      description: 'A portable cage for travel and transportation.',
    ),
  ];
}
