import 'package:dartz/dartz.dart';
import 'package:squeak/features/auth/login/data/models/login_data_model.dart';
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';

import '../../../../../core/error/failure.dart';
import '../usecses/login_with_facebook.dart';

abstract class SoicalAuthRepository {
  Future<Either<Failure,LoginEntity>> signInWithFacebook(LoginWithFacebookPrames params);

  Future<Either<Failure,LoginEntity>> signInWithGoogle(LoginWithFacebookPrames params);
}
