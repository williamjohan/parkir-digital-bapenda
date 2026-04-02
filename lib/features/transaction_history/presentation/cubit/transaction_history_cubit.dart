// lib/features/transaction_history/presentation/cubit/transaction_history_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import 'transaction_history_state.dart';

@injectable
class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final GetTransactionHistoryUseCase _useCase;

  TransactionHistoryCubit(this._useCase) : super(TransactionHistoryInitial());

  /// [REMOTE FILTER]: Tembak API Bapenda berdasarkan rentang tanggal
  Future<void> fetchHistory(DateTime start, DateTime end) async {
    emit(TransactionHistoryLoading());

    final result = await _useCase.execute(startDate: start, endDate: end);

    result.fold(
      (failure) => emit(TransactionHistoryError(failure.message)),
      (data) => emit(
        TransactionHistoryLoaded(
          allTransactions: data,
          filteredTransactions: data, // Awalnya tampilkan semua
          startDate: start,
          endDate: end,
          selectedKategori: 'SEMUA',
          selectedMode: -1,
        ),
      ),
    );
  }

  /// [LOCAL FILTER]: Menyortir data yang sudah ada di memori secara instan
  void applyLocalFilter({String? kategori, int? mode}) {
    if (state is! TransactionHistoryLoaded) return;

    final currentState = state as TransactionHistoryLoaded;

    // Gunakan filter baru, atau pertahankan filter lama jika tidak diubah
    final newKategori = kategori ?? currentState.selectedKategori;
    final newMode = mode ?? currentState.selectedMode;

    // Proses penyaringan (Filtering) dari Master Data
    final filteredData = currentState.allTransactions.where((trx) {
      // 1. Cek Kategori
      bool passKategori = true;
      if (newKategori != 'SEMUA') {
        passKategori =
            trx.jenisTarif.toUpperCase() == newKategori.toUpperCase();
      }

      // 2. Cek Mode Plat
      bool passMode = true;
      if (newMode != -1) {
        passMode = trx.modePlat == newMode;
      }

      // Harus lolos kedua filter untuk bisa tampil
      return passKategori && passMode;
    }).toList();

    // Perbarui state UI dengan data yang sudah disaring
    emit(
      currentState.copyWith(
        filteredTransactions: filteredData,
        selectedKategori: newKategori,
        selectedMode: newMode,
      ),
    );
  }
}
