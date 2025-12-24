import 'package:dartz/dartz.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/error/failure.dart';
import '../../domin/entities/login_entity.dart';
import '../../domin/repositries/socail_login_repo.dart';
import '../../domin/usecses/login_with_facebook.dart';
import '../datasources/socail_auth_data_source.dart';

class SocialRepo implements SoicalAuthRepository {
  final SocailAuthRemoteDataSource remoteDataSource;

  SocialRepo(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginEntity>> signInWithFacebook(
    LoginWithFacebookPrames params,
  ) async {
    try {
      final res = await remoteDataSource.signInFacebook(params);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, LoginEntity>> signInWithGoogle(
    LoginWithFacebookPrames params,
  ) async {
    try {
      final res = await remoteDataSource.signInGoogle(params);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }
}
