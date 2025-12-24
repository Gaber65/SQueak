import 'package:dartz/dartz.dart';
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';
import '../../../../../core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../repositries/socail_login_repo.dart';
import 'login_with_facebook.dart';

 class LoginWithGoogleUseCase extends BaseUseCase<LoginEntity,LoginWithFacebookPrames> {
  final SoicalAuthRepository loginRepository;

  LoginWithGoogleUseCase(this.loginRepository);


  @override
  Future<Either<Failure,LoginEntity>> call(LoginWithFacebookPrames parameters) {
    return loginRepository.signInWithGoogle(parameters);
  }
}
