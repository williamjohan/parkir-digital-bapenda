// lib/features/transaction_history/presentation/cubit/transaction_history_cubit.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
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
      emit(
        TransactionHistoryError(
          'Rentang waktu maksimal pencarian adalah 30 hari.',
        ),
      );
      return;
    }

    emit(TransactionHistoryLoading());

    final profile = await _secureStorage.getJukirProfile() ?? {};

    // ✅ Timeout 10 detik — jika lewat, usecase fallback ke lokal
    final result = await _useCase
        .execute(startDate: start, endDate: end)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () =>
              const Left(ServerFailure('Koneksi lambat. Coba lagi.')),
        );

    result.fold(
      (failure) => emit(TransactionHistoryError(failure.message)),
      (data) => emit(
        TransactionHistoryLoaded(
          allTransactions: data,
          filteredTransactions: data,
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
