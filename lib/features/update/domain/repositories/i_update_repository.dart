import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/update_entity.dart';

abstract class IUpdateRepository {
  Future<Either<Failure, UpdateEntity?>> checkUpdate();
}
