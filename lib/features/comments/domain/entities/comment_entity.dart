import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  CommentEntity({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.image,
    this.petId,
    required this.userId,
    required this.postId,
    required this.parentId,
    this.pet,
    this.user,
    required this.replies,
    this.isSelected = false,
  });

  final String id;
  final String content;
  final dynamic image;
  final dynamic petId;
  final dynamic parentId;
  final dynamic createdAt;
  final String userId;
  final String postId;
  final PetEntityComment? pet;
  final UserEntity? user;
  List<CommentEntity> replies;
  bool isSelected;

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
    replies,
    isSelected,
  ];

  CommentEntity copyWith({List<CommentEntity>? replies}) {
    return CommentEntity(
      id: id,
      content: content,
      createdAt: createdAt,
      image: image,
      petId: petId,
      userId: userId,
      postId: postId,
      parentId: parentId,
      pet: pet,
      user: user,
      replies: replies ?? this.replies,
      isSelected: isSelected,
    );
  }
}

class UserEntity extends Equatable {
  const UserEntity({
    required this.fullName,
    required this.address,
    required this.imageName,
    required this.birthDate,
  });

  final dynamic fullName;
  final dynamic address;
  final dynamic imageName;
  final dynamic birthDate;

  @override
  List<Object?> get props => [fullName, address, imageName, birthDate];
}

class PetEntityComment extends Equatable {
  const PetEntityComment({
    required this.petName,
    required this.gender,
    required this.breedId,
    required this.imageName,
  });

  final dynamic petName;
  final dynamic gender;
  final dynamic breedId;
  final dynamic imageName;

  @override
  List<Object?> get props => [petName, gender, breedId, imageName];
}
