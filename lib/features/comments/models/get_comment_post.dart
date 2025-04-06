import 'package:equatable/equatable.dart';

class Comments extends Equatable {
  Comments({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.image,
    this.petId,
    required this.userId,
    required this.postId,
    required this.parentId,
    this.pet,
    required this.user,
    required this.replies,
    this.isSelected = false,
  });

  List<Comments> replies;
  final String id;
  bool isSelected;
  final String content;
  final dynamic image;
  final dynamic petId;
  final dynamic parentId;
  final dynamic createdAt;
  final String userId;
  final String postId;
  final PetDate? pet;
  final UserData? user;

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      content: json['content'],
      replies:
          (json['replies'] as List).map((e) => Comments.fromJson(e)).toList(),
      image: json['image'],
      petId: json['petId'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      parentId: json['parentId'],
      postId: json['postId'],
      pet: json['pet'] != null ? PetDate.fromJson(json['pet']) : null,
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        content,
        image,
        petId,
        userId,
        postId,
        pet,
        user,
      ];
}

class UserData extends Equatable {
  const UserData({
    required this.fullName,
    required this.address,
    required this.imageName,
    required this.birthDate,
  });

  final dynamic fullName;
  final dynamic address;
  final dynamic imageName;
  final dynamic birthDate;

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      fullName: json['fullName'],
      address: json['address'],
      imageName: json['imageName'],
      birthDate: json['birthDate'],
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        address,
        imageName,
        birthDate,
      ];
}

class PetDate extends Equatable {
  const PetDate({
    required this.petName,
    required this.gender,
    required this.breedId,
    required this.imageName,
  });

  final dynamic petName;
  final dynamic gender;
  final dynamic breedId;
  final dynamic imageName;

  factory PetDate.fromJson(Map<String, dynamic> json) {
    return PetDate(
      petName: json['petName'],
      gender: json['gender'],
      breedId: json['breedId'],
      imageName: json['imageName'],
    );
  }
  @override
  List<Object> get props => [
        petName,
        gender,
        breedId,
        imageName,
      ];
}
