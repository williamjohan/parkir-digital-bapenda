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
          const TransactionHistoryError(
            'Rentang waktu maksimal pencarian adalah 30 hari.',
          ),
        );
      }
      return;
    }

    emit(TransactionHistoryLoading());

    final profile = await _secureStorage.getJukirProfile() ?? {};

    final result = await _useCase.execute(startDate: start, endDate: end);

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

          // Data Rekap Asli (Semua Transaksi)
          roda2: data.roda2,
          roda4: data.roda4,
          totalTransaksi: data.jumlahTransaksi,
          totalPendapatan: data.totalPendapatan,

          //  INJEKSI DATA FINANSIAL KE STATE
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

    // 1. Eksekusi Filter
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

    //  2. REKALKULASI REKAPITULASI (Dinamic Recap)
    // Agar angka di Header mengikuti hasil filter yang ada di layar
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

          // 🚀 TIMPA DATA REKAP DENGAN HASIL FILTER
          roda2: filterRoda2,
          roda4: filterRoda4,
          totalTransaksi: filteredData.length,
          totalPendapatan: filterKotor,
          totalPajak: filterPajak,
          totalBersih: filterBersih,
        ),
      );
    }
  }
}
