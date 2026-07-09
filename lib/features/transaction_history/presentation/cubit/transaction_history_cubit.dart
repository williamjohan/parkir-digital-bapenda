import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/i_secure_storage_manager.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import 'transaction_history_state.dart';

@injectable
class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final GetTransactionHistoryUseCase _useCase;
  final ISecureStorageManager _secureStorage;

  TransactionHistoryCubit(this._useCase, this._secureStorage)
    : super(TransactionHistoryInitial());

  /// [REMOTE FILTER]: Tembak API Bapenda berdasarkan rentang tanggal
  Future<void> fetchHistory(
    DateTime start,
    DateTime end,
    String nop,
    String idDevice,
  ) async {
    final difference = end.difference(start).inDays.abs();
    if (difference > 30) {
      if (!isClosed) {
        emit(
          const TransactionHistoryError(
            'Rentang waktu maksimal pencarian adalah 30 hari.',
          ),
        );
      }
      return;
    }

    emit(TransactionHistoryLoading());

    String finalNop = nop;

    if (nop.trim().isEmpty) {
      final profile = await _secureStorage.getJukirProfile() ?? {};
      finalNop = profile['nop']?.toString() ?? '';
    }

    final result = await _useCase.execute(
      startDate: start,
      endDate: end,
      nop: finalNop,
      idDevice: idDevice,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(TransactionHistoryError(failure.message)),
      (data) => emit(
        TransactionHistoryLoaded(
          allTransactions: data.detail,
          filteredTransactions: data.detail,
          startDate: start,
          endDate: end,
          selectedKategori: 'SEMUA',
          selectedMode: -1,
          roda2: data.roda2,
          roda4: data.roda4,
          totalTransaksi: data.jumlahTransaksi,
          totalPendapatan: data.totalPendapatan,
          totalPajak: data.totalPendapatanBapenda,
          totalBersih: data.totalPendapatanWajibPajak,
          persentasePajak: data.detail.isNotEmpty
              ? data.detail.first.tarifPajak
              : 0,
        ),
      ),
    );
  }

  /// [LOCAL FILTER]: Menyortir data yang sudah ada di memori secara instan
  void applyLocalFilter({String? kategori, int? mode}) {
    if (state is! TransactionHistoryLoaded) return;

    final currentState = state as TransactionHistoryLoaded;

    final newKategori = kategori ?? currentState.selectedKategori;
    final newMode = mode ?? currentState.selectedMode;
    final filteredData = currentState.allTransactions.where((trx) {
      bool passKategori = true;
      if (newKategori != 'SEMUA') {
        passKategori =
            trx.jenisTarif.toUpperCase() == newKategori.toUpperCase();
      }

      bool passMode = true;
      if (newMode != -1) {
        passMode = trx.modePlat == newMode;
      }

      return passKategori && passMode;
    }).toList();
    int filterRoda2 = 0;
    int filterRoda4 = 0;
    int filterKotor = 0;
    double filterPajak = 0;
    double filterBersih = 0;

    for (final trx in filteredData) {
      if (trx.jenisTarif == 'MOTOR') filterRoda2++;
      if (trx.jenisTarif == 'MOBIL') filterRoda4++;

      filterKotor += trx.kredit;

      final double hitungPajak = (trx.kredit * trx.tarifPajak) / 100;
      filterPajak += hitungPajak;
      filterBersih += (trx.kredit - hitungPajak);
    }

    if (!isClosed) {
      emit(
        currentState.copyWith(
          filteredTransactions: filteredData,
          selectedKategori: newKategori,
          selectedMode: newMode,
          roda2: filterRoda2,
          roda4: filterRoda4,
          totalTransaksi: filteredData.length,
          totalPendapatan: filterKotor,
          totalPajak: filterPajak,
          totalBersih: filterBersih,
          visibleCount: 5,
        ),
      );
    }
  }

  void loadMoreItems() {
    if (state is! TransactionHistoryLoaded) return;
    final currentState = state as TransactionHistoryLoaded;

    if (!currentState.hasMore) return;

    final nextCount = currentState.visibleCount + 5;
    final cappedCount = nextCount > currentState.filteredTransactions.length
        ? currentState.filteredTransactions.length
        : nextCount;

    if (!isClosed) {
      emit(currentState.copyWith(visibleCount: cappedCount));
    }
  }
}
