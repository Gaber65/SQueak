class PetConnectionDto {
  final String petId;               
  final String fullName;
  final String image;
  final bool isOnline;
  final List<String> connectionIds;

  PetConnectionDto({
    required this.petId,
    required this.fullName,
    required this.image,
    required this.isOnline,
    required this.connectionIds,
  });

  factory PetConnectionDto.fromJson(Map<String, dynamic> json) {
    return PetConnectionDto(
      petId: json['PetId'] ?? '',
      fullName: json['FullName'] ?? '',
      image: json['Image'] ?? '',
      isOnline: json['IsOnline'] ?? false,
      connectionIds: List<String>.from(json['ConnectionIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petId': petId,
      'fullName': fullName,
      'image': image,
      'isOnline': isOnline,
      'connectionIds': connectionIds,
    };
  }
}
