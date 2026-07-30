import 'package:dartz/dartz.dart';
import 'package:parkir_digital_bapenda/features/objek_pajak/domain/entities/nop_enitity.dart';
import '../../../../core/errors/failure.dart';

abstract class INopRepository {
  Future<Either<Failure, NopEntity>> getNopList();
}
