import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../error/failure.dart';

Future<Either<Failure, File>> pickImageFromGallery() async {
  final picker = ImagePicker();

  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return Right(File(pickedFile.path));
    } else {
      return Left(ServerFailure('No image selected'));
    }
  } catch (e) {
    debugPrint('Error picking image: $e');
    return Left(ServerFailure('Failed to pick image'));
  }
}
