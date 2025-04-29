import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.content,
    required super.createdAt,
    required super.image,
    super.petId,
    required super.userId,
    required super.postId,
    required super.parentId,
    super.pet,
    super.user,
    required super.replies,
    super.isSelected = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      petId: json['petId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      userId: json['userId'] ?? '',
      postId: json['postId'] ?? '',
      parentId: json['parentId'],
      pet: json['pet'] != null ? PetModelComment.fromJson(json['pet']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      replies:
          json['replies'] == null
              ? []
              : (json['replies'] as List)
                  .map((e) => CommentModel.fromJson(e))
                  .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'image': image,
    'petId': petId,
    'createdAt': createdAt,
    'userId': userId,
    'postId': postId,
    'parentId': parentId,
    'pet': pet is PetModelComment ? (pet as PetModelComment).toJson() : null,
    'user': (user as UserModel).toJson(),
    'replies': replies.map((e) => (e as CommentModel).toJson()).toList(),
  };
}

class UserModel extends UserEntity {
  const UserModel({
    required super.fullName,
    required super.address,
    required super.imageName,
    required super.birthDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      address: json['address'],
      imageName: json['imageName'],
      birthDate: json['birthDate'],
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'address': address,
    'imageName': imageName,
    'birthDate': birthDate,
  };
}

class PetModelComment extends PetEntityComment {
  const PetModelComment({
    required super.petName,
    required super.gender,
    required super.breedId,
    required super.imageName,
  });

  factory PetModelComment.fromJson(Map<String, dynamic> json) {
    return PetModelComment(
      petName: json['petName'],
      gender: json['gender'],
      breedId: json['breedId'],
      imageName: json['imageName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'petName': petName,
    'gender': gender,
    'breedId': breedId,
    'imageName': imageName,
  };
}
