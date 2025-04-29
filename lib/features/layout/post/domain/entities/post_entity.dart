class PostEntity {
  final String title;
  final String content;
  final int numberOfComments;
  final String? image;
  final String postId;
  final String? video;
  final String createdAt;
  final String? specieId;
  final String? clinicId;
  final ClinicEntity clinic;
  final SpecieEntity? specie;

  const PostEntity({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.video,
    required this.clinic,
    required this.specieId,
    required this.specie,
    required this.clinicId,
    required this.numberOfComments,
    required this.postId,
    required this.image,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      title: json['title'],
      content: json['content'],
      numberOfComments: json['numberOfComments'],
      image: json['image'],
      postId: json['postId'],
      video: json['video'],
      createdAt: json['createdAt'],
      specieId: json['specieId'],
      clinicId: json['clinicId'],
      clinic: ClinicEntity.fromJson(json['clinic']),
      specie: json['specie'] != null ? SpecieEntity.fromJson(json['specie']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'numberOfComments': numberOfComments,
      'image': image,
      'postId': postId,
      'video': video,
      'createdAt': createdAt,
      'specieId': specieId,
      'clinicId': clinicId,
      'clinic': clinic.toJson(),
      'specie': specie?.toJson(),
    };
  }
}
class ClinicEntity {
  final String name;
  final String location;
  final String city;
  final String address;
  final String phone;
  final dynamic code;
  final String image;

  const ClinicEntity({
    required this.name,
    required this.location,
    required this.city,
    required this.address,
    required this.phone,
    required this.image,
    required this.code,
  });

  factory ClinicEntity.fromJson(Map<String, dynamic> json) {
    return ClinicEntity(
      name: json['name'],
      location: json['location'],
      city: json['city'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'],
      code: json['code'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'city': city,
      'address': address,
      'phone': phone,
      'code': code,
      'image': image,
    };
  }

}
class SpecieEntity {
  final String arType;
  final String enType;

  const SpecieEntity({
    required this.arType,
    required this.enType,
  });

  factory SpecieEntity.fromJson(Map<String, dynamic> json) {
    return SpecieEntity(
      arType: json['arType'],
      enType: json['enType'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'arType': arType,
      'enType': enType,
    };
  }

}
