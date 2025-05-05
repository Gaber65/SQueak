import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/failure.dart';
import '../entities/version_entity.dart';

abstract class LayoutRepository {
  Future<Either<Failure, VersionEntity>> getVersion();
  Future<Either<Failure, String>> getCurrentAppVersion();
}
