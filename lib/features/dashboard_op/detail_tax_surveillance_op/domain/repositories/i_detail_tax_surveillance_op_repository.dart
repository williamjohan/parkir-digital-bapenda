import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/detail_tax_surveillance_op_entity.dart';

abstract class ITaxSurveillanceRepository {
  /// Kontrak 1: GET Default Hari Ini
  Future<Either<Failure, List<TaxSurveillanceDetailResponseEntity>>>
  getDefaultDetail(String nop);

  /// Kontrak 2: POST Filter menggunakan RequestEntity
  Future<Either<Failure, List<TaxSurveillanceDetailResponseEntity>>>
  getFilteredDetail(TaxSurveillanceRequestEntity requestEntity);
}
