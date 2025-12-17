import 'package:dartz/dartz.dart';
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import '../error/failure.dart';

abstract class BaseUseCase<T, Parameters> {
  Future<Either<Failure, T>> call(Parameters parameters);
}

class NoParameters extends Equatable {
  const NoParameters();

  @override
  List<Object> get props => [];
}
