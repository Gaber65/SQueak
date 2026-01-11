
import 'package:dartz/dartz.dart';
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';

import '../../../../../core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../repositries/socail_login_repo.dart';

 class LoginWithFacebookUseCase extends BaseUseCase<LoginEntity,LoginWithFacebookPrames> {
  final SoicalAuthRepository loginRepository;

  LoginWithFacebookUseCase(this.loginRepository);


  @override
  Future<Either<Failure,LoginEntity>> call(LoginWithFacebookPrames parameters) {
   return loginRepository.signInWithFacebook(parameters);
  }
}

class LoginWithFacebookPrames {
  final String facebookAccessToken;
  final bool isIos;
  final String fbToken;
  final bool isAndroid;

  LoginWithFacebookPrames({
    required this.facebookAccessToken,
    required this.isIos,
    required this.isAndroid,
    required this.fbToken,
  });

  Map<String, dynamic> toJsonFacebook() {
    return {
      'facebookAccessToken': facebookAccessToken,
      'isIos': isIos,
      'isAndroid': isAndroid,
      'fbToken': fbToken,
    };
  }

  Map<String, dynamic> toJsonGoogle() {
    return {
      'googleToken': facebookAccessToken,
      'fbToken': fbToken,
      'iOSDevice': isIos,
      'androidDevice': isAndroid,
    };
  }
}
