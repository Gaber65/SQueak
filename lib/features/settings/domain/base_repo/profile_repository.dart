import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/owner_entite.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Owner>> getOwnerData();
  Future<Either<Failure, Owner>> updateProfile({
    required String fullName,
    required String address,
    required String imageName,
    required String birthDate,
    required int gender,
  });
}
