import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';

import '../../../../core/base_usecase/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../base_repo/base_vet_repository.dart';
import '../entities/vet_client.dart';

class RegisterVetUseCase extends BaseUseCase<List<VetClient>, RegisterParams> {
  final BaseVetRepository repository;

  RegisterVetUseCase(this.repository);

  @override
  Future<Either<Failure, List<VetClient>>> call(RegisterParams params) async {
    return await repository.register(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      phone: params.phone,
      clientId: params.clientId,
      birthDate: params.birthDate,
      gender: params.gender,
      clinicCode: params.clinicCode,
      countryId: params.countryId,
    );
  }
}

class RegisterParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String clientId;
  final String birthDate;
  final int gender;
  final String clinicCode;
  final int countryId;

  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.clientId,
    required this.birthDate,
    required this.gender,
    required this.clinicCode,
    required this.countryId,
  });

  @override
  List<Object> get props => [
    fullName,
    email,
    password,
    phone,
    clientId,
    birthDate,
    gender,
    clinicCode,
    countryId,
  ];
}

class LoginUseCase extends BaseUseCase<LoginEntity, LoginParams> {
  final BaseVetRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, LoginEntity>> call(LoginParams params) async {
    return await repository.login(
      emailOrPhone: params.emailOrPhone,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String emailOrPhone;
  final String password;

  const LoginParams({required this.emailOrPhone, required this.password});

  @override
  List<Object> get props => [emailOrPhone, password];
}

class GetClientUseCase extends BaseUseCase<dynamic, String> {
  final BaseVetRepository repository;

  GetClientUseCase(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(String invitationCode) async {
    return await repository.getClient(invitationCode);
  }
}
