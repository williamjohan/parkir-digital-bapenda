import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/objek_pajak/domain/entities/nop_enitity.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_nop_repository.dart';

@lazySingleton
class NopUsecase {
  final INopRepository _repository;

  NopUsecase(this._repository);

  Future<Either<Failure, NopEntity>> getDashboardSummaryPengawas() {
    return _repository.getNopList();
  }
}
