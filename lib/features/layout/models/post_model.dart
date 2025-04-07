import 'package:squeak/core/helper/image_helper/helper_model/response_model.dart';

class PostModel extends ResponseModel {
  final List<Posts> posts;

  PostModel({
    required this.posts,
    required super.errors,
    required super.message,
    required super.success,
    required super.statusCode,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      posts: List<Posts>.from(
          json['data']['result'].map((x) => Posts.fromJson(x))),
      errors: ResponseModel.fromJson(json).errors,
      message: json['message'],
      statusCode: json['statusCode'],
      success: json['success'],
    );
  }
}

class Posts {
  final String title;
  final String content;
  final int numberOfComments;
  final String? image;
  final String postId;
  final String? video;
  final String createdAt;
  final String? specieId;
  final String? clinicId;
  final ClinicPost clinicPost;
  final SpeciePost? speciePost;

  const Posts({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.video,
    required this.clinicPost,
    required this.specieId,
    required this.speciePost,
    required this.clinicId,
    required this.numberOfComments,
    required this.postId,
    required this.image,
  });

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'],
      video: json['video'],
      clinicPost: ClinicPost.fromJson(json['clinic']),
      specieId: json['specieId'],
      speciePost: json['speciePost'] != null
          ? SpeciePost.fromJson(json['speciePost'])
          : null,
      clinicId: json['clinicId'],
      numberOfComments: json['numberOfComments'],
      postId: json['id'],
      image: json['image'],
    );
  }
}

class ClinicPost {
  final String name;
  final String location;
  final String city;
  final String address;
  final String phone;
  final dynamic code;
  final String image;

  const ClinicPost({
    required this.name,
    required this.location,
    required this.city,
    required this.address,
    required this.phone,
    required this.image,
    required this.code,
  });

  factory ClinicPost.fromJson(Map<String, dynamic> json) {
    return ClinicPost(
      name: json['name'],
      location: json['location'],
      city: json['city'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'] ?? '120240808070538549.png',
      code: json['code'],
    );
  }
}

class SpeciePost {
  final String arType;
  final String enType;

  const SpeciePost({
    required this.arType,
    required this.enType,
  });

  factory SpeciePost.fromJson(Map<String, dynamic> json) {
    return SpeciePost(
      arType: json['arType'],
      enType: json['enType'],
    );
  }
}
