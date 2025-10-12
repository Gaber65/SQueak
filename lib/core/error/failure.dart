// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

abstract class Failure extends Equatable {
  final ErrorMessageModel error;

  const Failure(this.error);

  @override
  List<Object> get props => [error];
}

class ServerFailure extends Failure {
  const ServerFailure(super.error);
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure(super.error);
}
