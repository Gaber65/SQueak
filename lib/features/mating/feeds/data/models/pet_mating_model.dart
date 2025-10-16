import '../../domain/entities/pet_mating_entity.dart';

class PetMatingModel extends PetMatingEntity {
  @override
  final String id;
  @override
  final String name;
  @override
  final String breed;
  @override
  final String gender;
  @override
  final String age;
  @override
  final String? description;
  @override
  final String profilePicture;
  @override
  final PetMatingStatus status;
  @override
  final String? passportNumber;

  PetMatingModel({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.age,
    this.description,
    required this.profilePicture,
    required this.status,
    this.passportNumber,
  });

  factory PetMatingModel.fromJson(Map<String, dynamic> json) {
    return PetMatingModel(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      gender: json['gender'],
      age: json['age'],
      description: json['description'],
      profilePicture: json['profilePicture'],
      status: PetMatingStatus.values[json['status']],
      passportNumber: json['passportNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'gender': gender,
      'age': age,
      'description': description,
      'profilePicture': profilePicture,
      'status': status.index,
      'passportNumber': passportNumber,
    };
  }

  static List<PetMatingModel> get availablePets => [
    PetMatingModel(
      id: 'available-1',
      name: 'Bella',
      breed: 'Golden Retriever',
      gender: 'Female',
      age: '2 years',
      description: 'Friendly and loves to play fetch!',
      profilePicture: 'assets/images/bella.jpg',
      status: PetMatingStatus.availableForMating,
    ),
    PetMatingModel(
      id: 'available-2',
      name: 'Max',
      breed: 'German Shepherd',
      gender: 'Male',
      age: '3 years',
      description: 'Very gentle and well-trained',
      profilePicture: 'assets/images/max.jpg',
      status: PetMatingStatus.availableForMating,
    ),
    PetMatingModel(
      id: 'available-3',
      name: 'Luna',
      breed: 'Persian Cat',
      gender: 'Female',
      age: '1.5 years',
      description: 'Sweet and affectionate',
      profilePicture: 'assets/images/luna.jpg',
      status: PetMatingStatus.availableForMating,
    ),
  ];
}