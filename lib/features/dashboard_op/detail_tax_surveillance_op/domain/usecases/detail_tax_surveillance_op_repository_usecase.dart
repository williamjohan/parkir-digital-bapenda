import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/detail_tax_surveillance_op_entity.dart';
import '../repositories/i_detail_tax_surveillance_op_repository.dart';

@lazySingleton
class TaxSurveillanceUseCase {
  final ITaxSurveillanceRepository _repository;
  TaxSurveillanceUseCase(this._repository);

  Future<Either<Failure, List<TaxSurveillanceDetailResponseEntity>>>
  getDefaultDetail(String nop) {
    return _repository.getDefaultDetail(nop);
  }

  Future<Either<Failure, List<TaxSurveillanceDetailResponseEntity>>>
  getFilteredDetail(TaxSurveillanceRequestEntity params) {
    return _repository.getFilteredDetail(params);
  }
}
