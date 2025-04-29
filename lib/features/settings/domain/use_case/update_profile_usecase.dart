import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';

import '../../../../core/base_usecase/base_usecase.dart';
import '../base_repo/profile_repository.dart';
import '../entities/owner_entite.dart';

class UpdateProfileUseCase extends BaseUseCase<Owner, UpdateProfileParameters> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Owner>> call(UpdateProfileParameters parameters) async {
    return await repository.updateProfile(
      fullName: parameters.fullName,
      address: parameters.address,
      imageName: parameters.imageName,
      birthDate: parameters.birthDate,
      gender: parameters.gender,
    );
  }
}

class UpdateProfileParameters extends Equatable {
  final String fullName;
  final String address;
  final String imageName;
  final String birthDate;
  final int gender;

  const UpdateProfileParameters({
    required this.fullName,
    required this.address,
    required this.imageName,
    required this.birthDate,
    required this.gender,
  });

  @override
  List<Object> get props => [fullName, address, imageName, birthDate, gender];
}