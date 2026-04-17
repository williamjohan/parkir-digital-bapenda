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
    final difference = end.difference(start).inDays.abs();
    if (difference > 30) {
      if (!isClosed) {
        emit(
          TransactionHistoryError(
            'Rentang waktu maksimal pencarian adalah 30 hari.',
          ),
        );
      }
      return;
    }

    emit(TransactionHistoryLoading());

    final profile = await _secureStorage.getJukirProfile() ?? {};

    // 🚀 [PERBAIKAN 1]: Hapus hard-timeout 10 detik.
    // Biarkan Dio yang handle timeout agar fallback SQLite di UseCase bisa bekerja!
    final result = await _useCase.execute(startDate: start, endDate: end);

    // 🚀 [PERBAIKAN 2]: Cegah Fatal Crash jika Jukir menekan tombol "Back" saat loading!
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
          jukirProfile: profile,
          roda2: data.roda2,
          roda4: data.roda4,
          totalTransaksi: data.jumlahTransaksi,
          totalPendapatan: data.totalPendapatan,
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

    // 🚀 Tambahkan isClosed guard juga untuk amannya
    if (!isClosed) {
      emit(
        currentState.copyWith(
          filteredTransactions: filteredData,
          selectedKategori: newKategori,
          selectedMode: newMode,
        ),
      );
    }
  }
}
