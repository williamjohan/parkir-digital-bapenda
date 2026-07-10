// domain/usecases/get_sof_breakdown_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/sof_summary_model.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_transaction_history_repository.dart';

@lazySingleton
class GetSofBreakdownUseCase {
  final ITransactionHistoryRepository _repository;

  GetSofBreakdownUseCase(this._repository);

  Future<Either<Failure, List<SofSummaryModel>>> execute({
    required String nop,
    required DateTime startDate,
    required DateTime endDate,
    required int jenisKendaraan,
  }) {
    return _repository.getSofBreakdown(
      nop: nop,
      startDate: startDate,
      endDate: endDate,
      jenisKendaraan: jenisKendaraan,
    );
  }
}