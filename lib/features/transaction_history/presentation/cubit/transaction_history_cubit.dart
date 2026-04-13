// lib/features/transaction_history/presentation/cubit/transaction_history_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import 'transaction_history_state.dart';

@injectable
class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final GetTransactionHistoryUseCase _useCase;
  final ISecureStorageManager _secureStorage;

  TransactionHistoryCubit(this._useCase, this._secureStorage)
    : super(TransactionHistoryInitial());

  /// [REMOTE FILTER]: Tembak API Bapenda berdasarkan rentang tanggal
  Future<void> fetchHistory(DateTime start, DateTime end) async {
    // 🚀 [SISTEM PERTAHANAN]: Validasi Selisih 30 Hari
    // Kita gunakan .abs() untuk berjaga-jaga jika Jukir terbalik memasukkan tanggal
    final difference = end.difference(start).inDays.abs();

    if (difference > 30) {
      emit(
        TransactionHistoryError(
          'Rentang waktu maksimal pencarian adalah 30 hari.',
        ),
      );
      return; // 🛑 Hentikan eksekusi, cegah payload membengkak!
    }

    // Jika lolos validasi, baru mulai proses loading
    emit(TransactionHistoryLoading());

    final profile = await _secureStorage.getJukirProfile() ?? {};
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
          jukirProfile: profile,
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

    emit(
      currentState.copyWith(
        filteredTransactions: filteredData,
        selectedKategori: newKategori,
        selectedMode: newMode,
      ),
    );
  }
}
